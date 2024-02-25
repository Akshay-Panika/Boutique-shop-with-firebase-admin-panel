import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';


class ProductSize extends StatefulWidget {
  late  int selectSizeIndex;
  final String productSizeList;
   ProductSize({super.key, required this.productSizeList, required this.selectSizeIndex});

  @override
  State<ProductSize> createState() => _ProductSizeState();
}
class _ProductSizeState extends State<ProductSize> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text("Size",style: headlineTextStyleBlack,),
        SizedBox(//color: Colors.grey,
          height: 35,
          child: ListView.builder(
            itemCount: widget.productSizeList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return  InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CardWidget( color: widget.selectSizeIndex == index ? Colors.grey.shade400:Colors.white,
                    child:  SizedBox(height: 30,width: 20,
                      child: Center(child: Text(widget.productSizeList[index],style: headlineTextStyleBlack,))),),
                ),

                onTap: () {
                  setState(() {
                    widget.selectSizeIndex=index;
                  });
                },
              );
            },),
        ),
      ],
    );
  }
}
