import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loginpage/features/Signup/presentation/pages/homepage.dart';
import 'package:loginpage/features/userdetails/bloc/userdetails_bloc.dart';
import 'package:loginpage/features/userdetails/bloc/userdetails_event.dart';
import 'package:loginpage/features/userdetails/bloc/userdetails_state.dart';

class UserInputPage extends StatelessWidget {
  const UserInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: UserInputForm(),
        backgroundColor: Colors.teal.shade50,
      ),
    );
  }
}

class UserInputForm extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  UserInputForm({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final sixYearsAgo = DateTime(now.year - 6, now.month, now.day);
    final fiftyYearsAgo = DateTime(now.year - 50, now.month, now.day);
    final fiveYearsBefore = DateTime(now.year - 5, now.month, now.day);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sixYearsAgo,
      firstDate: fiftyYearsAgo,
      lastDate: fiveYearsBefore,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(primary: Colors.teal),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dateController.text = picked.toString().split(" ")[0];
      // ignore: use_build_context_synchronously
      context
          .read<UserDetailsBloc>()
          .add(DateOfBirthChanged(_dateController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDetailsBloc, UserDetailsState>(
      listener: (context, state) {
        if (state.isFormValid) {
          _navigateToNextPage(context, state);
        }
      },
      child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildTextField(
                      context: context,
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      errorText: state.emailError,
                      onChanged: (value) => context
                          .read<UserDetailsBloc>()
                          .add(EmailChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      context: context,
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      errorText: state.passwordError,
                      onChanged: (value) => context
                          .read<UserDetailsBloc>()
                          .add(PasswordChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      context: context,
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      errorText: state.confirmPasswordError,
                      onChanged: (value) => context
                          .read<UserDetailsBloc>()
                          .add(ConfirmPasswordChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      context: context,
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      errorText: state.nameError,
                      onChanged: (value) => context
                          .read<UserDetailsBloc>()
                          .add(NameChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneField(context, state),
                    const SizedBox(height: 16),
                    _buildDateField(context, state),
                    const SizedBox(height: 32),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Sign Up',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.teal.shade700,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText?.isNotEmpty ?? false ? errorText : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  Widget _buildPhoneField(BuildContext context, UserDetailsState state) {
    return IntlPhoneField(
      controller: _contactController,
      decoration: InputDecoration(
        labelText: 'Contact No',
        errorText: state.contactError.isNotEmpty ? state.contactError : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
      initialCountryCode: 'NP',
      onChanged: (phone) {
        context
            .read<UserDetailsBloc>()
            .add(ContactNumberChanged(phone.number, phone.countryCode));
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildDateField(BuildContext context, UserDetailsState state) {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        errorText: state.dateError.isNotEmpty ? state.dateError : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<UserDetailsBloc>().add(SubmitForm());
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.teal,
      ),
      child: const Text(
        'Proceed',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context, UserDetailsState state) {
    Map<String, dynamic> userDetails = {
      "email": state.email,
      "password": state.password,
      "full_name": state.name,
      "contact_no": state.contactNumber,
      "date_of_birth": state.dateOfBirth,
      "questionnaire": []
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(userDetails: userDetails),
      ),
    );
  }
}
