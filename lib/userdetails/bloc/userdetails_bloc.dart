import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loginpage/userdetails/bloc/userdetails_event.dart';
import 'package:loginpage/userdetails/bloc/userdetails_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _name = '';
  String _contactNumber = '';
  String _dateOfBirth = '';

  UserDetailsBloc() : super(const UserDetailsState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<ContactNumberChanged>(_onContactNumberChanged);
    on<DateOfBirthChanged>(_onDateOfBirthChanged);
    on<SubmitForm>(_onSubmitForm);
  }

  void _onEmailChanged(EmailChanged event, Emitter<UserDetailsState> emit) {
    _email = event.email;
    final isValid =
        _email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_email);
    emit(state.copyWith(
        emailError: isValid ? '' : 'Please enter a valid email address'));
  }

  void _onPasswordChanged(
      PasswordChanged event, Emitter<UserDetailsState> emit) {
    _password = event.password;
    emit(state.copyWith(
      passwordError: _password.isNotEmpty ? '' : 'Please enter a password',
      confirmPasswordError:
          _password == _confirmPassword ? '' : "Passwords don't match",
    ));
  }

  void _onConfirmPasswordChanged(
      ConfirmPasswordChanged event, Emitter<UserDetailsState> emit) {
    _confirmPassword = event.confirmPassword;
    emit(state.copyWith(
      confirmPasswordError:
          _password == _confirmPassword ? '' : "Passwords don't match",
    ));
  }

  void _onNameChanged(NameChanged event, Emitter<UserDetailsState> emit) {
    _name = event.name;
    emit(state.copyWith(
        nameError:
            _name.length >= 3 ? '' : 'Name must be at least 3 characters'));
  }

  void _onContactNumberChanged(
      ContactNumberChanged event, Emitter<UserDetailsState> emit) {
    _contactNumber = event.contactNumber;
    emit(state.copyWith(
        contactError:
            _contactNumber.isNotEmpty ? '' : 'Please enter a contact number'));
  }

  void _onDateOfBirthChanged(
      DateOfBirthChanged event, Emitter<UserDetailsState> emit) {
    _dateOfBirth = event.dateOfBirth;
    emit(state.copyWith(
        dateError:
            _dateOfBirth.isNotEmpty ? '' : 'Please select your date of birth'));
  }

  void _onSubmitForm(SubmitForm event, Emitter<UserDetailsState> emit) {
    _onEmailChanged(EmailChanged(_email), emit);
    _onPasswordChanged(PasswordChanged(_password), emit);
    _onConfirmPasswordChanged(ConfirmPasswordChanged(_confirmPassword), emit);
    _onNameChanged(NameChanged(_name), emit);
    _onContactNumberChanged(ContactNumberChanged(_contactNumber, ""), emit);
    _onDateOfBirthChanged(DateOfBirthChanged(_dateOfBirth), emit);

    if (state.emailError.isEmpty &&
        state.passwordError.isEmpty &&
        state.confirmPasswordError.isEmpty &&
        state.nameError.isEmpty &&
        state.contactError.isEmpty &&
        state.dateError.isEmpty) {
      emit(state.copyWith(
        isFormValid: true,
        email: _email,
        password: _password,
        name: _name,
        contactNumber: _contactNumber,
        dateOfBirth: _dateOfBirth,
      ));
    } else {
      emit(state.copyWith(isFormValid: false));
    }
  }
}
