
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utilities/constants.dart';


class CarouselPhotosWidget extends StatefulWidget {
  const CarouselPhotosWidget({
    Key? key,
    required this.urlImages, this.autoplay = false, this.height = 190
  }) : super(key: key);

  final List urlImages;


  final bool autoplay;
  final double height;


  @override
  State<CarouselPhotosWidget> createState() => _CarouselPhotosWidgetState();
}


class _CarouselPhotosWidgetState extends State<CarouselPhotosWidget> {

  @override
  var newDots = 0;
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.urlImages.length,
            options: CarouselOptions(
              autoPlay: widget.autoplay,
              autoPlayInterval: Duration(seconds: 10),
              onPageChanged: (index, reason){
                setState(()=>
                newDots = index
                );
              },
              viewportFraction: 1,
              enableInfiniteScroll: false,

              autoPlayAnimationDuration: Duration(seconds: 2),
              height: widget.height,
            ),
            itemBuilder: (context, index, readIndex){
              final urlImage = widget.urlImages[index];
              return BuildImage(urlImage, index);
            },
          ),

          Positioned(
              right: 20,
              bottom: 30,
              left: 20,
              child: Center(
                  child:
                  AnimatedSmoothIndicator(
                      effect:  JumpingDotEffect(
                          activeDotColor: kAppPinkColor,
                          dotHeight: 10,
                          dotWidth: 10,
                          dotColor: Colors.white
                      ),
                      activeIndex: newDots, count: widget.urlImages.length)
              )
          )
        ]
    )
    ;
  }
  Widget BuildImage (String urlImage, int index) => Container(
    // margin: EdgeInsets.symmetric(horizontal: 10),
    //  decoration: BoxDecoration(
    //    // color: Colors.grey,
    //      borderRadius: BorderRadius.circular(20),
    //      // image: DecorationImage(
    //      //   image:
    //      //   FadeInImage.assetNetwork(placeholder: 'images/shimmer.gif', image: urlImage,),
    //      //   NetworkImage(urlImage),
    //      //   fit: BoxFit.cover,
    //      //
    //      // ),
    //
    //  ),
    child: FadeInImage.assetNetwork(
      placeholder: 'images/loading.gif',
      image: urlImage, width: double.maxFinite,
      fit: BoxFit.cover,
    ),
  );

}