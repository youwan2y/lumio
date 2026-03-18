/// 用户信息模型
class UserProfile {
  final String? constellation;  // 星座
  final int? age;               // 年龄
  final bool isOnboarded;       // 是否已完成首次登录（保留字段以兼容）

  const UserProfile({
    this.constellation,
    this.age,
    this.isOnboarded = true,  // 默认为 true
  });

  UserProfile copyWith({
    String? constellation,
    int? age,
    bool? isOnboarded,
  }) {
    return UserProfile(
      constellation: constellation ?? this.constellation,
      age: age ?? this.age,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

/// 随机元素池 - 用于 AI 智能选择
class RandomElementPool {
  // 地区/场景
  static const List<String> locations = [
    'Asian zen garden',  // 亚洲禅意花园
    'European castle',  // 欧洲城堡
    'Japanese temple',  // 日本寺庙
    'Tropical island',  // 热带岛屿
    'Mountain peak',  // 山峰
    'Ocean depths',  // 海洋深处
    'Desert oasis',  // 沙漠绿洲
    'Northern lights sky',  // 极光天空
    'Space nebula',  // 太空星云
    'Forest pathway',  // 森林小径
    'City skyline',  // 城市天际线
    'Underwater world',  // 水下世界
    'Meadow field',  // 草地田野
    'Arctic glacier',  // 北极冰川
    'Ancient ruins',  // 古代遗迹
  ];

  // 艺术风格
  static const List<String> artStyles = [
    'watercolor painting',  // 水彩画
    'oil painting',  // 油画
    'digital art',  // 数字艺术
    'cyberpunk style',  // 赛博朋克
    'minimalist design',  // 极简设计
    'impressionist',  // 印象派
    'surrealist',  // 超现实主义
    'anime style',  // 动漫风格
    'photorealistic',  // 照片写实
    'abstract art',  // 抽象艺术
    'vintage retro',  // 复古风格
    'futuristic',  // 未来主义
    'fantasy art',  // 奇幻艺术
    '3D render',  // 3D渲染
    'pencil sketch',  // 铅笔素描
  ];

  // 具体元素/物体
  static const List<String> elements = [
    'cherry blossoms',  // 樱花
    'stars and galaxies',  // 星星和星系
    'crystal formations',  // 水晶结构
    'floating lanterns',  // 漂浮的灯笼
    'butterflies',  // 蝴蝶
    'aurora borealis',  // 极光
    'waterfalls',  // 瀑布
    'geometric patterns',  // 几何图案
    'sacred geometry',  // 神圣几何
    'mandala patterns',  // 曼陀罗图案
    'lotus flowers',  // 莲花
    'bamboo forest',  // 竹林
    'neon lights',  // 霓虹灯
    'mist and fog',  // 雾气
    'rainbow colors',  // 彩虹色
    'golden hour light',  // 黄金时刻光线
    'moon and stars',  // 月亮和星星
    'clouds and sky',  // 云和天空
    'mountain silhouettes',  // 山脉剪影
    'ocean waves',  // 海浪
  ];

  // 色调/氛围
  static const List<String> atmospheres = [
    'warm golden tones',  // 暖金色调
    'cool blue hues',  // 冷蓝色调
    'pastel colors',  // 柔和色调
    'vibrant colors',  // 鲜艳色彩
    'monochrome',  // 单色
    'gradient colors',  // 渐变色
    'dreamy soft',  // 梦幻柔和
    'dramatic contrast',  // 戏剧性对比
    'ethereal glow',  // 空灵光芒
    'mysterious dark',  // 神秘暗色
  ];

  // 时间/光影
  static const List<String> lighting = [
    'golden hour',  // 黄金时刻
    'blue hour',  // 蓝调时刻
    'moonlit night',  // 月夜
    'sunrise',  // 日出
    'sunset',  // 日落
    'starlit sky',  // 星空
    'dramatic shadows',  // 戏剧性阴影
    'soft diffused light',  // 柔和漫射光
    'backlit silhouette',  // 逆光剪影
    'candlelight',  // 烛光
  ];

  /// Fisher-Yates 洗牌算法 - 使用随机种子
  static List<String> shuffleList(List<String> list, int seed) {
    final shuffled = List<String>.from(list);
    var currentSeed = seed;

    // 简单的伪随机数生成器
    int nextRandom(int max) {
      currentSeed = (currentSeed * 1103515245 + 12345) & 0x7fffffff;
      return currentSeed % max;
    }

    // Fisher-Yates 洗牌
    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = nextRandom(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// 第一阶段：随机缩小元素池
  static Map<String, List<String>> getRandomSubset({
    required int seed,
    int locationCount = 5,
    int styleCount = 5,
    int elementCount = 10,
    int atmosphereCount = 5,
    int lightingCount = 5,
  }) {
    return {
      'locations': shuffleList(locations, seed).take(locationCount).toList(),
      'artStyles': shuffleList(artStyles, seed + 1).take(styleCount).toList(),
      'elements': shuffleList(elements, seed + 2).take(elementCount).toList(),
      'atmospheres': shuffleList(atmospheres, seed + 3).take(atmosphereCount).toList(),
      'lighting': shuffleList(lighting, seed + 4).take(lightingCount).toList(),
    };
  }
}

/// 用户回答模型
class UserAnswer {
  final double mood;      // 心情 0-1
  final double energy;    // 能量 0-1
  final double style;     // 风格 0-1
  final String? input;    // 用户输入
  final UserProfile? userProfile;  // 用户信息
  final String? weather;  // 天气信息
  final List<String>? randomElements;  // 随机元素

  const UserAnswer({
    this.mood = 0.5,
    this.energy = 0.5,
    this.style = 0.5,
    this.input,
    this.userProfile,
    this.weather,
    this.randomElements,
  });

  UserAnswer copyWith({
    double? mood,
    double? energy,
    double? style,
    String? input,
    UserProfile? userProfile,
    String? weather,
    List<String>? randomElements,
  }) {
    return UserAnswer(
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      style: style ?? this.style,
      input: input ?? this.input,
      userProfile: userProfile ?? this.userProfile,
      weather: weather ?? this.weather,
      randomElements: randomElements ?? this.randomElements,
    );
  }

  /// 生成发送给 LLM 的提示词（已废弃，改用 LlmService 中的两步生成）
  @deprecated
  String toPrompt() {
    final moodDesc = mood < 0.33 ? '平静内敛' : mood < 0.66 ? '温和舒适' : '热情活力';
    final energyDesc = energy < 0.33 ? '宁静祥和' : energy < 0.66 ? '自然平衡' : '动感冒险';
    final styleDesc = style < 0.33 ? '抽象艺术' : style < 0.66 ? '印象风格' : '写实细节';

    // 添加用户信息
    final userInfo = StringBuffer();
    if (userProfile != null) {
      if (userProfile!.constellation != null) {
        userInfo.write('用户星座: ${userProfile!.constellation}\n');
      }
      if (userProfile!.age != null) {
        userInfo.write('用户年龄: ${userProfile!.age}岁\n');
      }
    }

    // 添加随机元素
    final randomInfo = StringBuffer();
    if (randomElements != null && randomElements!.isNotEmpty) {
      randomInfo.write('\n创意元素:\n');
      for (final element in randomElements!) {
        randomInfo.write('- $element\n');
      }
    }

    return '''
请根据以下用户偏好和创意元素，生成一个适合作为手机壁纸的图像描述。

用户心情: $moodDesc
期待能量: $energyDesc
画面风格: $styleDesc
${userInfo.isNotEmpty ? userInfo.toString() : ''}${weather != null && weather!.isNotEmpty ? '今日天气: $weather\n' : ''}${input != null && input!.isNotEmpty ? '额外想法: $input\n' : ''}$randomInfo
要求:
1. 描述要富有意境和画面感
2. 适合作为壁纸使用
3. 用英文输出，便于图像生成
4. 控制在100词以内
5. 可以结合用户的星座和年龄特征来设计画面
6. 如果有天气信息，可以融入天气元素
7. **重要**: 必须将上述"创意元素"中的至少2-3个元素自然融入到画面描述中，创造独特而富有变化的场景
''';
  }
}

/// 壁纸模型
class Wallpaper {
  final String id;
  final String imageUrl;
  final String? thumbnailUrl;  // 缩略图URL
  final String description;
  final bool isRevealed;
  final bool isSelected;

  const Wallpaper({
    required this.id,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.description,
    this.isRevealed = false,
    this.isSelected = false,
  });

  Wallpaper copyWith({
    String? id,
    String? imageUrl,
    String? thumbnailUrl,
    String? description,
    bool? isRevealed,
    bool? isSelected,
  }) {
    return Wallpaper(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
      isRevealed: isRevealed ?? this.isRevealed,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// 问题模型
class Question {
  final String title;
  final String subtitle;
  final String minLabel;
  final String maxLabel;

  const Question({
    required this.title,
    required this.subtitle,
    required this.minLabel,
    required this.maxLabel,
  });
}

/// 预设问题
class Questions {
  static const List<Question> all = [
    Question(
      title: '你今天的心情如何?',
      subtitle: '选择你此刻的情绪状态',
      minLabel: '平静',
      maxLabel: '狂喜',
    ),
    Question(
      title: '你期待什么样的能量?',
      subtitle: '选择你想感受到的氛围',
      minLabel: '内省',
      maxLabel: '冒险',
    ),
    Question(
      title: '你喜欢什么样的风格?',
      subtitle: '选择你偏好的视觉风格',
      minLabel: '抽象',
      maxLabel: '写实',
    ),
  ];
}
