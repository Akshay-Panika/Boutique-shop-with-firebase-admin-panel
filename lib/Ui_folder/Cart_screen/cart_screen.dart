import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/round_button_Widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Provider_folder/card_provider.dart';
import '../../Provider_folder/razorepay_provider.dart';
import '../../Widgets/custom_snack_bar.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  int quantity = 1;
  //late RazorpayProvider razorpayProvider;


  @override
  Widget build(BuildContext context) {
    RazorpayProvider razorpayProvider = Provider.of<RazorpayProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    double subTotal = cartProvider.subTotal();
    double discount =5;
    int shipping = 10;
    double discountValue = (subTotal*discount)/100;
    double value = subTotal-discountValue;
    double totalPrice = value += shipping;
    if(cartProvider.getCartList.isEmpty){
      totalPrice =(cartProvider.getCartList.isEmpty)?0.0:totalPrice;
    }
    return Scaffold(
      body: SafeArea(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 15,bottom: 15),
              child: Text("Shopping Cart",style: textStyleBlack20,),
            ),


            Expanded(
                child:cartProvider.getCartList.isEmpty?const Center(child: Text("No Data",style: TextStyle(fontSize: 18),),)
                    :ListView.builder(
              physics: const BouncingScrollPhysics(),
                  itemCount:cartProvider.getCartList.length,
              itemBuilder: (context, index) {
                var data =cartProvider.cartList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Stack(
                    children: [
                      CardWidget(child:
                      Row(
                        children: [
                          ///___ Image
                          Container(height:120,width: 120,
                            margin: const EdgeInsets.only(right:10),
                            child: Image.network(data.productImage.toString(),fit: BoxFit.fill,)),

                          ///___ data
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.productName.toString(),style:titleTextStyleBlack,),

                              Row(
                                children: [
                                  Text("₹ ${data.oldPrice}",style: textStyleGrey13,),
                                  5.width,
                                  Text("₹ ${data.newPrice}",style: textStyleBlack13,),
                                ],
                              ),

                              5.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Text("( ${data.productType} )",style:textStyleBlack13,),
                                    5.width,
                                    Text("Size- ${data.productSize}",style: textStyleBlack13),
                                  ],),
                                  10.width,
                                  Row(children: [
                                    Text(data.productRatting.toString(),style: textStyleBlack13,),
                                    const Icon(Icons.star,color: Colors.amber,size: 16,)
                                  ],)
                                ],
                              ),
                              5.height,
                              Text("Total- ₹ ${data.newPrice!*data.productQuantity!}",style: const TextStyle(color: Colors.black,fontSize: 15),),

                            ],
                          )
                        ],
                      )),

                      ///___ Remove button
                      Positioned(
                          top: 0,right: 0,
                          child: IconButton(onPressed: (){
                            //deleteProductFunction();
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).
                            collection('userCart').doc(data.documentId).delete();
                          },icon: const Icon(Icons.clear,color: Colors.grey,),
                          )),

                      ///___ Count function button
                      Positioned(
                          bottom: 10,right: 10,
                          child:Row(
                            children: [
                              InkWell(onTap: (){
                                if(quantity>1){
                                  setState(() {
                                    quantity--;
                                 FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).
                                    collection('userCart').doc(data.documentId).update({
                                      "productQuantity":quantity,
                                    });
                                  });

                                }
                              },child: const Card(child: Icon(Icons.remove,color: Colors.black54,)),),
                              10.width,
                              Card(child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(data.productQuantity.toString(),style:textStyleBlack54_15),
                              )),
                              10.width,
                              InkWell(onTap: (){
                                setState(() {
                                  quantity++;
                                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).
                                  collection('userCart').doc(data.documentId).update({
                                    "productQuantity":quantity,
                                  });
                                });
                              },child: const Card(child: Icon(Icons.add,color: Colors.black54,)),),
                            ],
                          ))
                    ],
                  ),
                );
              },)),

            ///___ Bill summary
            cartProvider.getCartList.isEmpty?const Center(child: Text("",style: TextStyle(fontSize: 18),),)
            :Column(
              children: [
                ///__ Discount code text
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal:40,vertical: 5),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Enter discount code",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.black54)),
                          10.width,
                          const Text("Apply",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      15.height,
                      const RowWidget(text1: "Order Summary", text2: "",),
                      Divider(thickness: 1,color: Colors.grey.shade400,),

                      10.height,
                      RowWidget2(text1: "Subtotal [$documentLength]-", text2: "₹ ${subTotal.toString()}",),
                      10.height,
                      RowWidget2(text1: "Delivery -", text2: "₹ ${shipping.toString()}",),
                      10.height,
                      RowWidget2(text1: "Discount -", text2: "₹ ${discount.toString()}  %",),
                      10.height,
                      RowWidget2(text1: "Grand Total -", text2: "₹ ${totalPrice.toString()}",),
                      20.height,
                    ],
                  ),
                ),

                ///___ Proceed to checkout
                isLoading? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.black54,)),
                ):
                 RoundButtonWidget(text: "Proceed to pay",color: Colors.grey.shade300,//razorpayProvider.startPayment(totalPrice);
                   onTap: ()async{
                  // razorpayProvider.startPayment(totalPrice);
                   setState(() {
                     isLoading =true;
                   });
                   try{
                     List<CartItem> cartItems = cartProvider.getCartList.map((data) =>
                         CartItem(
                           documentId: data.documentId,
                           productName: data.productName,
                           productImage: data.productImage,
                           productSize: data.productSize,
                           oldPrice: data.oldPrice,
                           newPrice: data.newPrice,
                           productRatting: data.productRatting,
                           productDescription: data.productDescription,
                           productType: data.productType,
                           productQuantity: data.productQuantity,
                           productPrice: data.newPrice!*data.productQuantity!,
                         )).toList();
                    await saveOrderToFirebase(cartItems, totalPrice,).then((value) {
                      CustomSnackBar.show(context, "Your order is successful");
                    });
                   }
                   finally{
                     setState(() {
                       isLoading = false;
                     });
                   }
                   },
                 ),
                10.height,
              ],
            )
          ],
        ),
      ),
    );
  }
}


