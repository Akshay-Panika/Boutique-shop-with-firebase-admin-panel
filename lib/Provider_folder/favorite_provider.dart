import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final List<String> _selectedFavoriteProduct = [];
  List<String> get selectedFavoriteProduct => _selectedFavoriteProduct;


  Future<void> addToFavorites({
    required String productId,
    required String productName,
    required double productRatting,
    required String productDescription,
    required List<dynamic> productImage,
    required double oldPrice,
    required double newPrice,
    required String productType,
  }) async {
    // Add to Firestore
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('userFavorite')
          .doc(productId.toString())
          .set({
        "productId": productId, "productName": productName,
        "productRatting": productRatting,
        "productDescription": productDescription,
        "productImage": productImage, "oldPrice": oldPrice,
        "newPrice": newPrice, "productType": productType,
        // Add other fields as needed
      });
      _selectedFavoriteProduct.add(productId);
      notifyListeners();
    } else {
      //ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text("Go to log in first")));
      print("Go to log in first");
    }
  }

  Future<void> removeFromFavorites({
    required String productId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userFavorite')
        .doc(productId.toString())
        .delete();

    _selectedFavoriteProduct.remove(productId);
    notifyListeners();
  }

  void toggleFavoriteItem({
    required String productId,
    required String productName,
    required double productRatting,
    required String productDescription,
    required List<dynamic> productImage,
    required double oldPrice,
    required double newPrice,
    required String productType,
  }) {
    if (_selectedFavoriteProduct.contains(productId)) {
      removeFromFavorites(productId: productId);
    } else {
      addToFavorites(
        productId: productId,
        productName: productName,
        productRatting: productRatting,
        productDescription: productDescription,
        productImage: productImage,
        oldPrice: oldPrice,
        newPrice: newPrice,
        productType: productType,
      );
    }
  }

}

