import 'package:tiktok_clone/Chat/view/widgets/attach_icons.dart';
import 'package:tiktok_clone/TikTok/constants.dart';
import 'package:tiktok_clone/TikTok/view/screens/addcaption_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/TikTok/view/screens/create_post_screen.dart';
import 'dart:io';
import 'package:tiktok_clone/TikTok/view/widgets/button.dart';
import 'package:image_picker/image_picker.dart';

class addVideoScreen extends StatelessWidget {
   addVideoScreen({Key? key}) : super(key: key);
videoPick(ImageSource src , BuildContext context) async{
  final video  = await ImagePicker().pickVideo(source: src);
  if(video != null){
    Get.snackbar("Video Selected", video.path);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> addCaption_Screen(videoFile: File(video.path), videoPath: video.path)));

  }else{
    Get.snackbar("Error In Selecting Video", "Please Choose A Different Video File");
  }
}
   showDialogOpt(BuildContext context){
     return showDialog(context: context, builder: (context)=>
     SimpleDialog(
       children: [
         Padding(
           padding: const EdgeInsets.only(top:20.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               AttachIcons(
                   onPressed:()=>videoPick(ImageSource.gallery , context),
                   icon: Icon(Icons.photo_library_outlined,color: Colors.blue,),
                   iconName: Text("Gallery")),
               SizedBox(width: 50,),
               AttachIcons(
                   onPressed:()=>videoPick(ImageSource.camera , context),
                   icon: Icon(Icons.camera_alt_outlined,color: Colors.red,),
                   iconName: Text('Camera')),
             ],
           ),
         ),
         SizedBox(height: 10,),
         SimpleDialogOption(
           onPressed: (){
             Navigator.pop(context);
           },
           child: Text("Close"),
         )
       ],
     ));
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TButton(
                text: "Add Shorts",
                height: 35,
                width: 190,
                textColor: Colors.black,
                onTap:()=>showDialogOpt(context)),
            SizedBox(height: 20,),
            TButton(
                text: "Create a Post",
                height: 35,
                width: 190,
                textColor: Colors.black,
                onTap:(){
                  Get.to(() => CreatePostScreen());
                }),
          ],
        ),
      ),
    );
  }
}
