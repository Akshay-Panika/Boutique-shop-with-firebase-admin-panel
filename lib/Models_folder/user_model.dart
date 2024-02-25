
///___ CarouselSliderModel
class UserModel {
  String? userId;
  String? userImage;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userAddress;

  UserModel({
    this.userId,
    this.userImage,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhone,
    this.userAddress,

  });

  UserModel.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    userImage = map["userImage"];
    userName = map["userName"];
    userEmail = map["userEmail"];
    userPassword = map["userPassword"];
    userPhone = map["userPhone"];
    userAddress = map["userAddress"];
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userImage": userImage,
      "userName": userName,
      "userEmail": userEmail,
      "userPassword": userPassword,
      "userPhone": userPhone,
      "userAddress": userAddress,
    };
  }
}