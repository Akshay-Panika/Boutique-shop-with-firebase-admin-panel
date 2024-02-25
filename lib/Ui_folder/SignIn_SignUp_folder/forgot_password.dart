import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Widgets/round_button_Widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[

            ///___ Headline text
            const Text("Welcome to\n                    "
                "Forgot password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //___ Enter password
                  TextFormField(
                    decoration:  const InputDecoration(
                      hintText: "Email address",
                      //border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        email= value.trim();
                      });
                    },
                  ),

                  //___ Send request button
                  const SizedBox(height: 20,),
                  RoundButtonWidget(text: "Send request", onTap: ()async{
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email!).whenComplete(() =>
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An email has been $email to please verify"))));
                    Navigator.pop(context);
                  },)
                ],
              ),
            ),

            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}
