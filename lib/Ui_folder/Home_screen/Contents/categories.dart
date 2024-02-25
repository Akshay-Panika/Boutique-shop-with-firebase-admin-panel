import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';
import 'grid_view.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width:500,height: 50,
      child:StreamBuilder(
        stream:FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return  ListView.builder(
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return    InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  GridViewScreen(headline:data['headline'].toString() ,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CardWidget(
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: data['categoriesImage'],
                            placeholder: (context, url) => const Text(''),
                            errorWidget: (context, url, error) => const Icon(Icons.image,color: Colors.black54,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(data['headline'].toString()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else{
            return const Center();
          }
        },
      ),
    );
  }
}
