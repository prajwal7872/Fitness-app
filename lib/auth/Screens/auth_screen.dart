import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginpage/auth/bloc/auth_bloc.dart';
import 'package:loginpage/auth/bloc/auth_event.dart';
import 'package:loginpage/auth/bloc/auth_state.dart';
import 'package:loginpage/auth/widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    FocusScope.of(context).unfocus();

    final authBloc = context.read<AuthBloc>();
    final currentState = authBloc.state;
    if (currentState is AuthInitial && currentState.isLogin) {
      authBloc.add(AuthLoginEvent(_enteredEmail, _enteredPassword));
    } else {
      authBloc.add(AuthSignupEvent(_enteredEmail, _enteredPassword));
    }
  }

  void _toggleAuthMode() {
    context.read<AuthBloc>().add(AuthToggleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FirebaseAuth.instance),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 180,
                  child: Image.asset('assets/images/chat.png'),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLogin = state is AuthInitial && state.isLogin;
                    final isLoading = state is AuthLoading;

                    return AuthCard(
                      formKey: _form,
                      isLoading: isLoading,
                      isLogin: isLogin,
                      onSavedEmail: (value) {
                        _enteredEmail = value!;
                      },
                      onSavedPassword: (value) {
                        _enteredPassword = value!;
                      },
                      onSubmit: _submit,
                      onToggleAuthMode: _toggleAuthMode,
                    );
                  },
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is AuthEmailVerificationSent) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Verification email sent. Please verify your email and log in.',
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
