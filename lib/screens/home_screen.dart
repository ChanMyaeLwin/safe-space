import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Safe Space'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
            const Text(
              'How are you feeling?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildFeatureCard(
              context,
              'Talk to Companion',
              'Chat with your AI wellbeing assistant',
              Icons.chat_bubble_outline,
              Colors.purpleAccent,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Daily Journal',
              'Record your thoughts and feelings',
              Icons.book_outlined,
              Colors.tealAccent,
              () {
                // TODO: Implement Journal
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journal feature coming soon!')),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Meditation',
              'Relax and clear your mind',
              Icons.self_improvement,
              Colors.orangeAccent,
              () {
                 // TODO: Implement Meditation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meditation feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color.withOpacity(0.8), size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
