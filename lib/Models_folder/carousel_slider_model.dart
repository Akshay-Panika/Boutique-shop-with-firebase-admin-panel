


///___ CarouselSliderModel
class CarouselSliderModel {
  String? documentId;
  String? bannerImage;
  String? headline;

  CarouselSliderModel({
    required this.documentId,
    required this.bannerImage,
    required this.headline,

  });

  CarouselSliderModel.fromMap(Map<String, dynamic> map) {
    documentId = map["documentId"];
    bannerImage = map["bannerImage"];
    headline = map["headline"];

  }

  Map<String, dynamic> toMap() {
    return {
      "documentId": documentId,
      "bannerImage": bannerImage,
      "headline": headline,

    };
  }
}