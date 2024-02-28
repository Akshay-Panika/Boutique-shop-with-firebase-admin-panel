import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/card_widget.dart';

class TotalOrderScreen extends StatelessWidget {
  const TotalOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.transparent,elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: Text("Users Orders",style: textStyleBlack20,),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid).collection('yourOrders').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount:snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: CardWidget(
                    child: Stack(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data['items'].length,
                              itemBuilder: (context, index) {
                                return  Row(
                                  children: [
                                    ///___ Image
                                    Container(height:120,width: 120,
                                        margin: const EdgeInsets.only(right:10),
                                        child: Card(child: Image.network(data['items'][index]['productImage'],fit: BoxFit.fill,))),

                                    ///___ data
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        10.height,
                                        Text(data['items'][index]['productName'],style:titleTextStyleBlack,),

                                        Row(
                                          children: [
                                            Text("₹ ${data['items'][index]['oldPrice']}",style: textStyleGrey13,),
                                            5.width,
                                            Text("₹ ${data['items'][index]['newPrice']}",style: textStyleBlack13,),
                                          ],
                                        ),

                                        5.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Text("( ${data['items'][index]['productType']} )",style:textStyleBlack13,),
                                              5.width,
                                              Text("Size- ${data['items'][index]['productSize']}",style: textStyleBlack13),
                                            ],),
                                            10.width,
                                            Row(children: [
                                              Text(data['items'][index]['productRatting'].toString(),style: textStyleBlack13,),
                                              const Icon(Icons.star,color: Colors.amber,size: 16,)
                                            ],)
                                          ],
                                        ),
                                        10.height,
                                        Text("Quantity- ${data['items'][index]['productQuantity']}",style: textStyleBlack13,),
                                        Text("Price. ₹ ${data['items'][index]['productPrice']}",style: textStyleBlack13,),
                                      ],
                                    ),
                                  ],
                                );
                              },),
                            15.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Price.  ₹ ${data['totalPrice'].toString()}",style: const TextStyle(color: Colors.black,fontSize: 15),),
                                Text("${data['time']}, ${data['date']}",style: const TextStyle(color: Colors.black,fontSize: 15),),
                              ],
                            ),
                            5.height
                          ],
                        ),

                        Positioned(
                            right: 0,
                            child:CardWidget(child: InkWell(onTap: () {
                          FirebaseFirestore.instance.collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid).collection('yourOrders').doc(snapshot.data!.docs[index].id).delete();
                        },child: const Icon(Icons.clear),),))
                      ],
                    ),
                  ),
                );
              },);
          }
          else{
            return const Center(child: CircularProgressIndicator(color: Colors.grey,),);
          }
        },
      ),
    );
  }
}
