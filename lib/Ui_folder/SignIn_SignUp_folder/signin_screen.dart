import 'package:boutique_shop/Ui_folder/SignIn_SignUp_folder/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider_folder/signin_provider.dart';
import '../../Widgets/round_button_Widget.dart';
import '../../Widgets/text_style_widget.dart';
import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {

  bool visibility = true;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    SignInAuthProvider signInAuthProvider = Provider.of<SignInAuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.height,
              ///___ Headline text
              const Text("Welcome to\n                    "
                  "Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),


              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///___ Text field
                    Column(
                      children: [
                        TextFormField(controller: emailAddress,decoration: const InputDecoration(hintText: "Email address",
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        ),),
                        TextFormField(controller: password,decoration:  InputDecoration(hintText: "Password",
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                visibility =! visibility;
                              });
                            },
                            child: Icon(visibility?Icons.visibility_off:Icons.visibility,))),
                          obscureText: visibility,
                        ),

                        Align(alignment: Alignment.topRight,
                          child: TextButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPassword()));
                          }, child: const Text("Forgot password",style: TextStyle(color: Colors.black54),)),
                        )
                      ],
                    ),

                    ///___ Sign up button
                    Column(
                      children: [

                        ///___ Sign In
                       signInAuthProvider.loading==false? RoundButtonWidget(text: 'Sign In',onTap: () {
                         signInAuthProvider.signInValidation(emailAddress: emailAddress, password: password, context: context);
                        }):const Center(child: CircularProgressIndicator(color: Colors.black54,),),

                        ///___ Don't have a account
                       20.height,
                        InkWell(
                          child: Text("Don't have a account- Sign Up",style:textStyleBlack13),
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
