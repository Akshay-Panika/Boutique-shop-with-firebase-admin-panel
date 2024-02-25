import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:flutter/material.dart';
import 'card_widget.dart';

class RoundButtonWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback? onTap;
  const RoundButtonWidget({super.key, required this.text, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: InkWell(
        onTap: onTap,
        child: CardWidget(
            color: color,
            child: SizedBox(
                width: double.infinity,height: 30,
                child: Center(child: Text(text,style: headlineTextStyleBlack,)))),
      ),
    );
  }
}

List imageList = [
  'https://moioutfit.com/cdn/shop/files/81564-23098.jpg?v=1694942921&width=1500',
  'https://moioutfit.com/cdn/shop/files/81564-23098.jpg?v=1694942921&width=1500',
  'https://moioutfit.com/cdn/shop/files/81564-23098.jpg?v=1694942921&width=1500',
  'https://moioutfit.com/cdn/shop/files/81564-23098.jpg?v=1694942921&width=1500',
];
