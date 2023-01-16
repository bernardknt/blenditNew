
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:blendit_2022/widgets/show_summary_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'allProducts_page.dart';
import 'checkout_page.dart';
import 'choose_juice_page.dart';
import 'detox_juice.dart';
import 'detox_plans.dart';
import 'loyalty_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageAchieved extends StatefulWidget {
  static String id = 'home_page_achieved';



  @override

  _HomePageAchievedState createState() => _HomePageAchievedState();
}

class _HomePageAchievedState extends State<HomePageAchieved> {

  var images = ['https://bit.ly/37a6mWG', 'https://bit.ly/3hAKtpr', 'https://bit.ly/3wL1NMN', 'https://bit.ly/36vfVyS'];
  var colours = [Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent];
  var items = ['Spinach Wrap', 'Chicken Egg Salad','Chai seeds', 'Fish Salad'];
  var descList = ['A perfect detox cleanse with Spinach, Collard green, Bitter gourd and Cactus', 'A chicken salad marinated with vinaigrette dressing, lettuce, eggs and rich french beans', 'Despite their small size, chia seeds are full of important nutrients. They are an excellent source of omega-3 fatty acids', 'Detox is perfect'];
  var prices = [12000, 18000, 24000, 15000];
  var categories = ['🍵 Juices & Smoothies','🍏Detox Plans', '🥗 Salads']; //, 🍹Tropical Juices'
  var pages = [DetoxJuicePage.id, DetoxPlansPage.id, SaladsPage.id ]; // , TropicalPage.id
  String name = 'Bernard';
  var formatter = NumberFormat('#,###,000');
  final numbers = List.generate(100, (index) => '$index');
  final controller = ScrollController();

  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFirstNameConstant) ?? 'Hi';

    setState(() {
      name = newName;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  @override
  Widget build(BuildContext context) {
    var blendedData = Provider.of<BlenditData>(context);
    return
      Scaffold(
        backgroundColor: kBackgroundGreyColor,
        // kBlueDarkColor,
        //Color(0xFF0c1206),
        // appBar: AppBar(
        //
        //   backgroundColor: Colors.transparent,
        //  // foregroundColor: Colors.blue,
        //
        //   brightness: Brightness.light,
        //   elevation:8 ,
        //   actions: [
        //     Stack(children: [
        //       Positioned(
        //         top: 4,
        //         right: 2,
        //         child: CircleAvatar(radius: 10,
        //             child: Text(
        //               '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
        //       ) ,
        //       IconButton
        //         (onPressed: (){
        //           if (blendedData.basketNumber == 0) {
        //
        //           }else {
        //             Navigator.pushNamed(context, CheckoutPage.id);
        //           }
        //       },
        //           icon: Icon(LineIcons.shoppingBasket),),
        //     ]
        //     )
        //   ],
        //   title: Text(""),
        //   centerTitle: true,
        //   leading:Transform.translate(offset: const Offset(20*0.5, 0),
        //    child: IconButton(
        //      icon: Image.asset('images/blender_component.png'),
        //      onPressed: () {
        //        Navigator.pushNamed(context, LoyaltyPage.id);
        //      },
        //    ),
        //   ),
        // ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('$name, commit \nand Challenge Yourself', textAlign:TextAlign.start , style: kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 20),),
                      Lottie.asset('images/workout3.json', height: 70, width: 100, fit: BoxFit.cover,),
                    ],
                  ),
                  kLargeHeightSpacing,
                  kLargeHeightSpacing,
                  // searchBar(),
                  // Row(
                  //   children: [
                  //     Padding(padding: const EdgeInsets.only(top: 20, ),
                  //     child:
                  //     GestureDetector(
                  //       onTap: (){},
                  //       child:
                  //       Container(
                  //         height: 35,
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.white
                  //         ),
                  //         padding: EdgeInsets.symmetric(horizontal: 8),
                  //         margin: EdgeInsets.only(right: 10),
                  //         child: Row(
                  //           children: [
                  //             Image.asset('images/blend.jpeg')
                  //           ],
                  //         ),
                  //
                  //       ),
                  //     ),
                  //     ),
                  //     Expanded(
                  //         child: Categories(categoriesNumber: categories.length, categories: categories, pageName: pages,))
                  //   ],
                  // ),
                  Stack(
                    children: [

                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: kGreenThemeColor,
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      Positioned(
                        right: -45,
                        top: -40,
                        child: Container(

                          padding: EdgeInsets.all( 30),
                          decoration: BoxDecoration(
                            // color: kAppPinkColor,
                              shape: BoxShape.circle,
                              border: Border.all(width: 18, color: kBabyPinkThemeColor)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap:(){

                                    CoolAlert.show(
                                        lottieAsset: 'images/workout2.json',
                                        context: context,
                                        type: CoolAlertType.custom,
                                        // title: "Enter option",
                                        widget: Column(
                                          children: [
                                            Text('You 1 have active workout', style: kNormalTextStyle,),
                                            //Text('Your appointment with ${Provider.of<BeauticianData>(context, listen: false).appointmentsToday.join(",")} is today', style: kNormalTextStyle,),
                                            kLargeHeightSpacing,


                                          ],
                                        ),
                                        confirmBtnText: 'Yes',
                                        confirmBtnColor: kBlueDarkColorOld,
                                        cancelBtnText: 'Cancel',
                                        showCancelBtn: true,
                                        backgroundColor: kPureWhiteColor,

                                        onConfirmBtnTap: (){
                                          // print(Provider.of<BeauticianData>(context, listen: false).appointmentsToday);

                                          Navigator.pop(context);

                                        }
                                    );




                                  },
                                  child: CircleAvatar(
                                    maxRadius: 25,
                                    backgroundColor: kBabyPinkThemeColor,
                                    child: Lottie.asset('images/workout2.json', height: 30, fit: BoxFit.cover,),
                                  ),
                                ),
                                kSmallHeightSpacing,
                                Text('1', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 13),),
                                kSmallHeightSpacing,
                                Text('Active Challenges', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)

                              ],
                            ),

                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    // Navigator.pushNamed(context, TrendsPage.id);
                                    Get.snackbar('Coming Soon', 'This feature is coming soon',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: kAppPinkColor,
                                        colorText: kPureWhiteColor,
                                        margin: EdgeInsets.all(10),
                                        borderRadius: 10,
                                        icon: Icon(Icons.info_outline, color: kPureWhiteColor,),
                                        duration: Duration(seconds: 3)
                                    );
                                  },
                                  child: CircleAvatar(
                                    maxRadius: 25,
                                    backgroundColor: kBabyPinkThemeColor,
                                    child: Icon(Icons.family_restroom_outlined, color: kBlack, size: 20,),
                                  ),
                                ),

                                kSmallHeightSpacing,
                                Text(' ', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 15),),
                                kSmallHeightSpacing,
                                Text('Community', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)

                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                  kLargeHeightSpacing,
                  Text("Pick a Challenge", style: kHeading2TextStyleBold.copyWith(color: kBlack, fontSize: 18)),
                  kLargeHeightSpacing,
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('items')
                          .where('promote', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.black,
                          );
                        } else {
                          items=[];
                          descList = [];
                          images = [];
                          prices = [];

                          var events = snapshot.data!.docs;
                          for (var event in events) {
                            descList.add(event.get('description'));
                            items.add(event.get('name'));
                            images.add(event.get('image'));
                            prices.add(event.get('price'));
                          }
                        }
                        return

                          StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              itemCount: items.length,
                              crossAxisSpacing: 10,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {

                                    // showSummaryDialog(
                                    //     context, images[index], items[index],
                                    //     descList[index], prices[index]);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 3,
                                        right: 0,
                                        left: 0,
                                        bottom: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // color: colours[index],
                                    ),
                                    child:
                                    Column(
                                      children: [
                                        Column(

                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Iconsax.people, color: kAppPinkColor, size: 13,),
                                                  Text(' 17', style: kNormalTextStyle.copyWith( fontSize: 13),),
                                                  kMediumWidthSpacing,
                                                  Icon(Iconsax.ticket_expired, color: kAppPinkColor, size: 13,),
                                                  Text(' 5 days left', style: kNormalTextStyle.copyWith( fontSize: 13),),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 150,
                                              width: 170,
                                              margin: const EdgeInsets.only(
                                                  top: 10,
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  // color: backgroundColor,
                                                  image: DecorationImage(
                                                    image:  CachedNetworkImageProvider(images[index]),
                                                    //NetworkImage(images[index]),
                                                    fit: BoxFit.cover,
                                                  )
                                                //colours[index],
                                              ),

                                            ),

                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            items[index],
                                            style: kNormalTextStyleWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1));
                      })
                ],
              ),
            )
        ),
      );


  }

  // TextField searchBar() {
  //   return TextField(
  //     onTap: (){
  //       Navigator.pushNamed(context, AllProductsPage.id);
  //     },
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(50)),
  //               ),
  //               fillColor: Colors.white,
  //               filled: true,
  //               contentPadding:EdgeInsets.symmetric(horizontal: 20),
  //               prefixIcon: Icon(LineIcons.search),
  //               hintText: 'Chicken Salad'
  //
  //             ),
  //           );
  // }

  TileNow({required int index}) {
    return Container(
      height: 10,
      child: Text("$index"),
    );
  }

}


