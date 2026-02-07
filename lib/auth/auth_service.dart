import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<String?> signUp(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    return res.user?.id;
  }

  Future<String?> signIn(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print("Response: $res");

    return res.user?.id;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
