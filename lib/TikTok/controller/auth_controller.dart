import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiktok_clone/TikTok/model/user.dart';
import 'package:tiktok_clone/TikTok/view/screens/auth/verify_email_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/home_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();
  // Make proimg reactive
  Rx<File?> proimg = Rx<File?>(null);

void pickImage() async{
  print("IMAGE PICKED SUCCESSFULLY");
final image = await ImagePicker().pickImage(source: ImageSource.gallery);
// if(image == null) return;

final img = File(image!.path);
this.proimg.value = img;

}

//User State Persistence


   late Rx<User?> _user;
  User get user => _user.value!;

// _user  - Nadi
  // _user.bindStream - Nadi Me Color Deko
  //ever - Aap Ho
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);

    //Rx - Observable Keyword - Continously Checking Variable Is Changing Or Not.
  }

  _setInitialView(User? user) async {
    if(user == null){
      Get.offAll(()=> LoginScreen());
    }else{
      await user.reload();
      if (user.emailVerified) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() =>const VerifyEmailScreen());
        Get.snackbar("Verify Email",
            "Please verify your email before accessing the app.");
      }
    }
  }



  ///User Register
  void SignUp(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // SEND EMAIL VERIFICATION
        await credential.user!.sendEmailVerification();

       String downloadUrl = await _uploadProPic(image);

        myUser user = myUser(name: username, email: email, profilePhoto: downloadUrl, uid: credential.user!.uid);

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          ...user.toJson(),   // spread the map
          "nameLower": username.toLowerCase()  // Ram-->ram
        });

        Get.snackbar("Verify Email",
            "Verification link sent to your email. Please verify before login.");
      }
      else{
        Get.snackbar("Fill all the credentials",
            "Uploading profile pic and name is Mandatory");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error Occurred", e.toString());
    }
  }

  Future<String> _uploadProPic(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageDwnUrl = await snapshot.ref.getDownloadURL();
    return imageDwnUrl;
  }


  void login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "Enter email and password");
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    }
  }

  /// RESEND EMAIL VERIFICATION
  void resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar("Error", "Login first to resend verification email");
        return;
      }

      await user.sendEmailVerification();
      Get.snackbar("Sent", "Verification email sent again.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  signOut(){
    FirebaseAuth.instance.signOut();
    Get.offAll(LoginScreen());
  }

  ///forgot password
  void resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        Get.snackbar("Error", "Please enter your email");
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Get.snackbar(
        "Password Reset",
        "Password reset link sent to your email",
      );

      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }



}
