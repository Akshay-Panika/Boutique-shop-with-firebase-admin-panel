import 'package:boutique_shop/Provider_folder/screen_index_provider.dart';
import 'package:boutique_shop/Provider_folder/signin_provider.dart';
import 'package:boutique_shop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider_folder/card_provider.dart';
import 'Provider_folder/favorite_provider.dart';
import 'Provider_folder/razorepay_provider.dart';
import 'Ui_folder/First_screen/first_Screen.dart';
import 'Provider_folder/signup_provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BoutiqueShop());
}

class BoutiqueShop extends StatelessWidget {
  const BoutiqueShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (context) => ScreenIndexProvider(),),
          ChangeNotifierProvider(create: (context) => SignUpAuthProvider(),),
          ChangeNotifierProvider(create: (context) => SignInAuthProvider(),),
          ChangeNotifierProvider(create: (context) => CartProvider(),),
          ChangeNotifierProvider(create: (context) => FavoriteProvider(),),
          ChangeNotifierProvider(create: (context) => RazorpayProvider(),),
        ],
      child: Builder(
        builder: (BuildContext context) {
          return  const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FirstScreen(),
          );
        },
      ),
    );
  }
}

