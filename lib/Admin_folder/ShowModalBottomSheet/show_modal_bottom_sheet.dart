import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:flutter/material.dart';
import '../Dashboard_screen/Upload_product/upload__product.dart';
import '../Dashboard_screen/Upload_product/upload_carousel_slider.dart';
import '../Dashboard_screen/Upload_product/upload_categories.dart';



class ShowModalBottomSheetWidget extends StatefulWidget {
  const ShowModalBottomSheetWidget({super.key});

  @override
  State<ShowModalBottomSheetWidget> createState() => _ShowModalBottomSheetWidgetState();
}

class _ShowModalBottomSheetWidgetState extends State<ShowModalBottomSheetWidget> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children: [
        30.height,
        TabBar(
            indicatorColor: Colors.black54,controller: _tabController,
            tabs: [
            Tab(child: Text("CarouselSlider",style: headlineTextStyleBlack)),
            Tab(child: Text("Categories",style: headlineTextStyleBlack)),
            Tab(child: Text("Products",style: headlineTextStyleBlack)),
        ]),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ///___ Upload CarouselSlider
              UploadCarouselSlider(),

              ///___ Upload Categories
              UploadCategories(),

              ///___ Upload Product
              UploadProduct(),


            ],
          ),
        )
      ],
    ));
  }
}
