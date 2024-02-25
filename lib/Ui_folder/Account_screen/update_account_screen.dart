import 'dart:io';
import 'package:boutique_shop/Ui_folder/Account_screen/update_profile_image.dart';
import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/round_button_Widget.dart';
import 'package:boutique_shop/Widgets/text_field_widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models_folder/user_model.dart';


class UpdateAccountScreen extends StatefulWidget {
  final String? userCredential;
  final String? userImage;
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? userAddress;
  const UpdateAccountScreen({super.key,required this.userCredential, this.userName, this.userEmail, this.userMobile, this.userAddress, this.userImage,});
  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}
class _UpdateAccountScreenState extends State<UpdateAccountScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isLoading =false;
  File? pickedImage;
  bool isPicked = false;
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
   saveUserDataFromFire()async{
    var userData = UserModel(userName:nameController.text,userImage: widget.userImage,
      userPhone: phoneController.text,userAddress: addressController.text,userEmail: widget.userEmail,userId: widget.userCredential,).toMap();
    FirebaseFirestore.instance.collection('users').doc(widget.userCredential).update(userData).then((value) {
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.userName.toString();
    phoneController.text=widget.userMobile.toString();
    addressController.text=widget.userAddress.toString();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              50.height,
              ///___ Image
              Stack(
                children: [
                  Container(height: 120,width: 120,margin: const EdgeInsets.all(20),
                    child: CardWidget(
                      child: CachedNetworkImage(
                        imageUrl: widget.userImage.toString(),fit: BoxFit.fill,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.image,color: Colors.black54,),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -5,right: -5,
                      child: IconButton(icon: const Icon(Icons.edit,color: Colors.black54,),onPressed: () {
                       showModalBottomSheet(
                       //isScrollControlled: true,
                       context: context, builder: (context) {
                         return UpdateProfileImage(userImage:widget.userImage.toString(),userCredential: widget.userCredential!,
                         userName: widget.userName,userAddress: widget.userAddress,userMobile: widget.userMobile,userEmail: widget.userEmail,);
                       },);
                      },))
                ],
              ),
              ///___ User data
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget(hintText:widget.userName.toString() ,controller: nameController,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.height,
                        Text(widget.userEmail.toString(),style: textStyleGrey13,),
                        Divider(thickness: 1,color: Colors.grey.shade400,),
                      ],
                    ),
                    TextFieldWidget(hintText:widget.userMobile.toString(),controller: phoneController, ),

                    TextFieldWidget(hintText:widget.userAddress.toString(),controller: addressController, ),

                    50.height,
                    InkWell(
                      child:isLoading? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
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
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
