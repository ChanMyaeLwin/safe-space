import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('About Safe Space'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: const AboutScreenBody(),
    );
  }
}

class AboutScreenBody extends StatefulWidget {
  final bool showLoginButton;

  const AboutScreenBody({super.key, this.showLoginButton = false});

  @override
  State<AboutScreenBody> createState() => _AboutScreenBodyState();
}

class _AboutScreenBodyState extends State<AboutScreenBody> {
  int _userCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
  }

  Future<void> _fetchUserCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').count().get();
      if (mounted) {
        setState(() {
          _userCount = snapshot.count ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching user count: $e');
    }
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
         throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $e')),
         );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                     Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            // color: Colors.teal.shade50, // Optional background
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  const Icon(Icons.spa, size: 80, color: Color(0xFF009688)),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Safe Space',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your compassionate AI companion for mental wellbeing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    
                    if (widget.showLoginButton)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009688), // Match theme
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Get Started'),
                        ),
                      ),

                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildStatCard('$_userCount+', 'Users'), // Using real count
                        _buildStatCard('4.8/5', 'Rating'),
                        _buildStatCard('24/7', 'Support'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Features Grid
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildFeatureCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Empathetic Chat',
                    description: 'Talk freely with our AI companion trained to be supportive and non-judgmental.',
                  ),
                  _buildFeatureCard(
                    icon: Icons.security,
                    title: 'Private & Secure',
                    description: 'Your conversations are private. We prioritize your data security and anonymity.',
                  ),
                  _buildFeatureCard(
                    icon: Icons.favorite_border,
                    title: 'Always There',
                    description: 'Available 24/7 whenever you need a listening ear or a moment of calm.',
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Philosophy Section
              const Text(
                'Our Philosophy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'We believe everyone deserves a safe space to be heard. In a busy world, finding a moment of peace and a non-judgmental ear can be transformative. Safe Space is built to provide exactly that—accessible, immediate, and compassionate support for everyone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              // Support Us Section
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFE0F2F1), Colors.white], // Light Teal to White
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Support Our Mission',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Safe Space is a passion project. Your support helps us keep the servers running and the AI thoughtful. If this app has helped you, consider buying us a coffee!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(context, 'https://buymeacoffee.com/chanmyaelwin'),
                      icon: const Icon(Icons.coffee),
                      label: const Text('Buy Me a Coffee'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDD00), // Buy Me a Coffee yellow
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Footer
              Text(
                'Made with ❤️ for You',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Teal 50
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF009688), // Teal 500
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF00796B), // Teal 700
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF009688)), // Teal 500
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
