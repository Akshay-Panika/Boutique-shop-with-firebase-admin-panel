import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/card_widget.dart';
import '../../../Widgets/text_style_widget.dart';

class CarouselSliderBanner extends StatefulWidget {
  const CarouselSliderBanner({super.key});

  @override
  State<CarouselSliderBanner> createState() => _CarouselSliderBannerState();
}
class _CarouselSliderBannerState extends State<CarouselSliderBanner> {

  CarouselController carouselController = CarouselController();
  int activeImageIndex =0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:FirebaseFirestore.instance.collection('carouselSlider').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return Column(
              children: [
                CarouselSlider.builder(
                    itemCount:snapshot.data!.docs.length,
                    itemBuilder: (context, index, realIndex) {
                      var data = snapshot.data!.docs[index];

                      return ContainerWidget(
                        color: Colors.grey.shade200,
                        networkImage: NetworkImage(data['bannerImage']),
                        child: Align(alignment: Alignment.bottomCenter,
                          child: CardWidget(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:25,vertical:5),
                            child: Text(data['headline'],style: textStyleBlack13,),
                          ),),),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 450,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 1.5,
                      initialPage: 2,
                      onPageChanged: (index, reason) {
                       setState(() {
                         activeImageIndex = index;
                       });
                      },
                    )
                ),
                10.height,
                ///___ Image indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:List<Widget>.generate(snapshot.data!.docs.length,
                          (index) => InkWell(
                        onTap: () {
                          setState(() {
                            carouselController.animateToPage(index,duration: const Duration(seconds: 1),curve: Curves.easeIn);
                          });
                        },
                        child: Container(height:6,width:activeImageIndex==index?17:10,
                          margin: const EdgeInsets.symmetric(horizontal:2),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                              color:activeImageIndex==index?Colors.black54 :Colors.grey),
                        ),
                      )),
                ),
              ],
            );
          }
          else{
            return const Center(child:CircularProgressIndicator(color: Colors.grey,),);
          }
        },);
  }
}
