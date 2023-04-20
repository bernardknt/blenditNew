// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:flutter/material.dart';
//
// class CustomFirebaseInAppMessaging {
//   static void configureInAppMessaging() {
//     // Set up background message handler
//     FirebaseInAppMessaging.instance.setBackgroundMessageHandler(
//           (InAppMessagingAction action) async {
//         // Handle background message, e.g. show a notification
//         print('Received background message: ${action.actionType}');
//         return;
//       },
//     );
//
//     // Enable or disable in-app messages
//     FirebaseInAppMessaging.instance.setMessagesSuppressed(false); // Set to true to disable in-app messages
//
//     // Customize the appearance of in-app messages
//     FirebaseInAppMessaging.instance.setMessageDisplayComponent(
//           (InAppMessagingDisplay display) {
//         // Create a custom widget for in-app messages
//         return Container(
//           // Customize the appearance of the in-app message
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 display.message.title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 display.message.body,
//                 style: TextStyle(fontSize: 14.0),
//               ),
//               SizedBox(height: 8.0),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle button click
//                   display.dismiss();
//                 },
//                 child: Text(
//                   'Dismiss',
//                   style: TextStyle(fontSize: 14.0),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
