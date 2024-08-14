import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/sign_up/screens/my_home_page.dart';
import 'package:loginpage/userdetails/bloc/userdetails_bloc.dart';
import 'package:loginpage/userdetails/bloc/userdetails_event.dart';
import 'package:loginpage/userdetails/bloc/userdetails_state.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({super.key});

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: UserInputForm(
          navigatorKey: navigatorKey,
        ),
        backgroundColor: Colors.teal.shade50,
      ),
    );
  }
}

class UserInputForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey;

  UserInputForm({super.key, required this.navigatorKey});

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final sixYearsAgo = DateTime(now.year - 6, now.month, now.day);
    final fiftyYearsAgo = DateTime(now.year - 50, now.month, now.day);
    final fiveYearsBefore = DateTime(now.year - 5, now.month, now.day);

    DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: sixYearsAgo,
      firstDate: fiftyYearsAgo,
      lastDate: fiveYearsBefore,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
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
      navigatorKey.currentContext!
          .read<UserDetailsBloc>()
          .add(DateOfBirthChanged(_dateController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDetailsBloc, UserDetailsState>(
      listener: (context, state) {
        if (state.isFormValid) {
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
                builder: (context) => MyHomePage(
                      userDetails: userDetails,
                    )),
          );
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
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                    IntlPhoneField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact No',
                        errorText: state.contactError.isEmpty
                            ? null
                            : state.contactError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      initialCountryCode: 'NP',
                      onChanged: (phone) {
                        context.read<UserDetailsBloc>().add(
                            ContactNumberChanged(
                                phone.number, phone.countryCode));
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        errorText:
                            state.dateError.isEmpty ? null : state.dateError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
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
                        'Submit',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
        errorText: errorText?.isEmpty ?? true ? null : errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
