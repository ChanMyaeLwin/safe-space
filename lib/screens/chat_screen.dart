import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/firestore_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late GeminiService _geminiService;
  late FirestoreService _firestoreService;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';
  
  // Animation controller for the breathing indicator
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
    _firestoreService = FirestoreService();
    
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Initial greeting
    _messages.add(ChatMessage(
      text: "Hello, I'm your Safe Space companion. How are you feeling today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
    // Load history
    _loadHistory();
  }
  
  @override
  void dispose() {
    _breathingController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _loadHistory() {
     _firestoreService.getChatStream(_userId).listen((messages) {
       if (mounted) {
         setState(() {
           _messages.clear();
           if (messages.isEmpty) {
              _messages.add(ChatMessage(
                text: "Hello, I'm your Safe Space companion. How are you feeling today?",
                isUser: false,
                timestamp: DateTime.now(),
              ));
           } else {
             _messages.addAll(messages);
           }
         });
         _scrollToBottom();
       }
     });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Save user message to Firestore
    await _firestoreService.saveMessage(_userId, userMessage);
    
    setState(() {
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final prompt = "Act as a compassionate, supportive, and non-judgmental wellbeing companion. The user says: $text";
      
      final response = await _geminiService.generateResponse(prompt);
      
      final botMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      await _firestoreService.saveMessage(_userId, botMessage);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("I'm having trouble connecting right now. Please try again later.")),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Safe Space Companion'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
             elevation: isSmallScreen ? 0 : 4,
             margin: isSmallScreen ? EdgeInsets.zero : const EdgeInsets.all(16),
             color: isSmallScreen ? Colors.transparent : Colors.white,
             shape: isSmallScreen 
                ? const RoundedRectangleBorder() 
                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                if (_isLoading)
                  _buildTypingIndicator(),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FadeTransition(
          opacity: _breathingController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16, 
                  height: 16, 
                  child: CircularProgressIndicator(
                    strokeWidth: 2, 
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade300)
                  )
                ),
                const SizedBox(width: 10),
                Text(
                  "Thinking...", 
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.teal,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
