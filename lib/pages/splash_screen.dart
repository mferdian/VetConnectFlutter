import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Set full-screen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to the Get Started screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/get-started');
      }
    });
  }

  @override
  void dispose() {
    // Restore the system UI when leaving the screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xFF497D74), // Background color
        child: Center(
          child: Image.asset(
            "assets/images/vetconnect-logo-white.png",
            width: 300, // Adjust width as needed
          ),
        ),
      ),
    );
  }
}
