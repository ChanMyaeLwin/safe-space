import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'screens/landing_page.dart'; // Import LandingPage
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const SafeSpaceApp());
}

class SafeSpaceApp extends StatelessWidget {
  const SafeSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Safe Space',
        theme: ThemeData(
          // Updated color scheme to match the new logo (Teal/Greenish)
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF009688), // Material Teal 500
            primary: const Color(0xFF00796B),   // Darker Teal for primary actions
            secondary: const Color(0xFF4DB6AC), // Lighter Teal for accents
            surface: Colors.white,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light Grey background
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF004D40), // Very Dark Teal for text
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF004D40)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF00796B),
            ),
          ),
        ),
        // Switch to LandingPage as the entry point
        home: const LandingPage(), 
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
