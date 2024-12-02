import 'package:flutter/material.dart';
import 'package:joven/routes.dart';
import 'package:joven/service/api_service.dart';
import 'package:joven/service/hive_service.dart';
import 'package:joven/service/location_service.dart';
import 'package:joven/utils/asset.dart';
import 'package:joven/utils/log.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  Future<void> _loginUser() async {
    _isLoadingStatus(true);
    try {
      final bodyReq = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };
      final response = await _apiService.postRequest(
        '/api/user/login',
        bodyReq,
      );
      final data = response['data'];
      HiveService.saveToken(data);
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
      Log.d(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      _isLoadingStatus(false);
    }
  }

  void _getLocation() async {
    final LocationService locationService = LocationService();
    var location = await locationService.getCurrentPosition();
    if (location == null && mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              icon: const Icon(Icons.location_off),
              title: const Text('Location Permission'),
              content: const Text(
                'The app cannot run without permission location. Please grant location permission to use this app.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _requestLocationPermission() async {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            icon: const Icon(Icons.location_on),
            title: const Text('Location Permission'),
            content: const Text(
              'Please grant location permission to use this app.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getLocation();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _requestLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset(Asset.logo),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Linkjo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
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
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
