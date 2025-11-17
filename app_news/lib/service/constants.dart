class AppConstants {
  // Previne instanciação
  AppConstants._();

  // API Configuration
  static const String apiKey = 'c2b66b94a02843ac9d6d7025382614a2';
  static const String baseUrl = 'https://newsapi.org/v2';

  // Endpoints
  static const String topHeadlinesEndpoint = '/top-headlines';
  static const String everythingEndpoint = '/everything';
  static const String sourcesEndpoint = '/top-headlines/sources';

  // Request Configuration
  static const int requestTimeout = 30;
  static const int articlesPerPage = 20;

  // Countries
  static const List<String> countries = [
    'us',
    'br',
    'gb',
    'fr',
    'de',
    'it',
    'jp',
  ];

  // Categories
  static const List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Sort Options
  static const List<String> sortOptions = [
    'publishedAt',
    'relevancy',
    'popularity',
  ];
}
