import 'package:flutter/material.dart';
import '../service/news_api_service.dart';
import 'article_card.dart';

class EverythingPage extends StatefulWidget {
  const EverythingPage({Key? key}) : super(key: key);

  @override
  State<EverythingPage> createState() => _EverythingPageState();
}

class _EverythingPageState extends State<EverythingPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _articles = [];
  bool _isLoading = false;
  String _sortBy = 'publishedAt';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchArticles() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final data = await NewsApiService.getEverything(
        q: _searchController.text,
        sortBy: _sortBy,
      );
      setState(() => _articles = data['articles'] ?? []);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '🔍 Explore Everything',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _searchArticles,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E2E),
                    ),
                    onSubmitted: (_) => _searchArticles(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Sort by: '),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _sortBy,
                        items: const [
                          DropdownMenuItem(
                            value: 'publishedAt',
                            child: Text('Latest'),
                          ),
                          DropdownMenuItem(
                            value: 'relevancy',
                            child: Text('Relevancy'),
                          ),
                          DropdownMenuItem(
                            value: 'popularity',
                            child: Text('Popularity'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _sortBy = value!);
                          if (_articles.isNotEmpty) _searchArticles();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_articles.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Search for news articles',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ArticleCard(article: _articles[index]),
                childCount: _articles.length,
              ),
            ),
        ],
      ),
    );
  }
}
