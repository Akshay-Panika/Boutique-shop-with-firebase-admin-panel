
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel{
   String? documentId;
   String? productName;
   String? productImage;
   String? productSize;
   double? oldPrice;
   double? newPrice;
   double? productRatting;
   String? productDescription;
   String? productType;
   int? productQuantity;

  CartModel({
     this.documentId, this.productName, this.productImage,this.oldPrice, this.newPrice, this.productRatting,
    this.productDescription, this.productType, this.productQuantity,this.productSize
  });


  CartModel.fromDocument(QueryDocumentSnapshot map) {
    documentId = map["documentId"];
    productName = map["productName"];
    productImage = map["productImage"];
    oldPrice = map["oldPrice"];
    newPrice = map["newPrice"];
    productRatting = map["productRatting"];
    productDescription = map["productDescription"];
    productType = map["productType"];
    productQuantity = map["productQuantity"];
    productSize = map["productSize"];
  }
   Map<String, dynamic> toMap() {
     return {
       "documentId": documentId,
       "productName": productName,
       "productImage": productImage,
       "oldPrice": oldPrice,
       "newPrice": newPrice,
       "productRatting": productRatting,
       "productDescription": productDescription,
       "productType": productType,
       "productQuantity": productQuantity,
       "productSize": productSize,
     };
   }
}