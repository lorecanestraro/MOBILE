import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/recipe_model.dart';

class RecipeHelper {
  static final RecipeHelper _instance = RecipeHelper.internal();
  factory RecipeHelper() => _instance;
  RecipeHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "recipesDB.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute(
          "CREATE TABLE $recipeTable("
          "$idColumn INTEGER PRIMARY KEY, "
          "$nameColumn TEXT, "
          "$typeColumn TEXT, "
          "$difficultyColumn TEXT, "
          "$prepTimeColumn INTEGER, "
          "$servingsColumn INTEGER, "
          "$ingredientsColumn TEXT, "
          "$instructionsColumn TEXT, "
          "$imgColumn TEXT)",
        );
      },
    );
  }

  Future<Recipe> saveRecipe(Recipe recipe) async {
    Database dbRecipe = await db;
    recipe.id = await dbRecipe.insert(recipeTable, recipe.toMap());
    return recipe;
  }

  Future<Recipe?> getRecipe(int id) async {
    Database dbRecipe = await db;
    List<Map<String, dynamic>> maps = await dbRecipe.query(
      recipeTable,
      columns: [
        idColumn,
        nameColumn,
        typeColumn,
        difficultyColumn,
        prepTimeColumn,
        servingsColumn,
        ingredientsColumn,
        instructionsColumn,
        imgColumn,
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    Database dbRecipe = await db;
    List<Map<String, dynamic>> listMap = await dbRecipe.query(recipeTable);
    List<Recipe> listRecipe = [];

    for (Map<String, dynamic> m in listMap) {
      listRecipe.add(Recipe.fromMap(m));
    }
    return listRecipe;
  }

  Future<int> deleteRecipe(int id) async {
    Database dbRecipe = await db;
    return await dbRecipe.delete(
      recipeTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Database dbRecipe = await db;
    return await dbRecipe.update(
      recipeTable,
      recipe.toMap(),
      where: "$idColumn = ?",
      whereArgs: [recipe.id],
    );
  }
}
