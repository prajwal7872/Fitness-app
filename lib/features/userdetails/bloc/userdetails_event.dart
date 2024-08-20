import 'package:equatable/equatable.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends UserDetailsEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends UserDetailsEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends UserDetailsEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class NameChanged extends UserDetailsEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class ContactNumberChanged extends UserDetailsEvent {
  final String contactNumber;
  final String countryCode;

  const ContactNumberChanged(this.contactNumber, this.countryCode);

  @override
  List<Object?> get props => [contactNumber, countryCode];
}

class DateOfBirthChanged extends UserDetailsEvent {
  final String dateOfBirth;

  const DateOfBirthChanged(this.dateOfBirth);

  @override
  List<Object?> get props => [dateOfBirth];
}

class SubmitForm extends UserDetailsEvent {}
