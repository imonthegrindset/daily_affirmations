import 'package:flutter/material.dart';
import '../services/openai_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _affirmation = "";
  bool _isLoading = false;

  Future<void> _generateAffirmation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await OpenAIService.generateAffirmation();
      setState(() {
        _affirmation = response;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _affirmation = "Error generating affirmation. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToPaymentScreen() {
    Navigator.pushNamed(context, '/payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Affirmations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: _goToPaymentScreen,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _affirmation.isEmpty
                          ? 'Press Generate to get your affirmation'
                          : _affirmation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generateAffirmation,
                      child: const Text('Generate'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
