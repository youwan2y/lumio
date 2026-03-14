import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/models.dart';

/// LLM 服务 - 两步生成
class LlmService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.llmBaseUrl,
      headers: {
        'Authorization': 'Bearer ${ApiConfig.llmApiKey}',
        'Content-Type': 'application/json',
      },
    ),
  );

  /// 第一步：智能选择创意元素（两阶段）
  ///
  /// 第一阶段：随机缩小元素池（使用随机种子）
  /// 第二阶段：AI 从缩小的池中智能选择
  Future<List<String>> selectElements(UserAnswer answer) async {
    try {
      // 生成随机种子
      final seed = DateTime.now().millisecondsSinceEpoch;
      print('🎲 随机种子: $seed');

      // 第一阶段：随机缩小元素池
      print('\n第一阶段：随机缩小元素池');
      final subset = RandomElementPool.getRandomSubset(
        seed: seed,
        locationCount: 5,
        styleCount: 5,
        elementCount: 10,
        atmosphereCount: 5,
        lightingCount: 5,
      );

      // 打印缩小的池
      print('├─ 地区 (5/15): ${subset['locations']!.take(3).join(", ")}...');
      print('├─ 风格 (5/15): ${subset['artStyles']!.take(3).join(", ")}...');
      print('├─ 元素 (10/20): ${subset['elements']!.take(5).join(", ")}...');
      print('├─ 氛围 (5/10): ${subset['atmospheres']!.take(3).join(", ")}...');
      print('└─ 光影 (5/10): ${subset['lighting']!.take(3).join(", ")}...');

      // 构建缩小池的 Prompt
      final poolInfo = '''
【随机选中的候选元素】

地区/场景（选0-1个）:
${subset['locations']!.map((e) => '- $e').join('\n')}

艺术风格（选0-1个）:
${subset['artStyles']!.map((e) => '- $e').join('\n')}

具体元素（选2-3个）:
${subset['elements']!.map((e) => '- $e').join('\n')}

氛围色调（选0-1个）:
${subset['atmospheres']!.map((e) => '- $e').join('\n')}

光影时间（选0-1个）:
${subset['lighting']!.map((e) => '- $e').join('\n')}

当前时间: ${DateTime.now().toString()}
随机种子: $seed
''';

      // 构建用户上下文
      final moodDesc = answer.mood < 0.33 ? '平静内敛' : answer.mood < 0.66 ? '温和舒适' : '热情活力';
      final energyDesc = answer.energy < 0.33 ? '宁静祥和' : answer.energy < 0.66 ? '自然平衡' : '动感冒险';
      final styleDesc = answer.style < 0.33 ? '抽象艺术' : answer.style < 0.66 ? '印象风格' : '写实细节';

      final userContext = StringBuffer();
      userContext.write('用户心情: $moodDesc\n');
      userContext.write('期待能量: $energyDesc\n');
      userContext.write('画面风格: $styleDesc\n');

      if (answer.userProfile != null) {
        if (answer.userProfile!.constellation != null) {
          userContext.write('用户星座: ${answer.userProfile!.constellation}\n');
        }
        if (answer.userProfile!.age != null) {
          userContext.write('用户年龄: ${answer.userProfile!.age}岁\n');
        }
      }

      if (answer.weather != null && answer.weather!.isNotEmpty) {
        userContext.write('今日天气: ${answer.weather}\n');
      }

      if (answer.input != null && answer.input!.isNotEmpty) {
        userContext.write('额外想法: ${answer.input}\n');
      }

      // 第二阶段：AI 从缩小池中智能选择
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': ApiConfig.llmModel,
          'messages': [
            {
              'role': 'system',
              'content': '''你是一个创意元素选择专家。

【重要】你将收到一组随机选中的候选元素池（30个候选）。
请从这些候选中，选择最协调、最符合用户特征的 4-6 个元素。

选择原则：
1. 【重要】只能从给定的候选池中选择，不要选择池外的元素
2. 优先考虑元素之间的协调性和美感
3. 结合用户的星座、心情、天气特征
4. 创造独特而富有美感的组合
5. 【重要】避免最常见或最安全的组合，要有创意和惊喜感
6. 每次选择都要不同，要有创新性

返回格式（只返回JSON，不要其他文字）:
{
  "elements": ["元素1", "元素2", "元素3", ...]
}''',
            },
            {
              'role': 'user',
              'content': '''用户信息:
$userContext

$poolInfo

请从这些候选中选择最合适的4-6个元素。
【重要】要有创意，避免选择最常见或最安全的组合！''',
            },
          ],
          'temperature': 1.0,  // 提高创造性
          'max_tokens': 300,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;

      // 解析 JSON
      try {
        final jsonStart = content.indexOf('{');
        final jsonEnd = content.lastIndexOf('}') + 1;
        final jsonStr = content.substring(jsonStart, jsonEnd);

        // 简单的 JSON 解析
        final match = RegExp(r'"elements"\s*:\s*\[(.*?)\]').firstMatch(jsonStr);
        if (match != null) {
          final elementsStr = match.group(1)!;
          final elements = RegExp(r'"([^"]+)"')
              .allMatches(elementsStr)
              .map((m) => m.group(1)!)
              .toList();

          print('\n第二阶段：AI 智能选择');
          print('🎯 AI 选择的元素: ${elements.join(", ")}');

          return elements;
        }
      } catch (e) {
        print('JSON 解析失败: $e');
      }

      // 如果解析失败，提取引号中的内容
      final elements = RegExp(r'"([^"]+)"')
          .allMatches(content)
          .map((m) => m.group(1)!)
          .where((e) => e.length > 3)
          .take(5)
          .toList();

      print('\n第二阶段：AI 智能选择（备用提取）');
      print('🎯 AI 选择的元素: ${elements.join(", ")}');

      return elements.isNotEmpty ? elements : ['cherry blossoms', 'watercolor painting', 'dreamy soft'];
    } catch (e) {
      throw Exception('选择元素失败: $e');
    }
  }

  /// 第二步：生成壁纸描述
  ///
  /// 根据用户信息和 AI 选择的元素，生成详细的图像描述
  Future<String> generateDescription(UserAnswer answer, List<String> elements) async {
    try {
      // 构建用户上下文
      final moodDesc = answer.mood < 0.33 ? '平静内敛' : answer.mood < 0.66 ? '温和舒适' : '热情活力';
      final energyDesc = answer.energy < 0.33 ? '宁静祥和' : answer.energy < 0.66 ? '自然平衡' : '动感冒险';
      final styleDesc = answer.style < 0.33 ? '抽象艺术' : answer.style < 0.66 ? '印象风格' : '写实细节';

      final userInfo = StringBuffer();
      userInfo.write('用户心情: $moodDesc\n');
      userInfo.write('期待能量: $energyDesc\n');
      userInfo.write('画面风格: $styleDesc\n');

      if (answer.userProfile != null) {
        if (answer.userProfile!.constellation != null) {
          userInfo.write('用户星座: ${answer.userProfile!.constellation}\n');
        }
        if (answer.userProfile!.age != null) {
          userInfo.write('用户年龄: ${answer.userProfile!.age}岁\n');
        }
      }

      if (answer.weather != null && answer.weather!.isNotEmpty) {
        userInfo.write('今日天气: ${answer.weather}\n');
      }

      if (answer.input != null && answer.input!.isNotEmpty) {
        userInfo.write('额外想法: ${answer.input}\n');
      }

      final elementsInfo = elements.map((e) => '- $e').join('\n');

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': ApiConfig.llmModel,
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的壁纸描述生成专家。根据用户的心情、偏好和选定的创意元素，生成富有意境和画面感的英文壁纸描述，用于AI图像生成。',
            },
            {
              'role': 'user',
              'content': '''请根据以下信息，生成一个适合作为手机壁纸的图像描述。

用户信息:
$userInfo

选定的创意元素:
$elementsInfo

要求:
1. 必须自然融合上述所有创意元素到画面中
2. 描述要富有意境和画面感，富有诗意
3. 适合作为壁纸使用，构图要美观
4. 用英文输出，便于图像生成
5. 控制在 80-100 词以内
6. 突出画面的视觉焦点和情感氛围
7. 确保元素之间的协调性和美感
''',
            },
          ],
          'temperature': 0.8,
          'max_tokens': 200,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      return content.trim();
    } catch (e) {
      throw Exception('生成描述失败: $e');
    }
  }
}

