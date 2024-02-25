import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider_folder/favorite_provider.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_field_widget.dart';
import '../../../Widgets/text_style_widget.dart';
import '../../Details_screen/details_screen.dart';

class GridViewScreen extends StatelessWidget {
  final String headline;
  const GridViewScreen({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      body:SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///___ Headline text
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 15),
              child: Text(headline,style: textStyleBlack20,),
            ),

            ///___ Search bar
            const ListTile(
              leading: SizedBox(height: 35,width: 300,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextFieldWidget(
                      hintText: "Search here...",
                    ),
                  )),
              trailing: CardWidget(child: Icon(Icons.shopping_cart,color: Colors.grey,)),
            ),

            10.height,
            ///___ Product list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('categories').doc(headline).collection(headline.toString()).snapshots(),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsScreen(productImage:data['productImage'],
                                productName: data['productName'].toString(),productRatting:data['productRatting'],oldPrice:data['oldPrice'],newPrice: data['newPrice'],
                                productDescription: data['productDescription'],productId: data['productId'],productType: data['productType'],
                              )));
                              },
                            child: Column(
                              children: [

                                ///___ Image container
                                Expanded(child: ContainerWidget(
                                  color: Colors.grey.shade200,
                                  networkImage: NetworkImage(data['productImage'][0]),

                                  ///___ Favorite button
                                  child: Align(alignment: Alignment.topRight,
                                    child:InkWell(
                                      onTap: (){
                                        favoriteProvider.toggleFavoriteItem(
                                          productId: data['productId'],
                                          productName: data['productName'],
                                          productRatting: data['productRatting'],
                                          productDescription: data['productDescription'],
                                          productImage: data['productImage'],
                                          oldPrice: data['oldPrice'],
                                          newPrice: data['newPrice'],
                                          productType: data['productType'],
                                        );
                                      },
                                      child:Icon(
                                        favoriteProvider.selectedFavoriteProduct.contains(data['productId'])?
                                        Icons.favorite: Icons.favorite_border,
                                        color:favoriteProvider.selectedFavoriteProduct.contains(data['productId'])?
                                        Colors.red:Colors.grey,),
                                    ) ,
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
                                              Text(data['productRatting'].toString(),style: textStyleBlack13,),const Icon(Icons.star,color: Colors.amber,size: 20,)
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
                    return const Center(child:CircularProgressIndicator(color: Colors.grey,),);
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
