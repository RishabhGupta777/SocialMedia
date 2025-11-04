import 'package:flutter/material.dart';
import 'package:tiktok_clone/College/view/screens/show_attendance_screen.dart';
import 'package:tiktok_clone/TikTok/view/widgets/glitch.dart';
import 'package:tiktok_clone/TikTok/view/widgets/text_input.dart';

class AttendanceLoginScreen extends StatelessWidget {
  AttendanceLoginScreen({super.key});
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        //const - Constant - Value - String , Int  - Fix Rahega  - Use Karna
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlithEffect(child: const Text("DCRUST ATTENDANCE" ,style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 30),)),
            SizedBox(height: 25,),
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
                myLabelText: "Password",
                myIcon: Icons.lock,
                toHide: true,
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ShowAttendanceScreen(username:_usernameController.text,password:  _passwordController.text),),
              );
            }, child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 10),

                child: Text("Get Attendance"))),
          ],
        ),

      ),
    );
  }
}
