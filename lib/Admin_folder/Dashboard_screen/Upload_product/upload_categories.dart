import 'dart:io';
import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Models_folder/product_categories_model.dart';


final List<String> productType = ['Blouse', 'Kurtas & Kurtis', 'Palazzo', 'Salwars & Patialas'];
var selectedType;

class UploadCategories extends StatefulWidget {
  const UploadCategories({super.key});

  @override
  State<UploadCategories> createState() => _UploadCategoriesState();
}
class _UploadCategoriesState extends State<UploadCategories> {

  File? pickedImage;
  bool isPicked = false;
  bool isLoading = false;
  ///___ Pic multiImages
  List<File> imagesList = [];
  final picker = ImagePicker();

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
   saveDataFromFirebase() async {
    if (selectedType != null && pickedImage != null) {
      try {
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('categories').child(const Uuid().v1()).putFile(pickedImage!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        var data = ProductCategoriesModel(documentId: selectedType, categoriesImage: downloadUrl, headline: selectedType, categoriesType: selectedType,).toMap();
        await FirebaseFirestore.instance.collection('categories').doc(selectedType).set(data).then((value) {
          Navigator.pop(context);
        });

      } catch (error) {
        print("Error uploading image or saving data: $error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields!')));
      print("Please fill all the fields!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [


          50.height,

          ///___ Select product type
            Center(
              child: DropdownButton(
                items: productType
                    .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
                ).toList(),
                onChanged: (selectedTypeValue) {
                  setState(() {
                    selectedType =selectedTypeValue;
                  });
                },
                value:selectedType,
                isExpanded: false,
                hint: const Text("Select product type"),
              ),
            ),

             20.height,
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
