import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/model/recipe_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _getUserRecipesCollection() {
    String userId = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(userId).collection('recipes');
  }

  Future<void> createRecipe(Recipe recipe) async {
    try {
      Map<String, dynamic> recipeData = recipe.toMap();
      recipeData.remove('id'); // Remove o ID local
      recipeData['timestamp'] = FieldValue.serverTimestamp();

      await _getUserRecipesCollection().add(recipeData);
    } catch (e) {
      throw Exception('Erro ao criar receita: $e');
    }
  }

  Stream<List<Recipe>> getRecipes() {
    return _getUserRecipesCollection()
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Recipe.fromFirestore(data);
          }).toList();
        });
  }

  Future<void> updateRecipe(String docId, Recipe recipe) async {
    try {
      Map<String, dynamic> recipeData = recipe.toMap();
      recipeData.remove('id');
      recipeData['timestamp'] = FieldValue.serverTimestamp();

      await _getUserRecipesCollection().doc(docId).update(recipeData);
    } catch (e) {
      throw Exception('Erro ao atualizar receita: $e');
    }
  }

  Future<void> deleteRecipe(String docId) async {
    try {
      await _getUserRecipesCollection().doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar receita: $e');
    }
  }

  Future<Recipe?> getRecipeById(String docId) async {
    try {
      DocumentSnapshot doc = await _getUserRecipesCollection().doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Recipe.fromFirestore(data);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar receita: $e');
    }
  }
}
