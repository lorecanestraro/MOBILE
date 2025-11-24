// database/model/recipe_model.dart

String idColumn = "idColumn";
String nameColumn = "nameColumn";
String typeColumn = "typeColumn";
String difficultyColumn = "difficultyColumn";
String prepTimeColumn = "prepTimeColumn";
String servingsColumn = "servingsColumn";
String ingredientsColumn = "ingredientsColumn";
String instructionsColumn = "instructionsColumn";
String imgColumn = "imgColumn";
String recipeTable = "recipeTable";

class Recipe {
  Recipe({
    this.id,
    required this.name,
    required this.type,
    required this.difficulty,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.img,
  });

  int? id;
  String name;
  String type; // Selecionável: Doce, Salgado, Bebida, Vegano, Fitness
  String difficulty; // Selecionável: Fácil, Média, Difícil
  int prepTime; // Tempo em minutos
  int servings; // Número de porções
  String ingredients; // Texto grande
  String instructions; // Texto grande (modo de preparo)
  String? img;

  Recipe.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      name = map[nameColumn],
      type = map[typeColumn],
      difficulty = map[difficultyColumn],
      prepTime = map[prepTimeColumn],
      servings = map[servingsColumn],
      ingredients = map[ingredientsColumn],
      instructions = map[instructionsColumn],
      img = map[imgColumn];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      typeColumn: type,
      difficultyColumn: difficulty,
      prepTimeColumn: prepTime,
      servingsColumn: servings,
      ingredientsColumn: ingredients,
      instructionsColumn: instructions,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Recipe(id: $id, name: $name, type: $type, difficulty: $difficulty, prepTime: $prepTime min, servings: $servings, img: $img)";
  }
}
