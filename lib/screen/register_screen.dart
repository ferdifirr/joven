import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joven/routes.dart';
import 'package:joven/service/api_service.dart';
import 'package:joven/utils/asset.dart';
import 'package:joven/utils/log.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService _apiService = ApiService.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isUsernameValid = true; // Assume username is valid by default
  bool _isCheckingUsername = false;
  bool _isLoading = false;
  Timer? _debounce;

  void _isLoadingStatus(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _isCheckingUsernameStatus(bool isChecking) {
    setState(() {
      _isCheckingUsername = isChecking;
    });
  }

  void _onUsernameChanged() {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _isUsernameValid = false;
      });
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _isCheckingUsernameStatus(true);
    _debounce = Timer(const Duration(seconds: 2), () {
      _checkUsernameAvailability(_usernameController.text);
    });
  }

  Future<void> _checkUsernameAvailability(String username) async {
    try {
      final data = await _apiService.getRequest('/api/user/$username');
      final isUsernameAvailable = data['data'];
      setState(() {
        _isUsernameValid = isUsernameAvailable;
      });
    } catch (e) {
      Log.d(e.toString());
      setState(() {
        _isUsernameValid = false;
      });
    } finally {
      _isCheckingUsernameStatus(false);
    }
  }

  Future<void> _registerUser() async {
    _isLoadingStatus(true);
    final data = {
      'username': _usernameController.text,
      'name': _fullnameController.text,
      'email': _emailController.text,
      'phone_number': _phoneController.text,
      'password': _passwordController.text,
    };
    try {
      await _apiService.postRequest('/api/user/register', data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      Log.d(e.toString());
    } finally {
      _isLoadingStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(Asset.logo),
          ),
          const SizedBox(height: 20),
          Text(
            'Create an Account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: _isCheckingUsername
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: Center(
                                heightFactor: 14,
                                widthFactor: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : _isUsernameValid
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    readOnly: !_isUsernameValid,
                    controller: _fullnameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_3_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    readOnly: !_isUsernameValid,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    readOnly: !_isUsernameValid,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    readOnly: !_isUsernameValid,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isUsernameValid
                        ? () {
                            // _registerUser();
                            Navigator.pushNamed(context, Routes.registerVendor);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Create Account'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
