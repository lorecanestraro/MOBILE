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

  String? id;
  String name;
  String type;
  String difficulty;
  int prepTime;
  int servings;
  String ingredients;
  String instructions;
  String? img;

  Recipe.fromFirestore(Map<String, dynamic> data)
    : id = data['id'],
      name = data['name'] ?? '',
      type = data['type'] ?? '',
      difficulty = data['difficulty'] ?? '',
      prepTime = data['prepTime'] ?? 0,
      servings = data['servings'] ?? 0,
      ingredients = data['ingredients'] ?? '',
      instructions = data['instructions'] ?? '',
      img = data['img'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'difficulty': difficulty,
      'prepTime': prepTime,
      'servings': servings,
      'ingredients': ingredients,
      'instructions': instructions,
      'img': img,
    };
  }

  @override
  String toString() {
    return "Recipe(id: $id, name: $name, type: $type, difficulty: $difficulty, prepTime: $prepTime min, servings: $servings, img: $img)";
  }
}
