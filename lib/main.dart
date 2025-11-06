import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/Chat/controller/ChatProvider.dart';
import 'package:tiktok_clone/Chat/controller/select_person_provider.dart';
import 'package:tiktok_clone/College/controller/attendance_provider.dart';
import 'package:tiktok_clone/TikTok/controller/firebase_notification_service.dart';
import 'package:tiktok_clone/TikTok/controller/local_notification_service.dart';
import 'package:tiktok_clone/TikTok/view/screens/home_screen.dart';
import 'TikTok/constants.dart';
import 'TikTok/controller/auth_controller.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value){
    Get.put(AuthController());
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    LocalNotificationService.initialize();
  });
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          ChangeNotifierProvider(create: (context) => SelectPersonProvider()),
          ChangeNotifierProvider(create: (context) =>AttendanceProvider()),
          ChangeNotifierProvider(create: (context) =>FirebaseNotificationService()),
        ],
        child: const MyApp(), // Use 'const' with the constructor to improve performance.
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DCRUST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(

          scaffoldBackgroundColor: backgroundColor
      ),
      home: HomeScreen(),
    );
  }
}