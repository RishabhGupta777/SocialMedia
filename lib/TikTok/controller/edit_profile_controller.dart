import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/TikTok/controller/profile_controller.dart';

class EditProfileController extends GetxController {
  final _auth = FirebaseAuth.instance; //_auth is object and FirebaseAuth isa class
  final _firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();


  Rx<XFile?> proImg = Rx<XFile?>(null);
  RxBool isUploading = false.obs;

  ///pick image
  void pickImageFromGallery() async{
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      proImg.value = image;
      _uploadProfilePic(File(image.path));
    }
  }
  void pickImageFromCamera() async{
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      proImg.value = image;
      _uploadProfilePic(File(image.path));
    }
  }

  /// UPLOAD PROFILE PIC
  Future<void> _uploadProfilePic(File image) async {
    try {
      isUploading.value = true;

      String userId = _auth.currentUser!.uid;

      // Upload to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child('profilePics').child(userId);
      UploadTask uploadTask = storageRef.putFile(image);

      // Get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {'profilePic': downloadUrl},
        SetOptions(merge: true),
      );


      /// Instead of Get.put(), find the EXISTING tagged controller
      if (Get.isRegistered<ProfileController>(tag: userId)) {
        Get.find<ProfileController>(tag: userId).loadUser(userId);
      }

    } catch (e) {
      Get.snackbar("Error", "$e");
    }
    finally {
      isUploading.value = false;
    }
  }

  /// GET CURRENT USER UID
  String getUserUid(){
    return _auth.currentUser!.email ?? 'No email found';
  }

  ///update name
  void updateName(String newName){
    String userId = _auth.currentUser!.uid;

    String trimmedName = newName.trim();
    _firestore.collection('users').doc(userId).set(
        {
          'name': trimmedName,
          'nameLower': trimmedName.toLowerCase(),
        },
        SetOptions(merge: true));

    /// ✅ Refresh only correct profile controller
    if (Get.isRegistered<ProfileController>(tag: userId)) {
      Get.find<ProfileController>(tag: userId).loadUser(userId);
    }
  }

  /// UPDATE ABOUT
  void updateAbout(String newAbout){
    String userId = _auth.currentUser!.uid;
    _firestore.collection('usersInfo').doc(userId).set(
        {'about': newAbout},
        SetOptions(merge: true));

    /// ✅ Refresh only correct controller
    if (Get.isRegistered<ProfileController>(tag: userId)) {
      Get.find<ProfileController>(tag: userId).loadUser(userId);
    }
  }

}