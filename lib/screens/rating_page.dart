



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';

class RatingPage extends StatefulWidget {
  static String id = 'rating_page';

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {


  @override
  Widget build(BuildContext context) {
    final _dialog = RatingDialog(
      initialRating: 3.0,
      // your app's name?
      title: const Text(
        'Rate Your Order',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.asset('images/black_logo.png', width: 150, height: 150,),
      submitButtonText: 'Submit',
      commentHint: 'You can Add an extra Comment',
      // onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        var prefs = await SharedPreferences.getInstance();
        print("KUUUUUKUUUUU KUKUKUKU ${prefs.getString(kOrderId)}");
        await FirebaseFirestore.instance
            .collection('orders').doc(prefs.getString(kOrderId))
            .update({
          'rating': response.rating,
          'rating_comment': response.comment,
          'hasRated': true
        }
        );
        Get.back();
      },
    );

    return RatingDialog(
      initialRating: 3.0,
      // your app's name?
      title: const Text(
        'Rate Your Order',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Lottie.asset('images/bilungo.json', width: 150, height: 150,),
      submitButtonText: 'Submit',
      commentHint: 'You can Add an extra Comment',
      // onCancelled: () => print('cancelled'),

      onSubmitted: (response) async {
        // Navigator.pop(context);
        // showDialog(context: context, builder:
        //     ( context) {
        //   return Material(
        //     color: Colors.transparent,
        //     child: Center(child: Container(
        //       height: 200,
        //       child: Column(
        //         children: [
        //           CircularProgressIndicator(
        //             // semanticsLabel: "Creating Goal Profile...",
        //           ),
        //         ],
        //       ),
        //     )),
        //   );
        // });
        var prefs = await SharedPreferences.getInstance();
        await FirebaseFirestore.instance
            .collection('orders').doc(prefs.getString(kOrderId))
            .update({
          'rating': response.rating,
          'rating_comment': response.comment,
          'hasRated': true
        }
        ).whenComplete(() => Get.back());
        // Get.back();

      },
    );
  }
  //     Container(
  //       color: Colors.white,
  //       child: _dialog);
  // }
}
