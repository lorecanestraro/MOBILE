// view/home_page.dart

import 'dart:io';
import 'package:app_receitas/view/view_recipe_page%20.dart';
import 'package:flutter/material.dart';
import '../database/helper/recipe_helper.dart';
import '../database/model/recipe_model.dart';
import 'recipe_page.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RecipeHelper helper = RecipeHelper();
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    helper.getAllRecipes().then((list) {
      setState(() {
        recipes = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Livro de Receitas"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderAZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderZA,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRecipePage();
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return _recipeCard(context, index);
        },
      ),
    );
  }

  Widget _recipeCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        recipes[index].img != null &&
                            recipes[index].img!.isNotEmpty
                        ? FileImage(File(recipes[index].img!))
                        : AssetImage("assets/imgs/recipe_default.png")
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        recipes[index].name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.category, size: 16, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            recipes[index].type,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.signal_cellular_alt,
                            size: 16,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            recipes[index].difficulty,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "${recipes[index].prepTime} min",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.restaurant, size: 16, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            "${recipes[index].servings} porções",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Indicador visual do modal
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),

              // Botão Visualizar
              ListTile(
                leading: Icon(Icons.visibility, color: Colors.green, size: 28),
                title: Text(
                  "Visualizar",
                  style: TextStyle(color: Colors.green, fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showViewRecipePage(recipe: recipes[index]);
                },
              ),

              Divider(),

              // Botão Editar
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue, size: 28),
                title: Text(
                  "Editar",
                  style: TextStyle(color: Colors.blue, fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showRecipePage(recipe: recipes[index]);
                },
              ),

              Divider(),

              // Botão Excluir
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red, size: 28),
                title: Text(
                  "Excluir",
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar Exclusão"),
          content: Text(
            "Deseja realmente excluir a receita \"${recipes[index].name}\"?",
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Excluir", style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (recipes[index].id != null) {
                  helper.deleteRecipe(recipes[index].id!);
                  setState(() {
                    recipes.removeAt(index);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Receita excluída com sucesso!")),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro: ID da receita não encontrado."),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showViewRecipePage({required Recipe recipe}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewRecipePage(recipe: recipe)),
    );
  }

  void _showRecipePage({Recipe? recipe}) async {
    final updatedRecipe = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
    );

    if (updatedRecipe != null) {
      _loadRecipes();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        recipes.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        recipes.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
