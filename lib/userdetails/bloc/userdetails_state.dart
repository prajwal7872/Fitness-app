import 'package:equatable/equatable.dart';

class UserDetailsState extends Equatable {
  final String email;
  final String password;
  final String name;
  final String contactNumber;
  final String dateOfBirth;
  final String emailError;
  final String passwordError;
  final String confirmPasswordError;
  final String nameError;
  final String contactError;
  final String dateError;
  final bool isFormValid;

  const UserDetailsState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.contactNumber = '',
    this.dateOfBirth = '',
    this.emailError = '',
    this.passwordError = '',
    this.confirmPasswordError = '',
    this.nameError = '',
    this.contactError = '',
    this.dateError = '',
    this.isFormValid = false,
  });

  UserDetailsState copyWith({
    String? email,
    String? password,
    String? name,
    String? contactNumber,
    String? dateOfBirth,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? nameError,
    String? contactError,
    String? dateError,
    bool? isFormValid,
  }) {
    return UserDetailsState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      nameError: nameError ?? this.nameError,
      contactError: contactError ?? this.contactError,
      dateError: dateError ?? this.dateError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        email,
        name,
        contactNumber,
        dateOfBirth,
        emailError,
        passwordError,
        confirmPasswordError,
        nameError,
        contactError,
        dateError,
        isFormValid,
      ];
}
