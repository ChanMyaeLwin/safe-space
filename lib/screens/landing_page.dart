import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'about_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // If already logged in, show HomeScreen
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user != null) {
            return const HomeScreen();
          }
          // If not logged in, show the public landing page content (from AboutScreen)
          // but modified to include a "Login / Get Started" button.
          return const PublicLandingScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class PublicLandingScreen extends StatelessWidget {
  const PublicLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reusing the nice layout from AboutScreen but adding the Login button
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Safe Space'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const AboutScreenBody(showLoginButton: true),
    );
  }
}
