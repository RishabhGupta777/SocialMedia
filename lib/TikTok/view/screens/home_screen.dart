import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/Chat/view/screens/chat_users.dart';
import 'package:tiktok_clone/College/view/screens/college_home_screen.dart';
import 'package:tiktok_clone/TikTok/constants.dart';
import 'package:tiktok_clone/TikTok/controller/firebase_notification_service.dart';
import 'package:tiktok_clone/TikTok/view/screens/add_video.dart';
import 'package:tiktok_clone/TikTok/view/screens/display_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/feed_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/profile_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/search_screen.dart';
import 'package:tiktok_clone/TikTok/view/widgets/customAddIcon.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int pageIdx = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final chatProvider = Provider.of<FirebaseNotificationService>(context, listen: false);
    chatProvider.initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        onTap: (index){
  setState(() {
    pageIdx = index;
  });
        },
        currentIndex: pageIdx,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 25),
            label: 'Home'

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed_outlined, size: 25),
              label: 'Feed'

          ),


          // BottomNavigationBarItem(
          //     icon: customAddIcon(),
          //     label: ''
          //
          // ),

          // BottomNavigationBarItem(
          //     icon: Icon(Icons.video_collection_outlined, size: 25),
          //     label: 'Shorts'
          //
          // ),

          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 35),
              label: ''

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 25),
              label: 'Messages'

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 25),
              label: 'Profile'

          ),
        ],
      ),
      body: Center(
        child: [
          CollegeHomeScreen(),
          FeedScreen(),
          // addVideoScreen(),
          // DisplayVideo_Screen(),
          SearchScreen(),
          ChatUsers(),
          ProfileScreen( uid: FirebaseAuth.instance.currentUser?.uid ?? ''),
        ][pageIdx],
      ),
    );
  }
}
