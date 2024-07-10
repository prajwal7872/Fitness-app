import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthSignupEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignupEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthToggleEvent extends AuthEvent {}
