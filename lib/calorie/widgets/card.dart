import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final bool isLogin;
  final Function(String?) onSavedEmail;
  final Function(String?) onSavedPassword;
  final VoidCallback onSubmit;
  final VoidCallback onToggleAuthMode;

  const AuthCard({
    required this.formKey,
    required this.isLoading,
    required this.isLogin,
    required this.onSavedEmail,
    required this.onSavedPassword,
    required this.onSubmit,
    required this.onToggleAuthMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }

                    return null;
                  },
                  onSaved: onSavedEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: onSavedPassword,
                ),
                const SizedBox(height: 12),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Text(isLogin ? 'Login' : 'Signup'),
                  ),
                if (!isLoading)
                  TextButton(
                    onPressed: onToggleAuthMode,
                    child: Text(isLogin
                        ? 'Create an account'
                        : 'I already have an account'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
