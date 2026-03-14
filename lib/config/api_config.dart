/// API 配置
class ApiConfig {
  // 通义千问 LLM API
  static const String llmBaseUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  static const String llmApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';
  static const String llmModel = 'qwen-flash';

  // GLM-Image 图像生成 API (智谱 AI)
  static const String imageBaseUrl = 'https://open.bigmodel.cn/api/paas/v4';
  static const String imageApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';  // 使用相同的 API Key
  static const String imageModel = 'glm-image';
}