///___ models
class CartItem {
  String? documentId;String? productName;String? productImage;
  String? productSize;double? oldPrice;double? newPrice;
  double? productRatting;String? productDescription;
  String? productType;int? productQuantity; double? productPrice;

  CartItem({
    this.documentId, this.productName, this.productImage, this.oldPrice, this.newPrice,
    this.productDescription, this.productType, this.productQuantity, this.productSize,
    this.productRatting,this.productPrice
  });
}

// Function to save order data to Firebase
Future<void> saveOrderToFirebase(List<CartItem> cartItems, double totalPrice) async {
  try {
    DocumentReference orderRef = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('yourOrders').doc();

    // Create a map with order details
    Map<String, dynamic> orderData = {
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'time':  DateFormat('jms').format(DateTime.now()).toString(),
      'date':  DateFormat('yMMMd').format(DateTime.now()).toString(),
      'totalPrice': totalPrice,
      'items': cartItems.map((item) => {
        'documentId': item.documentId,
        'productName': item.productName,
        'productImage': item.productImage,
        'productSize': item.productSize,
        'oldPrice': item.oldPrice,
        'newPrice': item.newPrice,
        'productRatting': item.productRatting,
        'productDescription': item.productDescription,
        'productType': item.productType,
        'productQuantity': item.productQuantity,
        'productPrice': item.productPrice,
        // Add other item details as needed
      }).toList(),
    };

    // Set the data to the document
    await orderRef.set(orderData);

    // Clear the user's cart after the order is placed
    await clearUserCart(FirebaseAuth.instance.currentUser!.uid);
  } catch (error) {
    print('Error saving order to Firebase: $error');
  }
}

// Function to clear the user's cart after placing an order
Future<void> clearUserCart(String uid) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('userCart').get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  } catch (error) {
    print('Error clearing user cart: $error');
    // Handle the error appropriately
  }
}
