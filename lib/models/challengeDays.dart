


import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeDays {
  ChallengeDays({required this.day, required this.timestamp, required this.activity});
  Timestamp timestamp;
  String day;
  String activity; 
// List answers;

}