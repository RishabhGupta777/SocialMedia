import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok_clone/AppVersion.dart';
import 'package:tiktok_clone/TikTok/view/screens/update_screen.dart';

class UpdateController extends GetxController {

  Future<void> checkForUpdate() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('update')
          .get();

      if (!doc.exists) return;

      String latestVersion = doc['latest_version'];
      String updateUrl = doc['update_url'];

      // Compare with manual version
      if (latestVersion != AppVersion.currentVersion) {
        Get.dialog(
          UpdateScreen(
            latestVersion: latestVersion,
            updateUrl: updateUrl,
          ),
          barrierDismissible: false, // force update like Vidmate
        );
      }
      else{
        Get.snackbar(
          "Up To Date",
          "You are using the latest version 🎉",
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      print("Update check failed: $e");
    }
  }
}