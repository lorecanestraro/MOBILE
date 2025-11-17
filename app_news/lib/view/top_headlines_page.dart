import 'package:flutter/material.dart';
import '../service/news_api_service.dart';
import '../service/constants.dart';
import 'article_card.dart';

class TopHeadlinesPage extends StatefulWidget {
  const TopHeadlinesPage({Key? key}) : super(key: key);

  @override
  State<TopHeadlinesPage> createState() => _TopHeadlinesPageState();
}

class _TopHeadlinesPageState extends State<TopHeadlinesPage> {
  String _selectedCountry = 'us';
  String? _selectedCategory;
  List<dynamic> _articles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHeadlines();
  }

  Future<void> _loadHeadlines() async {
    setState(() => _isLoading = true);

    try {
      final data = await NewsApiService.getTopHeadlines(
        country: _selectedCountry,
        category: _selectedCategory,
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
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '🔥 Top Headlines',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AppConstants.countries.map((country) {
                      return ChoiceChip(
                        label: Text(country.toUpperCase()),
                        selected: _selectedCountry == country,
                        onSelected: (selected) {
                          setState(() => _selectedCountry = country);
                          _loadHeadlines();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = null);
                          _loadHeadlines();
                        },
                      ),
                      ...AppConstants.categories.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                            _loadHeadlines();
                          },
                        );
                      }),
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
