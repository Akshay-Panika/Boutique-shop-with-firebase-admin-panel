import 'package:boutique_shop/Admin_folder/Dashboard_screen/dashboard_screen.dart';
import 'package:boutique_shop/Ui_folder/Account_screen/update_account_screen.dart';
import 'package:boutique_shop/Ui_folder/First_screen/first_Screen.dart';
import 'package:boutique_shop/Ui_folder/Your_orders_screen/your_orders_screen.dart';
import 'package:boutique_shop/Widgets/card_widget.dart';
import 'package:boutique_shop/Widgets/round_button_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widgets/text_style_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  void logOutUser(){
    FirebaseAuth.instance.signOut().then((value) {
      return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const FirstScreen()));
    });
  }

  ///___ PhoneNumber
  final Uri _phoneNumber = Uri.parse('tel:123-456-7890');
  Future<void> phoneNumber() async {
    if (!await launchUrl(_phoneNumber)) {
      throw Exception('Could not launch $_phoneNumber');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            50.height,
            ///___ User data
            Expanded(
             flex: 1,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                   var userData = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        ///___ Image
                        Center(
                          child: SizedBox(height: 120,width: 120,
                            child: CardWidget(
                              child: CachedNetworkImage(
                                imageUrl: userData['userImage'] != null ? userData['userImage'].toString() : '',
                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(color: Colors.black54,),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.black54,),
                              ),

                            ),
                          ),
                        ),
                        20.height,

                        rowText(text: "Name-",value:userData['userName']),
                        rowText(text: "Email-",value: userData['userEmail']),
                        rowText(text: "Phone-",value:userData['userPhone'].toString()),
                        rowText(text: "Address-",value: userData['userAddress'].toString()),
                        20.height,
                        RoundButtonWidget(text: "Edit",onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              UpdateAccountScreen(userCredential:FirebaseAuth.instance.currentUser!.uid,
                                userName:userData['userName'] ,userEmail:userData['userEmail'],userMobile: userData['userPhone'].toString(),
                                userAddress:  userData['userAddress'].toString(),userImage: userData['userImage'].toString(),
                              )));
                        },),
                      ],
                    ),
                  );
                },);
              }
              else{
                return const Center(child:CircularProgressIndicator(color: Colors.grey,));
              }
                },
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  const Divider(thickness: 1,),
                  CardWidget(child: SizedBox(width: double.infinity,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Admin",style: headlineTextStyleBlack,),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashboardScreen()));
                      },
                    ),
                  )),

                  CardWidget(child: SizedBox(width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>  const YourOrderScreen()));

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Orders",style: headlineTextStyleBlack,),
                      ),
                    ),
                  )),

                  CardWidget(child: SizedBox(width: double.infinity,
                    child: InkWell(
                      onTap: phoneNumber,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Helpline",style: headlineTextStyleBlack,),
                      ),
                    ),
                  )),

                  CardWidget(child: SizedBox(width: double.infinity,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Log Out",style: headlineTextStyleBlack,),
                      ),
                      onTap: () {
                        logOutUser();
                      },
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class rowText extends StatelessWidget {
  final String? text;
  final String? value;
  const rowText({super.key, this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(text!,style: headlineTextStyleBlack,),
          15.width,
          Text(value!,style: headlineTextStyleBlack,),
        ],
      ),
    );
  }
}
