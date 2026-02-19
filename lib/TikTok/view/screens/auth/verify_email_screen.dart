import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';


class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // IF USER NOT LOGGED IN
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user logged in"),
        ),
      );
    }

    final userEmail = user.email ?? "No email";

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            const SizedBox(height: 30),

            const Text(
              "Please verify your email address",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            TextFormField(
              initialValue: userEmail,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Your Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                AuthController.instance.resendVerificationEmail();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: Text("Send verification link"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
