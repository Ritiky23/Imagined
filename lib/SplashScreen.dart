import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imagined/OnboardingScreen.dart';
import 'package:imagined/StorageService.dart';
import 'MainScreen.dart'; // Import your main screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main screen after 3 seconds
    Timer(Duration(seconds: 3), () async {
      bool userExists = await StorageService.userExists(); // Check if user data exists
      if (userExists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to MainScreen
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnboardingScreen()), // Navigate to OnboardingScreen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: Image.asset('assets/animations/logo2.png', width: 150, height: 150), // Adjust size as needed
      ),
    );
  }
}
