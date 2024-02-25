import 'package:boutique_shop/Ui_folder/First_screen/first_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInAuthProvider with ChangeNotifier{

  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(SignInAuthProvider.pattern.toString());
  UserCredential? userCredential;
  bool loading = false;

  void signInValidation({
    required TextEditingController? emailAddress,
    required TextEditingController? password,
    required BuildContext context, }) async{

    if (emailAddress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email address is empty"),));
      return;
    }
    else if(!regExp.hasMatch(emailAddress!.text.trim())){
      print("Invalid email address");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid email address")));
      return;
    }
    else if (password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password is empty"),),);
      return;
    }
    else if(password!.text.length < 8){
      print("Password must be 8");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be 8")));
      return;
    }

    else{
        try{
          loading = true;
          notifyListeners();

          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailAddress.text,
              password: password.text
          ).then((value)async{
            loading = false;
            notifyListeners();
            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const FirstScreen()));
          });

        }on FirebaseAuthException catch(e){
          loading = false;
          notifyListeners();
          if(e.code=="user-not-found"){
            print("user-not-found");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("user-not-found")));
          }

          else if(e.code=="wrong-password"){
            print("wrong-password");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("wrong-password")));
          }
        }
    }
  }
}