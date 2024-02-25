import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../Models_folder/cart_model.dart';
var documentLength;

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  CartModel? cartModel;

  Future<void> getCartData() async {
    List<CartModel> newCartList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userCart')
        .get();
     documentLength = querySnapshot.docs.length;

    querySnapshot.docs.forEach((element) {
      cartModel = CartModel.fromDocument(element);
      newCartList.add(cartModel!);
    });

    cartList = newCartList;
    notifyListeners();
  }

  List<CartModel> get getCartList => cartList;

  double subTotal() {
    double subTotal = 0.0;
    cartList.forEach((element) {
      subTotal += element.newPrice! * element.productQuantity!;
    });
    return subTotal;
  }
}
