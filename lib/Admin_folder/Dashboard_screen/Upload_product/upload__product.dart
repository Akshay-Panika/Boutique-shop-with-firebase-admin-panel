import 'dart:io';
import 'package:boutique_shop/Admin_folder/Dashboard_screen/Upload_product/upload_categories.dart';
import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Models_folder/popular_product_models.dart';
import '../../../Widgets/text_field_widget.dart';
var subCategoriesId;
class UploadProduct extends StatefulWidget {
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {

  TextEditingController nameController =TextEditingController();
  TextEditingController oldPriceController =TextEditingController();
  TextEditingController newPriceController =TextEditingController();
  TextEditingController rattingController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();


  bool isLoading = false;
  File? pickedImage;
  bool isPicked = false;
  ///___ Pic multiImages
  List<File> imagesList = [];
  final picker = ImagePicker();

  ///___ Pic image from gallery
  void picMultiImageFromGallery() async {
    final pickedFile = await picker.pickMultiImage();
    if (pickedFile != null) {
      List<XFile> filePick = pickedFile;
      if (filePick.isNotEmpty) {
        for (var i = 0; i < filePick.length; i++) {
          imagesList.add(File(filePick[i].path));
          print(File(filePick[i].path));
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing is selected')));
      }
    } else {
      print("No images picked");
    }
  }

  ///___ saveDataFromFirebase
   saveDataFromFirebase()async{
    String productName = nameController.text.trim();
    double oldPrice = double.parse(oldPriceController.text.trim());
    double newPrice = double.parse(newPriceController.text.trim());
    double  productRatting= double.parse(rattingController.text.trim());
    String productDescription = descriptionController.text.trim();
    if(productName != "" && oldPrice != "" && newPrice != "" && productRatting != "" && productDescription != "" && imagesList != null ){
      // loop
      List<String> imageUrl = [];
      for (var index = 0; index < imagesList.length; index++) {
        var element = imagesList[index];
        // Upload image in firebaseStorage
        try {
          UploadTask uploadTask = FirebaseStorage.instance.ref().child("categories").child(element.path).putFile(element);
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          imageUrl.add(downloadUrl);
        } catch (e) {
          print("Error uploading image $index: $e");
        }
      }
      // Upload image in firebaseFirestore
      try { // Product model
        var userData = PopularProductModel(productId:const Uuid().v1(),productImage: imageUrl,productName: productName, oldPrice: oldPrice,
            newPrice: newPrice,productRatting: productRatting,productType: selectedType,productDescription:productDescription,).toMap();
        // Add product in firebase with product model
        await  FirebaseFirestore.instance.collection('categories').doc(selectedType).collection(selectedType).add(userData).then((DocumentReference docId){
          FirebaseFirestore.instance.collection('subCategories').doc(docId.id).set(userData).then((value) {
            subCategoriesId=docId.id;
            Navigator.pop(context);
          });
        });
      } catch (e) {
        print("Error saving data from firebase: $e");
      }
    }
    else{
      print("Please fill all the fields!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields!')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            50.height,

            /// Categories type
            DropdownButton(
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
            ///___ Text field
            TextFieldWidget(hintText: "Product name", controller: nameController),
            TextFieldWidget(hintText: "Product old price", controller: oldPriceController),
            TextFieldWidget(hintText: "Product new price", controller: newPriceController),
            TextFieldWidget(hintText: "Product ratting", controller: rattingController),
            TextFieldWidget(hintText: "Product description", controller: descriptionController),

            30.height,
            SizedBox(height: 200,
              child: imagesList.isEmpty // If no images is selected
                  ?  CardWidget(
                  color: Colors.grey.shade100,
                  child:  const Center(child: Text("Image collection is empty",),))
                  : Expanded(
                    child: GridView.builder(
                itemCount: imagesList.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5
                ),
                itemBuilder: (BuildContext context, int index) {
                    return CardWidget(child: Image.file(imagesList[index],fit: BoxFit.fill,));
                },
              ),
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
                            child: Center(child: Text("Upload image",style: TextStyle(fontSize:15,color: Colors.white),)),
                          )),
                      onTap: () {
                        picMultiImageFromGallery();
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
      ),
    );
  }
}
