



import 'package:blendit_2022/models/responsive/responsive_layout.dart';
import 'package:blendit_2022/controllers/controller_page_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../utilities/constants.dart';

class FirebaseServerFunctions {

  // Removing Appointment from the server
  final HttpsCallable callableRevenueCatPayment = FirebaseFunctions.instance.httpsCallable(kRevenueCatPayment);

  Future <dynamic> removeAppointment(docId ){

    return FirebaseFirestore.instance
        .collection('challenges')
        .doc(docId)
        .update({
      'active':  false
    })
        .then((value) => print("Done"));
  }

  Future <dynamic> lastLoggedIn(docId ){

    return FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({
      'lastSeen':  DateTime.now()
    })
        .then((value) => print("Done"));
  }

  // This removes post favourites
  Future <dynamic> removePostFavourites(docId,postId, email ){
    print(docId);
    return FirebaseFirestore.instance
        .collection('favourites')
        .doc(docId)
        .update({
      'active':  false
    })
        .then((value) =>removeFavouritesInTab(postId, email));
  }

  Future <dynamic> updateCancellation(docId , name, phone, provider, providerPhone, reason){
    print(docId);
    return FirebaseFirestore.instance
        .collection('cancellations')
        .doc(docId).set({
      'name': name,
      'phone': phone,
      'provider': providerPhone,
      'date': DateTime.now(),
      'reason': reason,
      'id': docId,
      'cancel':  false,

    })
    //     .update({
    //   'cancel':  false
    // })
        .then((value) =>print('Done'));
  }

  // This removes favourites in Tab
  Future <dynamic> removeFavouritesInTab(postId, email){
    return FirebaseFirestore.instance
        .collection('trends')
        .doc(postId)
        .update({
      'favourites':  FieldValue.arrayRemove([email])
    })
        .then((value) => print('Favourites Updated'))
        .catchError((error) => print('Failed to update')
    );// //.update({'company':'Stokes and Sons'}
  }

  // DELETE ALL UNREPLIED MESSAGES

  Future<void> deleteUnrepliedChats() async {
    final QuerySnapshot unrepliedChats = await FirebaseFirestore.instance
        .collection('qualityControl')
        // .where('replied', isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    unrepliedChats.docs.forEach((doc) => batch.delete(doc.reference));
    await batch.commit();
  }

  Future<void> increasePointsCount(String uid, context, chatId) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentReference<Map<String, dynamic>> userDoc = usersCollection.doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await transaction.get(userDoc);

      if (snapshot.exists) {
        int currentCount = snapshot.data()!['articleCount'] ?? 0;
        int newCount = currentCount + 20;
        transaction.update(userDoc, {
          'articleCount': newCount,
          'chatPoints':  FieldValue.arrayUnion([chatId])
        }

        );
      }
    }).whenComplete(() {
      // Navigator.pop(context);
     // Navigator.pushNamed(context, ControlPage.id);
      Navigator.pushNamed(context, ResponsiveLayout.id);
     //  Navigator.push(context,
     //
     //      MaterialPageRoute(builder: (context)=> ResponsiveLayout(mobileBody: ControlPage(), desktopBody: ControlPageWeb()))
     //  );
      print("done");
    });
  }

  // UPDATE ALL FUNCTIONS IN DATABASE WITH THESE FIELDS
  Future<void> updateAllUsers() async {
    CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection('users');

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await usersCollection.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    querySnapshot.docs.forEach((doc) {
      batch.update(doc.reference, {'articleCountValues': []});
    });

    await batch.commit();
  }




}