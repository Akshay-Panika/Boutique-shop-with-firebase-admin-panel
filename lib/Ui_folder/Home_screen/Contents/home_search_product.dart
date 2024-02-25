import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider_folder/favorite_provider.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';
import '../../Details_screen/details_screen.dart';

class SearchResultsList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  const SearchResultsList({Key? key, required this.stream,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return SizedBox(height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: stream,
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
            return const Center(child:Text("No data"),);
          }
        },
      ),);
  }
}