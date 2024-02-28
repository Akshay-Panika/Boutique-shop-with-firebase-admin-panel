import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider_folder/favorite_provider.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';
import '../../Details_screen/details_screen.dart';

class PopularProduct extends StatefulWidget {

   const PopularProduct({super.key,});

  @override
  State<PopularProduct> createState() => _PopularProductState();
}
class _PopularProductState extends State<PopularProduct> {
  @override
  Widget build(BuildContext context) {

    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        15.height,
         ///___ Headline text
         const Padding(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
         child:RowWidget(text1: "Popular Products", text2: "View All"),
        ),

        ///___ Popular products list
        SizedBox(height:260,//color: Colors.grey,
          child:StreamBuilder(
            stream: FirebaseFirestore.instance.collection('subCategories').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null){
                return GridView.builder(
                  itemCount:snapshot.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2.9/2,
                    // crossAxisSpacing: 10,//mainAxisSpacing: 10
                  ),
                  itemBuilder: (context, index) {
                    var data= snapshot.data!.docs[index];
                    return   Padding(
                      padding:  const EdgeInsets.only(left:10),

                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsScreen(productId: data['productId'],
                            productImage:data['productImage'], productName:data['productName'],productRatting:data['productRatting'],
                            oldPrice: data['oldPrice'],newPrice:data['newPrice'],productType:data['productType'],
                            productDescription: data['productDescription'],
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
                                    Colors.red:Colors.grey,),                                ) ,
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
                                      Expanded(child: Text(data['productName'],style: titleTextStyleBlack,overflow:TextOverflow.ellipsis)),
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
                                      Text("₹ ${data['oldPrice']}",style: textStyleGrey13,),
                                      5.width,
                                      Text("₹ ${data['newPrice']}",style: textStyleBlack13,),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },);
              }
              return const Center();
            },
          ),
        ),
      ],
    );
  }
}
