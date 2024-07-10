// BLoC
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/auth/bloc/auth_event.dart';
import 'package:loginpage/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc(this._firebaseAuth) : super(const AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthSignupEvent>(_onSignup);
    on<AuthToggleEvent>(_onToggle);
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredentials.user!.emailVerified) {
        emit(AuthAuthenticated());
      } else {
        emit(const AuthError('Please verify your email to log in.'));
      }
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Authentication failed.'));
    }
  }

  Future<void> _onSignup(AuthSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await userCredentials.user!.sendEmailVerification();
      emit(AuthEmailVerificationSent());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Authentication failed.'));
    }
  }

  void _onToggle(AuthToggleEvent event, Emitter<AuthState> emit) {
    if (state is AuthInitial) {
      final currentState = state as AuthInitial;
      emit(AuthInitial(isLogin: !currentState.isLogin));
    }
  }
}
