import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/College/controller/attendance_provider.dart';
import 'package:tiktok_clone/College/view/screens/show_attendance_screen.dart';
import 'package:tiktok_clone/TikTok/view/widgets/glitch.dart';
import 'package:tiktok_clone/TikTok/view/widgets/rounded_container.dart';
import 'package:tiktok_clone/TikTok/view/widgets/text_input.dart';

class AttendanceLoginScreen extends StatefulWidget {
  AttendanceLoginScreen({super.key});

  @override
  State<AttendanceLoginScreen> createState() => _AttendanceLoginScreenState();
}

class _AttendanceLoginScreenState extends State<AttendanceLoginScreen> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.checkSavedLogin();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedContainer(
              height: 190,
              width: 190,
              child: Image.asset('assets/images/dcrust_logo.png'),
            ),
            SizedBox(height: 20,),
            GlithEffect(child: const Text("DCRUST ATTENDANCE" ,style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 23),)),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                myLabelText: "Email",
                myIcon: Icons.email,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                myLabelText: "Samarth Portal Password",
                myIcon: Icons.lock,
                toHide: true,
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    Get.snackbar("Error", "Please fill all fields",
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  Get.off(() => ShowAttendanceScreen(
                    username: username,
                    password: password,
                  ));
                },
                child: Container(
                padding: EdgeInsets.symmetric(horizontal:10 , vertical: 10),

                child: Text("Get Attendance"))),
          ],
        ),

      ),
    );
  }
}
