
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_field_widget.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,
      child: const ListTile(
        leading: SizedBox(height: 50,width: 320,
            child: TextFieldWidget(
              hintText: "Search here",iconData: Icons.search,
            )),
        trailing: CardWidget(child: Icon(Icons.image)),
      ),
    );
  }
}
