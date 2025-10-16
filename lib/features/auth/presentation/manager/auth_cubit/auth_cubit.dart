import 'package:bloc/bloc.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthInitial());
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(email: email);
      emit(AuthPasswordReset());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle(context) async {
    emit(AuthLoading(isGoogleLogin: true));
    try {
      final user = await _authRepository.signInWithGoogle(context);
      if (user == null) {
        emit(AuthError("Google Sign-In cancelled by user"));
        return;
      }
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
