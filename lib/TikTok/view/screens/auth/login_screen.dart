import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';
import 'package:tiktok_clone/TikTok/view/screens/auth/forgot_password_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/auth/signup_screen.dart';
import 'package:tiktok_clone/TikTok/view/widgets/glitch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/TikTok/view/widgets/rounded_container.dart';


import '../../widgets/text_input.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
TextEditingController _emailController = new TextEditingController();
TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        //const - Constant - Value - String , Int  - Fix Rahega  - Use Karna
        child : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TRoundedContainer(
                height: 190,
                width: 190,
                child: Image.asset('assets/images/dcrust_logo.png'),
              ),
              SizedBox(height: 20,),
              GlithEffect(child: const Text("DCRUST" ,style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 30),)),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                    }, child: Text("Forgot password?")),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                           AuthController.instance.login(_emailController.text, _passwordController.text);},
                  child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 10),
                         child: Text("Login"))
              ),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
              }, child: Text("New User ? Click Here"))
            ],
          ),
        ),

      ),
    );
  }
}
