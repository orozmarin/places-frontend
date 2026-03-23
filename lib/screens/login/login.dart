import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/widgets/date_input_with_date_picker.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
    required this.registerUser,
    required this.loginUser,
    required this.isLoading,
    required this.googleLogin,
    required this.appleLogin,
  }) : super(key: key);
  final Function(RegisterRequest registerRequest) registerUser;
  final Function(LoginRequest loginRequest) loginUser;
  final VoidCallback googleLogin;
  final VoidCallback appleLogin;
  final bool isLoading;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Sex _selectedSex = Sex.FEMALE;

  final DateTime _earliestDate = DateTime.now().subtract(const Duration(days: 36500));
  final DateTime? _latestDate = DateTime.now();
  DateTime? _dateOfBirth = DateTime.now().subtract(const Duration(days: 1));

  String? _errorMessage;

  bool _isRegistering = false;
  bool? _passwordVisible;
  bool? _confirmPasswordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Login oldWidget) {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.dispose();
  }

  void _toggleRegistering() {
    setState(() {
      _isRegistering = !_isRegistering;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo_16_9.png'),
                  if (_isRegistering) ...[
                    InputField(
                      controller: _firstNameController,
                      labelText: 'First Name',
                      onChanged: (String? value) {
                        _firstNameController.text = value ?? "";
                      },
                    ),
                    const VerticalSpacer(16),
                    InputField(
                      controller: _lastNameController,
                      labelText: 'Last Name',
                      onChanged: (String? value) {
                        _lastNameController.text = value ?? "";
                      },
                    ),
                    const VerticalSpacer(16),
                    InputField(
                      controller: _usernameController,
                      labelText: 'Username',
                      hintText: 'Letters, numbers, underscores only',
                      validatorFunction: usernameValidator,
                      onChanged: (String? value) {
                        _usernameController.text = value ?? "";
                      },
                    ),
                    const VerticalSpacer(16),
                  ],
                  InputField(
                    labelText: "Email",
                    hintText: "Enter your email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                          validatorFunction: emailValidator,
                          onChanged: (String? value) {
                            _emailController.text = value ?? "";
                          },
                  ),
                  const VerticalSpacer(16),
                  InputField(
                    labelText: "Password",
                    hintText: "Enter your password",
                    controller: _passwordController,
                          obscureText: (_passwordVisible ?? false) ? false : true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: _passwordVisible ?? false ? Colors.black : Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !(_passwordVisible ?? false);
                              });
                            },
                          ),
                          validatorFunction: passwordValidator,
                          onChanged: (String? value) {
                            _passwordController.text = value ?? "";
                          },
                        ),
                        VerticalSpacer(_isRegistering ? 16 : 24),
                  if (_isRegistering) ...[
                    InputField(
                      controller: _confirmPasswordController,
                            obscureText: (_confirmPasswordVisible ?? false) ? false : true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: _confirmPasswordVisible ?? false ? Colors.black : Colors.black.withOpacity(0.3),
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible = !(_confirmPasswordVisible ?? false);
                                });
                              },
                            ),
                            labelText: 'Confirm Password',
                            validatorFunction: (value) => confirmPasswordValidator(value, _passwordController.text),
                            onChanged: (String? value) {
                              _confirmPasswordController.text = value ?? "";
                            },
                          ),
                          const VerticalSpacer(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      DateInputWithDatePicker(
                        title: 'Select date',
                        maximumDate: _latestDate,
                        width: 150,
                        minimumDate: _earliestDate,
                        date: _dateOfBirth,
                        onDateChanged: (DateTime newDate) => _onDateChanged(newDate),
                        validatorFunction: (value) => null,
                      ),
                      const HorizontalSpacer(36),
                      DropdownButton<Sex>(
                        value: _selectedSex,
                        onChanged: (Sex? newValue) {
                          setState(() {
                            _selectedSex = newValue!;
                          });
                        },
                        items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                          return DropdownMenuItem<Sex>(
                            value: value,
                            child: Text(value
                                .toString()
                                .split('.')
                                .last),
                          );
                        }).toList(),
                      ),
                    ],),
                    const VerticalSpacer(16),
                  ],
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ButtonComponent.smallButton(
                    isLoading: widget.isLoading,
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _handleAuthAction();
                            }
                          },
                          text: _isRegistering ? "Register" : "Login",
                        ),
                        const VerticalSpacer(14),
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style,
                          onPressed: _toggleRegistering,
                    child: Text(_isRegistering
                        ? 'Already have an account? Login here'
                        : 'Don\'t have an account? Register here'),
                  ),
                  if (!_isRegistering) ...[
                    const VerticalSpacer(16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const VerticalSpacer(16),
                    OutlinedButton.icon(
                      onPressed: widget.isLoading ? null : widget.googleLogin,
                      icon: Image.network(
                        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                        height: 20,
                        width: 20,
                        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 20),
                      ),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    if (Platform.isIOS || Platform.isMacOS) ...[
                      const VerticalSpacer(12),
                      OutlinedButton.icon(
                        onPressed: widget.isLoading ? null : widget.appleLogin,
                        icon: const Icon(Icons.apple, size: 20),
                        label: const Text('Sign in with Apple'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthAction() {
    if (_isRegistering) {
      widget.registerUser(
        RegisterRequest(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          username: _usernameController.text,
          sex: _selectedSex,
          dateOfBirth: _dateOfBirth,
        ),
      );
      _emailController.clear();
      _passwordController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _usernameController.clear();
      _selectedSex = Sex.FEMALE;
      _dateOfBirth = null;
      _isRegistering = false;

      setState(() {});
    } else {
      widget.loginUser(
        LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
      setState(() {});
    }
  }

  void _onDateChanged(DateTime newDate) {
    _dateOfBirth = newDate;
    setState(() {});
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.trim().length < 8) {
      return 'Enter at least 8 characters';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value, String original) {
    if (value != original) {
      return 'Passwords do not match!';
    }
    return null;
  }

  String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers and underscores allowed';
    }
    return null;
  }
}
