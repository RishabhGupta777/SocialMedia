import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  final String latestVersion;
  final String updateUrl;

  const UpdateScreen({
    super.key,
    required this.latestVersion,
    required this.updateUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.system_update, size: 70, color: Colors.blue),

            const Text(
              "New Update Available!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(
              "A new version ($latestVersion) is available.\nPlease update to continue.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse(updateUrl);
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Update Now"),
            ),

            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Later"),
            )
          ],
        ),
      ),
    );
  }
}