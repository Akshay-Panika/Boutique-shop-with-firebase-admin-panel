import 'package:boutique_shop/Ui_folder/Favorite_screen/favorite_screen.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../Widgets/card_widget.dart';
import '../../Widgets/text_field_widget.dart';
import 'Contents/app_bar.dart';
import 'Contents/best_sell_product.dart';
import 'Contents/carousel_slider.dart';
import 'Contents/home_search_product.dart';
import 'Contents/popular_product.dart';
import 'Contents/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> stream;
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection('subCategories').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              ///___ App bar
              const MyAppBar(),

              StickyHeader(
                  ///___ Search bar
                  header: Container(color: Colors.white,
                    child: ListTile(
                      leading:  SizedBox(height: 35,width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFieldWidget(
                              hintText: "Search here...",
                              controller: _searchController,
                              onChanged: (value) {
                               isSearch =! isSearch;
                                setState(() {
                                  stream = FirebaseFirestore.instance.collection('subCategories')
                                      .where('productName', isGreaterThanOrEqualTo: value).snapshots();
                                });
                              },
                            ),
                          )),
                      trailing: InkWell(child: const CardWidget(child: Icon(Icons.favorite,color: Colors.grey,)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavoriteScreen()));
                      },),
                    ),
                  ),

                  ///___ Content list
                  content:isSearch != false ?SearchResultsList(stream: stream,) :Column(
                    children: [
                      10.height,
                      ///___ Carousel_slider
                      const CarouselSliderBanner(),

                      20.height,
                      ///___ Category _slider
                      const Categories(),

                      ///___ Popular product list
                       const PopularProduct(),


                      10.height,
                      //const Divider(thickness: 0.5,),
                      ///___ Best sell product list
                      const BestSellProduct(),

                      10.height,
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
