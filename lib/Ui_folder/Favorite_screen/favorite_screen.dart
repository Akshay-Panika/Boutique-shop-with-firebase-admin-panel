import 'package:boutique_shop/Widgets/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider_folder/favorite_provider.dart';
import '../../Widgets/card_widget.dart';
import '../../Widgets/text_style_widget.dart';
import '../Details_screen/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  //late Stream<QuerySnapshot> _stream;
  late Stream<QuerySnapshot> _stream = const Stream.empty();
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      _stream = FirebaseFirestore.instance.collection('users').doc(user.uid).
      collection('userFavorite').snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      body:SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///___ Headline text
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 15),
              child: Text("Favorite product",style: textStyleBlack20,),
            ),

            ///___ Search bar
             ListTile(
              leading: SizedBox(height: 35,width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFieldWidget(
                      hintText: "Search here...",
                      controller:_searchController,
                      onChanged: (value) {
                        setState(() {
                          _stream = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('userFavorite').where('productName', isGreaterThanOrEqualTo: value).snapshots();
                        });
                      },
                    ),
                  )),
              trailing: const CardWidget(
                  child: Icon(Icons.shopping_cart,color: Colors.grey,)),
            ),

            10.height,
            ///___ Product list

            Expanded(
              child:StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if(snapshot.hasData && snapshot.data != null){
                    return Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                        itemCount:snapshot.data!.docs.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2/3.1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15
                        ),
                        itemBuilder: (context, index) {

                          var data = snapshot.data!.docs[index];
                          ///___ OnTap function
                          return   InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsScreen( productType: data['productType'],
                                productName: data['productName'].toString(),productRatting:data['productRatting'],oldPrice:data['oldPrice'],
                                newPrice: data['newPrice'], productDescription: data['productDescription'],productId: data['productId'],
                                productImage:data['productImage'],
                              )));
                            },
                            child: Column(
                              children: [

                                ///___ Image container
                                Expanded(child: ContainerWidget(
                                  color: Colors.grey.shade200,
                                  networkImage: NetworkImage(data['productImage'][0]),
                                  child:  Align(alignment: Alignment.topRight,

                                    ///___ Favorite button
                                    child: InkWell(
                                        onTap: () {
                                          favoriteProvider.removeFromFavorites(productId:data['productId'] );
                                        },
                                        child: const Icon(Icons.favorite,size: 25,
                                          color: Colors.red,)),
                                  ),
                                )),


                                ///___ Text data
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2,vertical:5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(data['productName'].toString(),style: titleTextStyleBlack,overflow:TextOverflow.ellipsis)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(data['productRatting'].toString(),style: textStyleBlack13,),
                                              const Icon(Icons.star,color: Colors.amber,size: 20,)
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("₹ ${data['oldPrice'].toString()}",style: textStyleGrey13,),
                                          5.width,
                                          Text("₹ ${data['newPrice'].toString()}",style: textStyleBlack13,),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },),
                    );
                  }
                  else{
                    return const Center(child:Text("No data",style: TextStyle(fontSize: 18)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
