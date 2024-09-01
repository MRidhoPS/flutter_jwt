// ignore_for_file: use_build_context_synchronously

import 'package:consume_jwt/api/api.dart';
import 'package:consume_jwt/api/auth.dart';
import 'package:consume_jwt/model/user_model.dart';
import 'package:consume_jwt/view/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthServices _authService = AuthServices();
  final ApiServices _apiServices = ApiServices();

  String? _token;
  String? _errorMessage;
  ApiResponse? _data;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  // Initialize the token when the page loads
  Future<void> _initializeToken() async {
    try {
      final token = await _authService.getToken();
      if (token != null && token.isNotEmpty) {
        setState(() {
          _token = token;
        });
        await getItemsToken(); // Fetch items after token is initialized
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load token: $e';
      });
    }
  }

  Future<void> getItemsToken() async {
    try {
      final response = await _apiServices.getItems();
      setState(() {
        _data = response;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data: $e';
      });
    }
  }

  // Handle logout and clear token
  Future<void> _logout() async {
    try {
      await _authService.logout();
      setState(() {
        _token = null;
        _errorMessage = null;
      });
      // Redirect back to SplashScreen (or Login) as token will be null
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Logout failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: _token != null
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_token != null) ...[
              const SizedBox(height: 20),
              Text('Token:\n$_token'),
            ],
            if (_data != null) ...[
              Text('User: ${_data!.user['name']}'), // Safely access properties
            ] else ...[
              const Text('Loading data...'), // Show loading or a placeholder
            ],
          ],
        ),
      ),
    );
  }
}
