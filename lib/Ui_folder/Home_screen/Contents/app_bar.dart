import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right:16,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/boutique.png",height:35,),
          const CardWidget(
              child: Icon(Icons.notifications,color: Colors.grey,)),
        ],
      ),
    );
  }
}
