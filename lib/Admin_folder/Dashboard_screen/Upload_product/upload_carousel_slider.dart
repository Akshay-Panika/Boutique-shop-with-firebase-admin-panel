import 'dart:io';
import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/text_field_widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../Models_folder/carousel_slider_model.dart';

class UploadCarouselSlider extends StatefulWidget {
  const UploadCarouselSlider({super.key});

  @override
  State<UploadCarouselSlider> createState() => _UploadCarouselSliderState();
}
class _UploadCarouselSliderState extends State<UploadCarouselSlider> {

  TextEditingController headlineController = TextEditingController();
  bool isLoading = false;
  File? pickedImage;
  bool isPicked = false;
  ///___ Pic image from gallery
  void picImageFromGallery()async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      pickedImage = File(image.path);
      setState(() {
        isPicked = true;
      });
    }
  }

  ///___ Save data from firebase
   saveDataFromFirebase()async{
    String headlineText = headlineController.text.trim();
    if(headlineText != "" && pickedImage != null){
      try{
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('carouselSlider').child(const Uuid().v1()).putFile(pickedImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        var data = CarouselSliderModel(documentId:const Uuid().v1(),bannerImage: downloadUrl, headline: headlineText).toMap();
        FirebaseFirestore.instance.collection('carouselSlider').add(data).then((value) {
          Navigator.pop(context);
        });
      }catch(error){
        print("Error uploading image or saving data: $error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    }
    else{
      print("Please fill all the fields!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields!')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          50.height,
          TextFieldWidget(hintText: "Headlines....", controller: headlineController),

          30.height,
          Expanded(
            child: CardWidget(
              color: Colors.grey.shade200,
              child: isPicked ? Image.file(pickedImage!,fit: BoxFit.fill,):const Center(child: Text("Data is empty")),
            ),
          ),

          ///___ Function button
          20.height,
          Padding(
            padding: const EdgeInsets.only(bottom:100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ///___ Upload thumbnail
                Expanded(
                  child: InkWell(
                    child: const CardWidget(
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(child: Text("Upload thumbnail",style: TextStyle(fontSize:15,color: Colors.white),)),
                        )),
                    onTap: () {
                      picImageFromGallery();
                    },
                  ),
                ),

                5.width,
                ///___ Save data
                InkWell(
                  child:isLoading? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.black54,)),
                  ):
                  const CardWidget(
                    color: Colors.black54,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28,vertical: 8),
                      child: Center(child: Text("save data",style: TextStyle(color: Colors.white),),),
                    ),
                  ),
                  onTap: ()async{
                     setState(() {
                       isLoading =true;
                     });
                     try{
                       await saveDataFromFirebase();
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
    );
  }
}
