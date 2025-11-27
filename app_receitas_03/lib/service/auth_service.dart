import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': 'Erro desconhecido. Tente novamente.'};
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (password != confirmPassword) {
        return {'success': false, 'error': 'As senhas não conferem!'};
      }

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': 'Erro desconhecido. Tente novamente.'};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Email ou senha incorretos!';
      case 'user-not-found':
        return 'Usuário não encontrado!';
      case 'wrong-password':
        return 'Senha incorreta!';
      case 'email-already-in-use':
        return 'Este email já está cadastrado!';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres!';
      case 'invalid-email':
        return 'Email inválido!';
      case 'user-disabled':
        return 'Este usuário foi desabilitado!';
      default:
        return 'Erro ao processar. Tente novamente!';
    }
  }
}
