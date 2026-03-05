import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/TikTok/model/post.dart';
import 'package:tiktok_clone/TikTok/model/video.dart';

class ProfileController extends GetxController {
  final RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  final RxList<Post> posts = <Post>[].obs;
  final RxList<Video> shorts = <Video>[].obs;

  RxBool isLoading = false.obs;

  String? profileUid;  ///STORE UID LOCALLY PER CONTROLLER

  /// RENAMED (professional naming)
  Future<void> loadUser(String uid) async {
    try{
      isLoading.value = true;
      profileUid = uid;   /// STORE UID

      /// BIND POSTS STREAM
      posts.bindStream(
        FirebaseFirestore.instance
            .collection("posts")
            .where("uid", isEqualTo: uid)
            .orderBy("datePub", descending: true)
            .snapshots()
            .map((snapshot) =>
            snapshot.docs.map((e) => Post.fromSnap(e)).toList()),
      );

      /// BIND SHORTS STREAM
      shorts.bindStream(
        FirebaseFirestore.instance
            .collection("videos")
            .where("uid", isEqualTo: uid)
            .orderBy("timestamp", descending: true)
            .snapshots()
            .map((snapshot) =>
            snapshot.docs.map((e) => Video.fromSnap(e)).toList()),
      );

      /// USER DATA
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users").doc(uid).get();

      DocumentSnapshot userInfoDoc = await FirebaseFirestore.instance
          .collection("usersInfo").doc(uid).get();

      int followers = (await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("followers")
          .get())
          .docs
          .length;

      int following = (await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("following")
          .get())
          .docs
          .length;

      bool isFollowing = false;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("followers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          //FOLLOW KRTA HAI
          isFollowing = true;
        } else {
          //FOLLOW NHI KRTA HAI
          isFollowing = false;
        }
      });

      user.value = {
        "name": userDoc["name"] ?? " ",
        "profilePic": userDoc["profilePic"] ?? " ",
        "about": userInfoDoc.exists
            ? (userInfoDoc.data() as Map<String, dynamic>)["about"] ?? ""
            : "",
        "followers": followers,
        "following": following,
        "isFollowing": isFollowing,
      };
      isLoading.value = false;
    } catch(e){
      print("Error loading profile: $e");
      Get.snackbar("Try again!",
          "Your Internet connection may be slow or off");
    }
  }

  /// FOLLOW / UNFOLLOW (Optimized)
  Future<void> followUser() async {
    if (profileUid == null) return;

    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(profileUid)
        .collection("followers")
        .doc(currentUid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(profileUid)
          .collection("followers")
          .doc(currentUid)
          .set({});

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("following")
          .doc(profileUid)
          .set({});

      user.update("followers", (val) => val + 1);
      user.update("isFollowing", (val) => true);
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(profileUid)
          .collection("followers")
          .doc(currentUid)
          .delete();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("following")
          .doc(profileUid)
          .delete();

      user.update("followers", (val) => val - 1);
      user.update("isFollowing", (val) => false);
    }
  }
}

