import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:tiktok_clone/TikTok/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(_controller);

    _controller.forward();

    // After animation, AuthController will automatically route user
    Timer(const Duration(seconds: 3), () {
      // Just trigger GetX lifecycle; no navigation here
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child:const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school, size: 90, color: primary),
                SizedBox(height: 20),
                Text(
                  "Welcome to DCRUST",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Student Companion App",
                  style: TextStyle(color:primary, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
