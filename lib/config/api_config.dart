/// API 配置
class ApiConfig {
  // 通义千问 LLM API
  static const String llmBaseUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  static const String llmApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';
  static const String llmModel = 'qwen-flash';

  // 豆包图像生成 API (火山引擎)
  static const String imageBaseUrl = 'https://ark.cn-beijing.volces.com/api/v3';
  static const String imageApiKey = '12649d93-d763-471c-9ede-024382c0d26f';
  static const String imageModel = 'doubao-seedream-5-0-260128';
}
