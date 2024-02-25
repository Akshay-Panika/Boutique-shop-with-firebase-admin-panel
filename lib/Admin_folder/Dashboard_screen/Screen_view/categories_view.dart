import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(leading:Text("Categories",style: headlineTextStyleBlack,),),

            Expanded(child:StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data != null){
                  return GridView.builder(
                    itemCount:snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            CardWidget(
                                child: Column(
                                  children: [
                                    Expanded(child: Image.network(data['categoriesImage'],fit: BoxFit.fill,width: double.infinity,)),
                                    Text(data['headline'],style:headlineTextStyleBlack,)
                                  ],
                                )),
                            ///___ Delete function
                            Positioned(right: 0,
                              child:InkWell(
                                child: const CardWidget(child: Icon(Icons.clear,color: Colors.black54,)),
                                onTap: () {
                                  FirebaseFirestore.instance.collection('categories').doc(snapshot.data!.docs[index].id).delete();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },);
                }
                else{
                  return const Center(child:CircularProgressIndicator(color: Colors.grey,));
                }
              },
            ),),
          ],
        ),
      ),

    );
  }
}
