import 'dart:async';
import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  bool _isMeditating = false;
  int _timeLeft = 300; // 5 minutes default
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    // Use CurvedAnimation to make the breathing effect smoother
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMeditation() {
    setState(() {
      _isMeditating = !_isMeditating;
    });

    if (_isMeditating) {
      _startTimer();
      _animationController.repeat(reverse: true);
    } else {
      _stopTimer();
      _animationController.stop();
      _animationController.reset();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _stopTimer();
        _animationController.stop();
        _animationController.reset();
        setState(() {
          _isMeditating = false;
          _timeLeft = 300; // Reset
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meditation session completed. Great job!')),
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Meditation'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isMeditating ? 'Breathe In... Breathe Out...' : 'Ready to relax?',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 50),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isMeditating ? _scaleAnimation.value : 1.0,
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        color: Colors.teal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _formatTime(_timeLeft),
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 60),
                      if (!_isMeditating)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDurationButton(60, '1 Min'),
                              const SizedBox(width: 10),
                              _buildDurationButton(300, '5 Min'),
                              const SizedBox(width: 10),
                              _buildDurationButton(600, '10 Min'),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _toggleMeditation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isMeditating ? Colors.redAccent : Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isMeditating ? 'Stop Session' : 'Start Session',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationButton(int seconds, String label) {
    final isSelected = _timeLeft == seconds;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _timeLeft = seconds;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal.withOpacity(0.1) : null,
        side: BorderSide(color: isSelected ? Colors.teal : Colors.grey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.teal : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
