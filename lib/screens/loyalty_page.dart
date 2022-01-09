
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/ingredientButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoyaltyPage extends StatefulWidget {
  static String id = 'loyaltyPage';

  @override
  _LoyaltyPageState createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage> {
  final auth = FirebaseAuth.instance;

  void defaultInitialization ()async{
    var prefs = await SharedPreferences.getInstance();

    setState(() {
     name = prefs.getString(kFullNameConstant)!;
    });

  }
  Future<dynamic> getPoints() async {
    var prefs = await SharedPreferences.getInstance();

    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .get();
    loyaltyPoints = users['loyalty'];
    setState(() {
      prefs.setInt(kLoyaltyPoints, loyaltyPoints);


    });
    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoints();
    defaultInitialization();
  }
  int loyaltyPoints = 0;
  String name = 'Joshua';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueDarkColor,
      appBar: AppBar(title: Text('Loyalty Rewards'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  child: Icon(LineIcons.trophy, size: 60,),
                ),
                SizedBox(height: 20,), 
                Text(name, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),

                Lottie.asset('images/loyalty.json',
                    height: 200),
                Text('${loyaltyPoints.round().toString()} Points', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                ingredientButtons(firstButtonFunction: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return CupertinoAlertDialog(
                      title: Text('Rewards Coming Soon', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                      content: Text('You will soon be able to use this feature to get discounts and buy other Healthy products and cool prizes. We will let you know when it is active'),
                      actions: [CupertinoDialogAction(isDestructiveAction: true,
                          onPressed: (){

                            Navigator.pop(context);
                          },
                          child: Text('Cancel', style: TextStyle(color: Colors.teal),))],
                    );
                  });

                }, firstButtonText: 'Use Points', lineIconFirstButton: LineIcons.trophy,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
