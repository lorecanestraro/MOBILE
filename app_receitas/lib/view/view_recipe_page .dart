// view/view_recipe_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../database/model/recipe_model.dart';

class ViewRecipePage extends StatelessWidget {
  final Recipe recipe;
  const ViewRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(recipe.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagem centralizada
            Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: recipe.img != null && recipe.img!.isNotEmpty
                        ? FileImage(File(recipe.img!))
                        : AssetImage("assets/imgs/recipe_default.png")
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Nome
            Text(
              recipe.name,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: 20),

            // Informações em cards
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.category,
                    label: "Tipo",
                    value: recipe.type,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _infoCard(
                    icon: Icons.signal_cellular_alt,
                    label: "Dificuldade",
                    value: recipe.difficulty,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.timer,
                    label: "Tempo",
                    value: "${recipe.prepTime} min",
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _infoCard(
                    icon: Icons.restaurant,
                    label: "Porções",
                    value: "${recipe.servings}",
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Ingredientes
            _sectionTitle(Icons.list_alt, "Ingredientes"),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                recipe.ingredients,
                style: TextStyle(fontSize: 16.0, height: 1.5),
              ),
            ),
            SizedBox(height: 25),

            // Modo de Preparo
            _sectionTitle(Icons.menu_book, "Modo de Preparo"),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                recipe.instructions,
                style: TextStyle(fontSize: 16.0, height: 1.5),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange[800], size: 28),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
      ],
    );
  }
}