/// 天气服务
class WeatherService {
  final Dio _dio = Dio();

  /// 获取天气信息（使用免费的wttr.in API）
  Future<String> getCurrentWeather() async {
    try {
      final response = await _dio.get(
        'https://wttr.in/?format=%C+%t',
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      // 返回天气描述，例如："Partly cloudy +15°C"
      return response.data.toString().trim();
    } catch (e) {
      // 如果获取天气失败，返回空字符串
      print('获取天气失败: $e');
      return '';
    }
  }
}

/// 图像生成服务
class ImageService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.imageBaseUrl,
      headers: {
        'Authorization': 'Bearer ${ApiConfig.imageApiKey}',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  /// 生成单张壁纸图片（使用 GLM-Image API）
  Future<Wallpaper> generateWallpaper(String description) async {
    try {
      final response = await _dio.post(
        '/images/generations',
        data: {
          'model': ApiConfig.imageModel,  // glm-image
          'prompt': '$description, wallpaper style, high quality, beautiful',
          'quality': 'hd',  // glm-image 只支持 hd
          'size': '1280x1280',  // 推荐尺寸
          'watermark_enabled': false,  // 去掉官方水印
        },
      );

      final imageUrl = response.data['data'][0]['url'] as String;
      print('🖼️ 图片生成成功: $imageUrl');
      return Wallpaper(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        imageUrl: imageUrl,
        description: description,
      );
    } catch (e) {
      throw Exception('生成壁纸失败: $e');
    }
  }
}
