import 'package:app_news02/view/news_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Geral', 'icon': Icons.public, 'category': 'general'},
      {'name': 'Negócios', 'icon': Icons.business, 'category': 'business'},
      {'name': 'Tecnologia', 'icon': Icons.computer, 'category': 'technology'},
      {'name': 'Esportes', 'icon': Icons.sports_soccer, 'category': 'sports'},
      {
        'name': 'Entretenimento',
        'icon': Icons.movie,
        'category': 'entertainment',
      },
      {'name': 'Saúde', 'icon': Icons.health_and_safety, 'category': 'health'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'News App',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsListPage(
                      category: cat['category'] as String,
                      categoryName: cat['name'] as String,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    SizedBox(height: 10),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
