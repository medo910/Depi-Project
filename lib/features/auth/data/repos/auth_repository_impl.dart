import 'package:depi_app/core/utils/auth_service.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _authService.signUp(email, password, fullName);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _authService.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _authService.resetPassword(email);
  }

  @override
  Future<User?> signInWithGoogle(context) async {
    return await _authService.signInWithGoogle(context);
  }

  // @override
  Stream<bool> get authStateChanges =>
      _authService.currentUser != null
          ? Stream.value(true)
          : Stream.value(false);
}
