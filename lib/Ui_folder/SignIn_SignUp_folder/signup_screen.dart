import 'package:boutique_shop/Ui_folder/SignIn_SignUp_folder/signin_screen.dart';
import 'package:boutique_shop/Widgets/text_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/round_button_Widget.dart';
import '../../Provider_folder/signup_provider.dart';
var userPassword;
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  
  bool visibility = true;
  TextEditingController fullName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    SignUpAuthProvider signUpAuthProvider = Provider.of<SignUpAuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             40.height,
              ///___ Headline text
              Text("Welcome to\n                   "
                  "Sign Up",style: textStyleBlack20),


              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    ///___ Text field
                    Column(
                      children: [
                        TextFormField(controller: fullName,decoration: const InputDecoration(hintText: "Full name",
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        )),
                        TextFormField(controller: emailAddress,decoration: const InputDecoration(hintText: "Email address",
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        ),),
                        TextFormField(controller: password,decoration:  InputDecoration(hintText: "Password",
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: InkWell(
                            onTap: () {
                              userPassword = password.toString();
                              setState(() {
                                visibility =! visibility;
                              });
                            },
                            child: Icon(visibility?Icons.visibility_off:Icons.visibility,))),
                          obscureText: visibility,
                        ),
                      ],
                    ),

                    ///___ Sign up button
                    Column(
                      children: [
                      signUpAuthProvider.loading==false? RoundButtonWidget(text: 'Sign Up',onTap: () {
                          signUpAuthProvider.signupValidation(fullName: fullName,
                              emailAddress: emailAddress, password: password, context: context);
                        },):
                        const Center(child: CircularProgressIndicator(color: Colors.grey,),),

                        20.height,
                        ///___ Already i have a account
                        InkWell(
                          child: Text("Already i have a account- Sign In",style: textStyleBlack13),
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));
                          },
                        ),
                      ],
                    )
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
