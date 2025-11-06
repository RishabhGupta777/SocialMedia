import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/TikTok/model/post.dart';
import 'package:tiktok_clone/TikTok/view/widgets/post_widget.dart';

class NotificationScreen extends StatelessWidget {
  final String id; // post id
  const NotificationScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Notification"),
        actions: [
          Icon(Icons.notifications_active_outlined)
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Post not found"));
          }

          final post = Post.fromSnap(snapshot.data!);
          return SingleChildScrollView(
            child: PostWidget(data: post),
          );
        },
      ),
    );
  }
}
