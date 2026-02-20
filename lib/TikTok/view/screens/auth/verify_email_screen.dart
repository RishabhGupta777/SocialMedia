import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';
import 'package:tiktok_clone/TikTok/view/screens/home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  Timer? timer;

  @override
  void initState() {
    super.initState();

    // auto check every 5 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser!.emailVerified) {
      timer?.cancel();
      Get.snackbar("Success", "Email verified successfully");
      //  AuthController.instance.signOut(); // optional, or navigate to home
      // OR navigate directly:
      Get.offAll(() => HomeScreen());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final userEmail = user.email ?? "No email";

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "After verifying, this screen will close automatically.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              const Icon(Icons.mark_email_unread, size: 90, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Verify your email address to continue",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              TextFormField(
                initialValue: userEmail,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Registered Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              /// RESEND EMAIL
              ElevatedButton(
                onPressed: () {
                  AuthController.instance.resendVerificationEmail();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text("Resend Verification Email"),
                ),
              ),

              const SizedBox(height: 15),

              /// MANUAL CHECK BUTTON
              ElevatedButton(
                onPressed: () async {
                  await checkEmailVerified();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text("I have verified"),
                ),
              ),

              const SizedBox(height: 15),

              /// SIGN OUT BUTTON
              TextButton(
                onPressed: () {
                  AuthController.instance.signOut();
                },
                child: const Text("Use different email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
