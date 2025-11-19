import 'package:app_news02/service/news_service.dart';
import 'package:app_news02/view/news_details_page.dart';
import 'package:flutter/material.dart';

class NewsListPage extends StatefulWidget {
  final String category;
  final String categoryName;

  NewsListPage({required this.category, required this.categoryName});

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  String _search = "";
  List _articles = [];
  bool _isLoading = false;
  final NewsService newsService = NewsService();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result;

      if (_search.isEmpty) {
        result = await newsService.getNewsByCategory(widget.category);
      } else {
        result = await newsService.searchNews(_search);
      }

      setState(() {
        _articles = result["articles"] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar notícias')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.categoryName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquisar notícias",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              style: TextStyle(color: Colors.white, fontSize: 16),
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                });
                _loadNews();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  )
                : _articles.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma notícia encontrada',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return _buildNewsCard(article);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailPage(article)),
        );
      },
      child: Card(
        color: Colors.grey[850],
        margin: EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article["urlToImage"] != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article["urlToImage"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white38,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article["title"] ?? "Sem título",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    article["description"] ?? "",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.source, color: Colors.purpleAccent, size: 16),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          article["source"]["name"] ?? "Fonte desconhecida",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
