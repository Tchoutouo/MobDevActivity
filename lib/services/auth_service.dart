class AuthService {
  // Pour les tests de connexion, je vais utiliser des identifiants codés en dur.
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return username == 'demo' && password == 'demo123';
  }
}
