
import 'package:flutter/material.dart';

TextStyle textStyleBlack20 = const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,);
TextStyle textStyleBlack54_15 = const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,);
TextStyle headlineTextStyleBlack = const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,);
TextStyle titleTextStyleBlack = const TextStyle(color: Colors.black,fontSize:13,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,);
TextStyle textStyleGrey13 = const TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w400,decoration: TextDecoration.lineThrough,overflow: TextOverflow.ellipsis,);
TextStyle textStyleBlack13 = const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,);


extension SizeBox on num{
  SizedBox get height => SizedBox(height: toDouble(),);
  SizedBox get width => SizedBox(width: toDouble(),);
}


class RowWidget extends StatelessWidget {
  final String text1;
  final String text2;
  const RowWidget({super.key, required this.text1,  required this.text2,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1,style: headlineTextStyleBlack,),
        Text(text2,style: headlineTextStyleBlack,),
      ],
    );
  }
}
class RowWidget2 extends StatelessWidget {
  final String text1;
  final String text2;
  const RowWidget2({super.key,  required this.text1, required this.text2,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1,style: titleTextStyleBlack,),
        Text(text2,style: titleTextStyleBlack,),
      ],
    );
  }
}
