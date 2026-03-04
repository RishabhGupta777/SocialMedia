import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';
import 'package:tiktok_clone/TikTok/controller/update_controller.dart';
import 'package:tiktok_clone/TikTok/view/screens/auth/forgot_password_screen.dart';

class DrawerScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: [
          SizedBox(height:10),
          ListTile(
            onTap: (){
              Get.find<UpdateController>().checkForUpdate(showMessageIfUpToDate: true);
            },
            leading: const Icon(Icons.security_update),
            title: const Text('New update'),
          ),
          ListTile(
            onTap: (){
              Get.to(ForgotPasswordScreen());
            },
            leading: const Icon(Icons.vpn_key_outlined),
            title: const Text('Change password'),
          ),
          ListTile(
            onTap: ()async { await authController.signOut();},
            leading: const Icon(Icons.logout),
            title: const Text('Logout',style: TextStyle(color: Colors.red),),
          ),
        ],
      )
    );
  }
}
