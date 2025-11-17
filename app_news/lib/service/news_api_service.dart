import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class NewsApiService {
  // Previne instanciação
  NewsApiService._();

  // Top Headlines Endpoint
  static Future<Map<String, dynamic>> getTopHeadlines({
    String? country,
    String? category,
    String? q,
  }) async {
    final params = {
      'apiKey': AppConstants.apiKey,
      if (country != null) 'country': country,
      if (category != null) 'category': category,
      if (q != null) 'q': q,
    };

    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.topHeadlinesEndpoint}',
    ).replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching headlines: $e');
    }
  }

  // Everything Endpoint
  static Future<Map<String, dynamic>> getEverything({
    String? q,
    String? sources,
    String? sortBy,
  }) async {
    final params = {
      'apiKey': AppConstants.apiKey,
      if (q != null) 'q': q,
      if (sources != null) 'sources': sources,
      if (sortBy != null) 'sortBy': sortBy,
    };

    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.everythingEndpoint}',
    ).replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

  // Sources Endpoint
  static Future<Map<String, dynamic>> getSources({
    String? category,
    String? language,
    String? country,
  }) async {
    final params = {
      'apiKey': AppConstants.apiKey,
      if (category != null) 'category': category,
      if (language != null) 'language': language,
      if (country != null) 'country': country,
    };

    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.sourcesEndpoint}',
    ).replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load sources: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sources: $e');
    }
  }
}
