///___ ProductModel
class PopularProductModel{
  String? productId;
  String? productName;
  double? productRatting;
  String? productDescription;
  List<String>? productImage;
  double? oldPrice;
  double? newPrice;
  String? productType;
  PopularProductModel({
    required this.productId,
    required this.productName,
    required this.productRatting,
    required this.productDescription,
    required this.productImage,
    required this.oldPrice,
    required this.newPrice,
    required this.productType,
  });

  PopularProductModel.fromMap(Map<String, dynamic> map) {
    productId=map['productId'];
    productName = map["productName"];
    productRatting = map["productRatting"];
    productDescription = map["productDescription"];
    oldPrice= map['oldPrice'];
    newPrice= map['newPrice'];
    productType= map['productType'];
    productImage= map['productImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "oldPrice": oldPrice,
      "newPrice": newPrice,
      "productRatting": productRatting,
      "productDescription": productDescription,
      "productType": productType,
    };
  }
}