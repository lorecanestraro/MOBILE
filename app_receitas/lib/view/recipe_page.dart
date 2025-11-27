import 'dart:io';
import 'package:flutter/material.dart';
import '../database/helper/recipe_helper.dart';
import '../database/model/recipe_model.dart';
import 'package:image_picker/image_picker.dart';

class RecipePage extends StatefulWidget {
  final Recipe? recipe;
  const RecipePage({Key? key, this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Recipe? _editRecipe;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  final RecipeHelper _helper = RecipeHelper();
  final ImagePicker _picker = ImagePicker();

  // Opções selecionáveis
  final List<String> _types = [
    'Doce',
    'Salgado',
    'Bebida',
    'Vegano',
    'Fitness',
  ];
  final List<String> _difficulties = ['Fácil', 'Média', 'Difícil'];

  String? _selectedType;
  String? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    if (widget.recipe == null) {
      _editRecipe = Recipe(
        name: "",
        type: _types[0],
        difficulty: _difficulties[0],
        prepTime: 0,
        servings: 1,
        ingredients: "",
        instructions: "",
        img: null,
      );
      _selectedType = _types[0];
      _selectedDifficulty = _difficulties[0];
    } else {
      _editRecipe = widget.recipe;
      _nameController.text = _editRecipe?.name ?? '';
      _prepTimeController.text = _editRecipe?.prepTime.toString() ?? '0';
      _servingsController.text = _editRecipe?.servings.toString() ?? '1';
      _ingredientsController.text = _editRecipe?.ingredients ?? '';
      _instructionsController.text = _editRecipe?.instructions ?? '';
      _selectedType = _editRecipe?.type;
      _selectedDifficulty = _editRecipe?.difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(_editRecipe?.name ?? "Nova Receita"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveRecipe();
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectImage(),
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image:
                          _editRecipe?.img != null &&
                              _editRecipe!.img!.isNotEmpty
                          ? FileImage(File(_editRecipe!.img!))
                          : AssetImage("assets/imgs/recipe_default.png")
                                as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _editRecipe?.img == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nome da Receita *",
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editRecipe?.name = text;
                  });
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: "Tipo *",
                  border: OutlineInputBorder(),
                ),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _userEdited = true;
                    setState(() {
                      _selectedType = newValue;
                      _editRecipe?.type = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: "Dificuldade *",
                  border: OutlineInputBorder(),
                ),
                items: _difficulties.map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _userEdited = true;
                    setState(() {
                      _selectedDifficulty = newValue;
                      _editRecipe?.difficulty = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _prepTimeController,
                      decoration: InputDecoration(
                        labelText: "Tempo (min) *",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _editRecipe?.prepTime = int.tryParse(text) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _servingsController,
                      decoration: InputDecoration(
                        labelText: "Porções *",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _editRecipe?.servings = int.tryParse(text) ?? 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: "Ingredientes *",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editRecipe?.ingredients = text;
                  });
                },
              ),
              SizedBox(height: 15),
              TextField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: "Modo de Preparo *",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editRecipe?.instructions = text;
                  });
                },
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editRecipe?.img = image.path;
        _userEdited = true;
      });
    }
  }

  void _saveRecipe() async {
    if (_editRecipe?.name != null && _editRecipe!.name.isNotEmpty) {
      if (_editRecipe?.id != null) {
        await _helper.updateRecipe(_editRecipe!);
      } else {
        await _helper.saveRecipe(_editRecipe!);
      }
      Navigator.pop(context, _editRecipe);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nome é obrigatório!")));
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair, as alterações serão perdidas."),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
