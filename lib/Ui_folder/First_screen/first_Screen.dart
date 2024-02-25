import 'package:boutique_shop/Provider_folder/screen_index_provider.dart';
import 'package:boutique_shop/Ui_folder/Account_screen/account_screen.dart';
import 'package:boutique_shop/Ui_folder/Home_screen/Home_screen.dart';
import 'package:boutique_shop/Ui_folder/SignIn_SignUp_folder/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Cart_screen/cart_screen.dart';
import '../Favorite_screen/favorite_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}
class _FirstScreenState extends State<FirstScreen> {

  List<dynamic> screens = [HomeScreen(),FavoriteScreen(),CartScreen(),
    FirebaseAuth.instance.currentUser != null ? AccountScreen(): SignInScreen()];
  @override
  Widget build(BuildContext context) {
    ScreenIndexProvider screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = screenIndexProvider.fetchCurrentScreenIndex;
    return  Scaffold(
      body: screens[currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: currentScreenIndex,
        onTap: (value) => screenIndexProvider.updateScreenIndex(value),
      ),
    );
  }
}
