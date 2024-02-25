import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models_folder/cart_model.dart';
import '../../Provider_folder/favorite_provider.dart';
import '../../Widgets/round_button_Widget.dart';
import '../Cart_screen/cart_screen.dart';
import 'Contents/product_colors.dart';

class DetailsScreen extends StatefulWidget {
  final String? productId;
  final List<dynamic> productImage;
  final String productName;
  final String? productDescription;
  final String? productType;
  final double productRatting;
  final double oldPrice;
  final double newPrice;
  const DetailsScreen({super.key, required this.productImage, required this.productName, required this.oldPrice, required this.newPrice, required this.productRatting, this.productDescription, this.productId, this.productType,});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  CarouselController carouselController = CarouselController();
  int activeImageIndex =0;
  int activeSizeIndex=1;
  var productSizeList =["S","M","L","XL"];

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            //___ App bar
            Container(
              color: Colors.grey.shade200,
              child: ListTile(
                leading: InkWell(onTap: () {
                  Navigator.pop(context);
                },child: const CardWidget(child: Icon(Icons.arrow_back,color: Colors.grey,)),),

                //___ Cart button
                trailing:const CardWidget(child: Icon(Icons.shopping_cart))
              ),
            ),

            Expanded(
              child: ListView(
                children: [

                  //___ Image container
                  Container(height: 450, color: Colors.grey.shade200,
                    child: PageView.builder(
                      itemCount:widget.productImage.length,
                      scrollDirection: Axis.horizontal,
                      physics:  const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                      return Padding(
                        padding:    const EdgeInsets.symmetric(horizontal:20),
                        child: ContainerWidget(
                            networkImage: NetworkImage(widget.productImage[index]))
                      );
                    },
                     onPageChanged: (int index) {
                       setState(() {
                         activeImageIndex = index;
                       });
                     },
                    ),
                  ),

                  5.height,
                  //___ Image indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:List<Widget>.generate(widget.productImage.length,
                            (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  carouselController.animateToPage(index,duration: const Duration(seconds: 1),curve: Curves.easeIn);
                                });
                              },
                              child: Container(height:6,width:activeImageIndex==index?17:10,
                                margin: const EdgeInsets.symmetric(horizontal:2),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                color:activeImageIndex==index?Colors.black54 :Colors.grey),
                              ),
                            )),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //___ Product name
                        Text(widget.productName,style:headlineTextStyleBlack),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("[350]",style: textStyleBlack13,),10.width,
                                Text(widget.productRatting.toString(),style: textStyleBlack13,),
                                const Icon(Icons.star,color: Colors.amber,size: 18,)
                              ],
                            ),
                            Row(
                              children: [
                                Text("₹ ${widget.oldPrice}",style: textStyleGrey13,),
                                5.width,
                                Text("₹ ${widget.newPrice}",style: textStyleBlack13,),
                              ],
                            ),
                          ],
                        ),
                        const Divider(thickness: 1,),

                        //___ Product color
                         Stack(
                          children: [

                            //___ Favorite button
                            Positioned(right:25,
                              child: InkWell(
                                onTap: (){
                                  favoriteProvider.toggleFavoriteItem(
                                    productId:widget.productId.toString(),
                                    productName:widget.productName,
                                    productRatting:widget.productRatting,
                                    productDescription:widget.productDescription.toString(),
                                    productImage:widget.productImage,
                                    oldPrice:widget.oldPrice,
                                    newPrice:widget.newPrice,
                                    productType:widget.productType.toString(),
                                  );
                                },
                                child:Icon(
                                  favoriteProvider.selectedFavoriteProduct.contains(widget.productId)?
                                  Icons.favorite: Icons.favorite_border,
                                  color: favoriteProvider.selectedFavoriteProduct.contains(widget.productId)?
                                  Colors.red:Colors.grey,size: 30,),
                              ),),

                            const ProductColors(),

                          ],
                        ),

                        //___ Product price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            15.height,
                            Text("Size",style: headlineTextStyleBlack,),
                            5.height,
                            SizedBox(//color: Colors.grey,
                              height: 35,
                              child: ListView.builder(
                                itemCount:productSizeList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: CardWidget( color: activeSizeIndex == index ? Colors.grey.shade400:Colors.white,
                                        child:  SizedBox(height: 30,width: 20,
                                            child: Center(child: Text(productSizeList[index],style: headlineTextStyleBlack,))),),
                                    ),

                                    onTap: () {
                                      setState(() {
                                        activeSizeIndex=index;
                                      });
                                    },
                                  );
                                },),
                            ),
                          ],
                        ),

                        15.height,
                        ///___ Description
                        Text("Description-",style: headlineTextStyleBlack,),
                        2.height,
                        Text(widget.productDescription.toString(),style: textStyleBlack13,),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            10.height,
            ///___ Round button widget
            RoundButtonWidget(
              text: "Add To Cart",
              color: Colors.grey.shade300,
              onTap: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  // Create a CartModel with product information
                  var cardModel = CartModel(
                    productSize: productSizeList[activeSizeIndex].toString(),
                    documentId: widget.productId,
                    productName: widget.productName,
                    productImage: widget.productImage[0],
                    oldPrice: widget.oldPrice,
                    newPrice: widget.newPrice,
                    productRatting: widget.productRatting,
                    productQuantity: 1,
                    productType: widget.productType,
                    productDescription: widget.productDescription,
                  ).toMap();

                  // Add the CartModel to the user's cart in Firestore
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('userCart').doc(widget.productId).set(cardModel);

                  // Navigate to the CartScreen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                } else {
                  // Display a snackbar if the user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text("Please go to log in"),
                    ),
                  );
                }
              },
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
