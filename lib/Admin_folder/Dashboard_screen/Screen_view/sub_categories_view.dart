import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';

class SubCategoriesView extends StatefulWidget {
  const SubCategoriesView({super.key});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(leading:Text("Product",style: headlineTextStyleBlack,),),

            Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('subCategories').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data != null){
                  return Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      itemCount:snapshot.data!.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2/2.8,
                          crossAxisSpacing:5,
                          mainAxisSpacing: 11
                      ),
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Stack(
                          children: [
                            CardWidget(
                                child: Column(
                                  children: [
                                    Expanded(child: Image.network(data['productImage'][0],fit: BoxFit.fill,width: double.infinity,)),
                                    ///___ Text data
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2,vertical:5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text(data['productName'].toString(),style: headlineTextStyleBlack,overflow:TextOverflow.ellipsis)),
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
                                              Text("₹ ${data['oldPrice']}",style: textStyleGrey13,),
                                              5.width,
                                              Text("₹ ${data['newPrice']}",style: textStyleBlack13,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            ///___ Delete function
                            Positioned(right: 0,
                              child:InkWell(
                                child: const CardWidget(child: Icon(Icons.clear,color: Colors.black54,)),
                                onTap: () {
                                  FirebaseFirestore.instance.collection('subCategories').doc(snapshot.data!.docs[index].id).delete();
                                },
                              ),
                            ),
                          ],
                        );
                      },),
                  );
                }
                else{
                  return const Center(child:CircularProgressIndicator(color: Colors.grey,));
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
