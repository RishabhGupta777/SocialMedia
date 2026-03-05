import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Chat/view/screens/ChatScreen.dart';
import 'package:tiktok_clone/TikTok/constants.dart';
import 'package:tiktok_clone/TikTok/controller/auth_controller.dart';
import 'package:tiktok_clone/TikTok/controller/edit_profile_controller.dart';
import 'package:tiktok_clone/TikTok/controller/profile_controller.dart';
import 'package:tiktok_clone/TikTok/model/video.dart';
import 'package:tiktok_clone/TikTok/view/screens/display_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/drawerScreen.dart';
import 'package:tiktok_clone/TikTok/view/screens/edit_profile_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/followers_screen.dart';
import 'package:tiktok_clone/TikTok/view/screens/followings_screen.dart';
import 'package:tiktok_clone/TikTok/view/widgets/button.dart';
import 'package:tiktok_clone/TikTok/view/widgets/post_widget.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Instead of Get.put(), we create a new controller for EACH profile screen
  late final ProfileController profileController;
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// Use Get.put() to generate separate controller instance
    /// Create controller with UNIQUE TAG (uid based)
    profileController = Get.put(ProfileController(), tag: widget.uid,);

    /// Load user using direct method (no Rx _uid variable anymore)
    profileController.loadUser(widget.uid);
  }

  @override
  void dispose() {
    /// Delete only this profile's controller
    Get.delete<ProfileController>(tag: widget.uid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final user = profileController.user;
      return DefaultTabController(
            length: 1,
            child: Scaffold(
              appBar:AppBar(
                title:Text(user["name"] ?? ""),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      widget.uid == FirebaseAuth.instance.currentUser!.uid
                          ?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrawerScreen()
                        ),
                      )
                          : //Get.snackbar("NanoGram App", "Current Version 1.0")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiver: widget.uid,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                        widget.uid == FirebaseAuth.instance.currentUser!.uid
                            ? Icons.menu  //info_outline-->icon tha
                            : Icons.chat),
                  )
                ],
              ),
              body:  NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverAppBar(
                        automaticallyImplyLeading: false, // This removes the back arrow
                        floating: true,
                        pinned: true,
                        snap: true,
                        expandedHeight: 343.0,
                        forceElevated: innerBoxIsScrolled,
                        flexibleSpace: FlexibleSpaceBar( // Simplified the flexibleSpace
                          background: SafeArea(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 55, // Adjust the size
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: null,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                user['profilePic'],
                                                imageBuilder: (context, imageProvider) =>
                                                    CircleAvatar(
                                                      radius: 55,
                                                      backgroundImage: imageProvider,
                                                    ),
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                //errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 40,
                                            ),
                                            /// FOLLOWERS & FOLLOWING
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /// Followers
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FollowersScreen(
                                                                    uid: widget.uid)));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        user['followers'].toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text("Followers",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.w400))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                /// Following
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FollowingsScreen(
                                                                    uid: widget.uid)));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        user['following'].toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text("Followings",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.w400))
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),

                                        ///ABOUT
                                        user['about'].toString().trim().isEmpty
                                            ? const SizedBox.shrink()
                                            : Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            Text(user['about']),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        /// FOLLOW / EDIT BUTTON
                                        TButton(
                                          height: 35,
                                          width: 130,
                                          radius: 8,
                                          backgroundColor:primary,
                                          onTap: () {
                                            if (widget.uid ==
                                                FirebaseAuth.instance.currentUser!.uid) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileScreen(),
                                                ),
                                              );
                                            } else {
                                              profileController.followUser();
                                            }
                                          },
                                          text:widget.uid ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                              ? "Edit Profile"
                                              : user['isFollowing']
                                              ? "Following"
                                              : "Follow",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    // indent: 10,
                                    // endIndent: 10,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                        ),
                        bottom:  PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),  //here KTooBarHeight is byDefault and use hatana ho agar then use 48 there
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: TabBar(
                              // isScrollable: true,
                              dividerHeight:4,
                              dividerColor: Colors.grey,
                              indicatorColor:Colors.grey,//yha primary tha
                              unselectedLabelColor: Colors.grey,
                              labelColor:Colors.grey,
                              tabs: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tab(icon: Icon(Icons.grid_on,size:25,)),
                                    SizedBox(width:10),
                                    Text("Your Activity",style: TextStyle(fontSize: 18),)
                                  ],
                                ),
                                // Tab(icon: Icon(Icons.play_circle_outline)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body:  SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    children:[
                      /// Posts tab
                      Obx(() {
                        return ListView.builder(
                          padding:
                          const EdgeInsets.only(top: 60),
                          itemCount:
                          profileController.posts.length,
                          itemBuilder: (context, index) {
                            final data =
                            profileController.posts[index];
                            return PostWidget(data: data);
                          },
                        );
                      }),


                      /// Videos tab (placeholder)
                      // GridView.builder(
                      //     padding: EdgeInsets.only(top:60),
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     gridDelegate:
                      //     SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 3,
                      //       childAspectRatio: 1,
                      //       crossAxisSpacing: 2,
                      //       mainAxisSpacing: 2,
                      //     ),
                      //     itemCount: controller.user['thumbnails'].length,
                      //     itemBuilder: (context,index) {
                      //       String thumbnail =
                      //       controller.user['thumbnails'][index];
                      //       return GestureDetector(
                      //         onTap: () async {
                      //           ///Fetch videos from controller
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) => DisplayVideo_Screen(
                      //                 videos: controller.shorts.obs,
                      //                 initialIndex: index,
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //         child: CachedNetworkImage(
                      //           fit: BoxFit.cover,
                      //           imageUrl: thumbnail,
                      //           errorWidget: (context, url, error) =>
                      //               Icon(Icons.error),
                      //         ),
                      //       );
                      //     }),
                    ],
                  ),
                ),
              ),

            ),
          );
        });
  }
}
