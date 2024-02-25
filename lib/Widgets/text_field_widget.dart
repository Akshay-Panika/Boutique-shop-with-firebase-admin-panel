import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData? iconData;
  final TextEditingController? controller;
  final  Function(String)? onChanged;
  final VoidCallback? onTap;
  const TextFieldWidget({super.key, required this.hintText,  this.iconData,  this.controller, this.onChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged:onChanged ,
      onTap: onTap,
      decoration: InputDecoration(
          hintText: hintText,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 0.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 0.5)),
      ),
    );
  }
}
