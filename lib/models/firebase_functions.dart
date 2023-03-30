



import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServerFunctions {

  // Removing Appointment from the server
  Future <dynamic> removeAppointment(docId ){

    return FirebaseFirestore.instance
        .collection('challenges')
        .doc(docId)
        .update({
      'active':  false
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




}