import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final Map _articleData;

  NewsDetailPage(this._articleData);

  Future<void> _abrirNoticia() async {
    final url = _articleData["url"];
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
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
        title: Text(
          'Detalhes da Notícia',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],

      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40), // margem geral inferior
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_articleData["urlToImage"] != null)
              Image.network(
                _articleData["urlToImage"],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250,
                  color: Colors.grey[800],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white38,
                    size: 80,
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _articleData["title"] ?? "Sem título",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.source, color: Colors.purpleAccent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        _articleData["source"]["name"] ?? "Fonte desconhecida",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  if (_articleData["author"] != null)
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Text(
                          _articleData["author"],
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),

                  SizedBox(height: 16),
                  Divider(color: Colors.white24),
                  SizedBox(height: 16),

                  Text(
                    _articleData["description"] ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    _articleData["content"] ?? "Conteúdo não disponível",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _abrirNoticia,
                      icon: Icon(Icons.open_in_new),
                      label: Text('Ler notícia completa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
