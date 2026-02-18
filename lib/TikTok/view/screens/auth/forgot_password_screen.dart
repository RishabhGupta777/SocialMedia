import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';
import '../../widgets/text_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            SizedBox(height: 30),

            Text(
              "Enter your registered email to reset password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 30),

            TextInputField(
              controller: _emailController,
              myLabelText: "Email",
              myIcon: Icons.email,
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                AuthController.instance
                    .resetPassword(_emailController.text.trim());
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: Text("Send Reset Link"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
