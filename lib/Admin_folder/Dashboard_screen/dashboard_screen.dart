import 'package:boutique_shop/Widgets/round_button_Widget.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:flutter/material.dart';
import '../../Widgets/card_widget.dart';
import '../ShowModalBottomSheet/show_modal_bottom_sheet.dart';
import 'Screen_view/carousel_slider_view.dart';
import 'Screen_view/categories_view.dart';
import 'Screen_view/sub_categories_view.dart';
import 'Screen_view/total_order_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,),

      body: SafeArea(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///___ Profile image
                const SizedBox(height:110,width: 110,
                  child: CardWidget(child: Center(child: Icon(Icons.person,size: 40,color: Colors.black54,),)),
                ),

                5.height,
                Text("Admin name",style: textStyleBlack20,),
                20.height,
                const RoundButtonWidget(text: "Edit Profile"),
                ],
            ),

            ///___ GridView
            Expanded(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,mainAxisSpacing: 15,crossAxisSpacing: 15,
              ),
                children: [

                  ///___ Carousel slider
                  ContainerBar(headline: "Carousel slider",iconData: Icons.add_box,onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> const CarouselSliderView()));
                  },),

                  ContainerBar(headline: "Category",iconData: Icons.add_box,onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const CategoriesView()));

                  },),

                  ContainerBar(headline: "Sub category",iconData: Icons.add_box,onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const SubCategoriesView()));

                  },),

                  ContainerBar(headline: "Total orders ",iconData: Icons.add_box,onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const TotalOrderScreen()));
                  },),

                ],
              ),
            ))
          ],
        ),
      ),
      floatingActionButton:CardWidget(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: InkWell(
          child: const Icon(Icons.add,size:35,), onTap: () {
            showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) => const ShowModalBottomSheetWidget(),);
          },),
        ),
      )
    );
  }
}

class ContainerBar extends StatelessWidget {
  final String headline;
  final IconData iconData;
  final VoidCallback onTap;
  const ContainerBar({super.key, required this.headline, required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  CardWidget(child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 35,backgroundColor: Colors.grey.shade300,child: Icon(iconData,color: Colors.black54,),),
          10.height,
          Text(headline,style: headlineTextStyleBlack,),
        ],
      ),
    ));
  }
}
