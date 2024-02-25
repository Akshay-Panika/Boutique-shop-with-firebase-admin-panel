

///___ CarouselSliderModel
class ProductCategoriesModel {
  String? documentId;
  String? categoriesImage;
  String? headline;
  String? categoriesType;

  ProductCategoriesModel({
    required this.documentId,
    required this.categoriesImage,
    required this.headline,
    required this.categoriesType,

  });

  ProductCategoriesModel.fromMap(Map<String, dynamic> map) {
    documentId = map["documentId"];
    categoriesImage = map["categoriesImage"];
    headline = map["headline"];
    categoriesType = map["categoriesType"];

  }

  Map<String, dynamic> toMap() {
    return {
      "documentId": documentId,
      "categoriesImage": categoriesImage,
      "headline": headline,
      "categoriesType": categoriesType,
    };
  }
}