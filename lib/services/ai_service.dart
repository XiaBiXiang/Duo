import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/app_constants.dart';

/// Service for calling Google Gemini Vision API.
/// Takes a local image and returns a list of suggested tasks.
class AIService {
  static final _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: AppConstants.geminiApiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );

  /// Analyze an image and extract actionable bucket-list items.
  ///
  /// Returns a list of maps with 'title', 'description', and 'category' fields.
  static Future<List<Map<String, String>>> analyzeImage(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();

    final prompt = TextPart(
      '你是一个恋爱清单分析助手。分析这张图片，提取其中所有可以执行的待办事项、'
      '情侣清单活动或任务。'
      '这些图片通常来自小红书等平台，包含"恋爱必做100件事"之类的清单截图。'
      '\n\n'
      '请返回一个 JSON 数组，每个对象包含以下字段：\n'
      '- "title" (string, 必填): 任务名称，简洁明了\n'
      '- "description" (string, 可选): 任务的简短描述或备注\n'
      '- "category" (string, 必填): 任务类别，从以下选项中选择：'
      '"日常", "旅行", "美食", "冒险", "浪漫", "创意", "运动", "学习", "其他"\n\n'
      '只返回有效的 JSON 数组，不要包含任何其他文字或 markdown 标记。\n'
      '示例：\n'
      '[{"title":"一起看日出","description":"找一个风景好的高处","category":"浪漫"}]',
    );

    final content = [
      Content.multi([
        DataPart('image/jpeg', imageBytes),
        prompt,
      ]),
    ];

    final response = await _model.generateContent(content);
    final text = response.text ?? '[]';

    return _parseTaskList(text);
  }

  static List<Map<String, String>> _parseTaskList(String text) {
    var cleaned = text.trim();
    // Strip markdown code fences if present
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(cleaned.indexOf('\n') + 1);
      cleaned = cleaned.substring(0, cleaned.lastIndexOf('```'));
    }

    try {
      final List<dynamic> parsed = jsonDecode(cleaned);
      return parsed
          .map((item) => {
                'title': (item['title'] as String?) ?? '',
                'description': (item['description'] as String?) ?? '',
                'category': (item['category'] as String?) ?? '其他',
              })
          .where((item) => item['title']!.isNotEmpty)
          .toList()
          .cast<Map<String, String>>();
    } catch (e) {
      // If JSON parsing fails, return empty list
      return [];
    }
  }
}
