import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final Color? color;
  final NetworkImage? networkImage;
  const CardWidget({super.key, required this.child, this.color, this.networkImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: color,
      shape: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 0.5)),
     child: Padding(
       padding: const EdgeInsets.all(5),child: child,
     ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final NetworkImage networkImage;
  const ContainerWidget({super.key,  this.child, this.color, required this.networkImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
        border: Border.all(color: Colors.grey,width: 0.5),
        image: DecorationImage(image:networkImage,fit: BoxFit.fill,)
      ),
      child: child,
    );
  }
}

