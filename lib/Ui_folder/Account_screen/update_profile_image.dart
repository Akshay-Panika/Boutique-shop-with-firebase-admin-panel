import 'dart:io';

import 'package:boutique_shop/Ui_folder/Account_screen/account_screen.dart';
import 'package:boutique_shop/Ui_folder/First_screen/first_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models_folder/user_model.dart';
import '../../Widgets/card_widget.dart';
import '../../Widgets/round_button_Widget.dart';
import '../../Widgets/text_style_widget.dart';

class UpdateProfileImage extends StatefulWidget {
  final String userImage;
  final String userCredential;
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? userAddress;
  const UpdateProfileImage({super.key, required this.userImage, required this.userCredential, this.userName, this.userEmail, this.userMobile, this.userAddress});

  @override
  State<UpdateProfileImage> createState() => _UpdateProfileImageState();
}
class _UpdateProfileImageState extends State<UpdateProfileImage> {
  bool isLoading= false;
  File? pickedImage;
  bool isPicked = false;
  ///___ pic image from gallery
  void picImageFromGallery()async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      pickedImage = File(image.path);
      setState(() {
        isPicked =true;
      });
    }
  }

  ///___ Save data from firebase
   saveUserDataFromFire()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref().child('users').child(widget.userCredential).putFile(pickedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    var userData = UserModel(userName:widget.userName,userImage:downloadUrl,
      userPhone: widget.userMobile,userAddress: widget.userAddress,userEmail: widget.userEmail,userId: widget.userCredential,).toMap();
    FirebaseFirestore.instance.collection('users').doc(widget.userCredential).update(userData).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const FirstScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Profile image",style: textStyleBlack20,),
        ),
        Center(
          child: Container(margin: const EdgeInsets.all(15),
            height: 200,width:200,
            child:isPicked ? ClipRRect(borderRadius: BorderRadius.circular(5),
                child: CardWidget(child: Image.file(pickedImage!,fit: BoxFit.fill,))):
            CardWidget(
              child: CachedNetworkImage(
                imageUrl: widget.userImage.toString(),
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.image,color: Colors.black54,),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: RoundButtonWidget(text: "Pic Profile",onTap: () {picImageFromGallery();},)),
            //Expanded(child: RoundButtonWidget(text: "Save Profile",onTap: () {saveUserDataFromFire();},)),
            Expanded(
              child: InkWell(
                child:isLoading? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.0),
                  child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.black54,)),
                ):
                const RoundButtonWidget(
                  text: "Update",
                ),
                onTap: ()async{
                  setState(() {
                    isLoading =true;
                  });
                  try{
                    await saveUserDataFromFire();
                  }finally{
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
