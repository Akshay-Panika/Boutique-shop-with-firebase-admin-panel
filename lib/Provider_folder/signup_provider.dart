import 'package:boutique_shop/Ui_folder/First_screen/first_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models_folder/user_model.dart';

class SignUpAuthProvider with ChangeNotifier{

  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(SignUpAuthProvider.pattern.toString());
  UserCredential? userCredential;

  bool loading = false;

  void signupValidation({
    required TextEditingController? fullName,
    required TextEditingController? emailAddress,
    required TextEditingController? password,
    required BuildContext context, }) async{

    if(fullName!.text.trim().isEmpty){
      print("Full name is empty");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Full name is empty")));
      return;
    }

    else if(!regExp.hasMatch(emailAddress!.text.trim())){
      print("Email address is empty");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email address is invalid")));
      return;
    }

    else if(password!.text.length < 8){
      print("Password is empty");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be 8")));
      return;
    }

    else{  //print("Text field is ok");
      try{
        loading = true;
        notifyListeners();
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddress.text, password: password.text);
        loading = true;
        notifyListeners();

        var  userData = UserModel(userId:userCredential!.user!.uid, userName: fullName.text, userEmail:emailAddress.text, userPassword:password.text ).toMap();
        FirebaseFirestore.instance.collection('users').doc(userCredential!.user!.uid).set(userData).then((value){
          loading = false;
          notifyListeners();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const FirstScreen()));
        });
      }
      on FirebaseAuthException catch(e){
        loading = false;
        notifyListeners();
        if(e.code=="weak-password"){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("weak-password")));
        }

       else if(e.code=="email-already-in-use"){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("email-already-in-use")));
        }

      }
    }
  }
}