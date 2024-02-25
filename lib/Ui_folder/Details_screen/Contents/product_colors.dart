import 'package:flutter/material.dart';
import '../../../Widgets/text_style_widget.dart';

class ProductColors extends StatefulWidget {
  const ProductColors({super.key});

  @override
  State<ProductColors> createState() => _ProductColorsState();
}
class _ProductColorsState extends State<ProductColors> {
  List productColorsList =[
    Colors.red,Colors.green,Colors.blue
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        Text("Colors",style: headlineTextStyleBlack,),
        5.height,
        SizedBox(//color: Colors.grey,
          height: 20,
          child: ListView.builder(
            itemCount: productColorsList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
            return  CircleAvatar(backgroundColor: productColorsList[index],radius: 15,);
          },),
        ),
      ],
    );
  }
}
