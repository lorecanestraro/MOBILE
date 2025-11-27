import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/model/recipe_model.dart';
import '../service/firestore_service.dart';

class RecipePage extends StatefulWidget {
  final Recipe? recipe;
  const RecipePage({Key? key, this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final FirestoreService _firestoreService = FirestoreService();
  Recipe? _editRecipe;
  bool _userEdited = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

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

      _nameController.text = _editRecipe?.name ?? "";
      _prepTimeController.text = _editRecipe?.prepTime.toString() ?? "0";
      _servingsController.text = _editRecipe?.servings.toString() ?? "1";
      _ingredientsController.text = _editRecipe?.ingredients ?? "";
      _instructionsController.text = _editRecipe?.instructions ?? "";

      _selectedType = _editRecipe?.type;
      _selectedDifficulty = _editRecipe?.difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            _editRecipe?.name.isEmpty ?? true
                ? "Nova Receita"
                : _editRecipe!.name,
          ),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _isLoading ? null : _saveRecipe,
          backgroundColor: _isLoading ? Colors.grey : Colors.orange,
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Icon(Icons.save),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildTextFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    ImageProvider imageProvider;

    if (_editRecipe?.img == null || _editRecipe!.img!.isEmpty) {
      imageProvider = const AssetImage("assets/imgs/recipe_default.png");
    } else if (_editRecipe!.img!.startsWith("http")) {
      imageProvider = NetworkImage(_editRecipe!.img!);
    } else {
      imageProvider = FileImage(File(_editRecipe!.img!));
    }

    return GestureDetector(
      onTap: _selectImage,
      child: CircleAvatar(
        radius: 70,
        backgroundImage: imageProvider,
        child: (_editRecipe?.img == null)
            ? Icon(Icons.camera_alt, size: 40, color: Colors.black54)
            : null,
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Nome da Receita *",
            border: OutlineInputBorder(),
          ),
          onChanged: (text) {
            _userEdited = true;
            _editRecipe?.name = text;
          },
        ),
        const SizedBox(height: 15),

        DropdownButtonFormField<String>(
          initialValue: _selectedType,
          decoration: const InputDecoration(
            labelText: "Tipo *",
            border: OutlineInputBorder(),
          ),
          items: _types
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _userEdited = true;
              _selectedType = value;
              _editRecipe?.type = value;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 15),

        DropdownButtonFormField<String>(
          initialValue: _selectedDifficulty,
          decoration: const InputDecoration(
            labelText: "Dificuldade *",
            border: OutlineInputBorder(),
          ),
          items: _difficulties
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _userEdited = true;
              _selectedDifficulty = value;
              _editRecipe?.difficulty = value;
              setState(() {});
            }
          },
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _prepTimeController,
                decoration: const InputDecoration(
                  labelText: "Tempo (min) *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  _userEdited = true;
                  _editRecipe?.prepTime = int.tryParse(text) ?? 0;
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _servingsController,
                decoration: const InputDecoration(
                  labelText: "Porções *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  _userEdited = true;
                  _editRecipe?.servings = int.tryParse(text) ?? 1;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        TextField(
          controller: _ingredientsController,
          maxLines: 6,
          decoration: const InputDecoration(
            labelText: "Ingredientes *",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onChanged: (text) {
            _userEdited = true;
            _editRecipe?.ingredients = text;
          },
        ),

        const SizedBox(height: 15),

        TextField(
          controller: _instructionsController,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: "Modo de Preparo *",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onChanged: (text) {
            _userEdited = true;
            _editRecipe?.instructions = text;
          },
        ),
        SizedBox(height: 80),
      ],
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

  Future<void> _saveRecipe() async {
    if (_editRecipe!.name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nome é obrigatório!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_editRecipe!.id != null) {
        await _firestoreService.updateRecipe(_editRecipe!.id!, _editRecipe!);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Receita atualizada!")));
      } else {
        await _firestoreService.createRecipe(_editRecipe!);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Receita criada!")));
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _requestPop() async {
    if (!_userEdited) return true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Descartar alterações?"),
        content: const Text("Se sair, as alterações serão perdidas."),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Sim"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    return false;
  }
}
