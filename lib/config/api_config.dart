/// API 配置
class ApiConfig {
  // 通义千问 LLM API
  static const String llmBaseUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  static const String llmApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';
  static const String llmModel = 'qwen-flash';

  // GLM-Image 图像生成 API (智谱 AI)
  static const String imageBaseUrl = 'https://open.bigmodel.cn/api/paas/v4';
  static const String imageApiKey = '7f19e322592746f4967003fdde505901.LYWsCBh699azgL8J';
  static const String imageModel = 'glm-image';
}
