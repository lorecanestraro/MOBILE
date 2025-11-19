import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NewsService {
  final String _apiKey = "c2b66b94a02843ac9d6d7025382614a2";
  final String _baseUrl = "https://newsapi.org/v2";

  Future<Map<String, dynamic>> _getRequest(String url) async {
    try {
      final uri = Uri.parse(url);

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Erro: código ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Sem conexão com a internet.");
    } on TimeoutException {
      throw Exception("A requisição demorou muito. Tente novamente.");
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<Map<String, dynamic>> getNewsByCategory(String category) async {
    final url =
        "$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey";

    return await _getRequest(url);
  }

  Future<Map<String, dynamic>> searchNews(String query) async {
    if (query.isEmpty) {
      return getNewsByCategory("general");
    }

    final url =
        "$_baseUrl/everything?q=$query&language=pt&sortBy=publishedAt&apiKey=$_apiKey";

    return await _getRequest(url);
  }
}
