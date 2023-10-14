
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/gyms_pages/categories.dart';
import 'package:blendit_2022/screens/products_page.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../utilities/font_constants.dart';
import 'allProducts_page.dart';
import 'checkout_page.dart';
import 'choose_juice_page.dart';
import 'detox_juice.dart';
import 'detox_plans.dart';
import 'loyalty_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageOriginal extends StatefulWidget {
  static String id = 'home_page_original';



  @override

  _HomePageOriginalState createState() => _HomePageOriginalState();
}

class _HomePageOriginalState extends State<HomePageOriginal> {
  final locationIndicator = GlobalKey();
  var images = [];
  var colours = [Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent, Colors.pink, Colors.deepPurpleAccent, Colors.teal, Colors.purple, Colors.pink, Colors.deepPurpleAccent];
  var items = [];
  var descList = [];
  var products = [];
  var locations = [];
  var providerId = [];
  var itemsGym=[];
  var descListGym = [];
  var imagesGym = [];
  List<Map> productsGym = [];
  var aboutGym = [];
  var providerImagesGym = [];
  List<GeoPoint> coordinatesGym = [];
  var phoneNumberGym = [];
  var about = [];
  var backgroundColor = Color(0xFF202020);
  var backgroundVariantColor = Color(0xFF2e3032);
  var canvasColor = kPureWhiteColor;
      //kBlueDarkColor;
  var textColor = kPureWhiteColor;
  var contrastColor = kCustomColor;


  var prices = [];
  var categories = ["🧺 Products", '🍵 Juices & Smoothies','🍏Detox Plans', '🥗 Salads']; //, 🍹Tropical Juices'
  var pages = [ProductsPage.id, DetoxJuicePage.id, DetoxPlansPage.id, SaladsPage.id ]; // , TropicalPage.id
  String name = 'Bernard';
  String location = '';
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

  void updateFirestoreCollection() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection('orders'); // Replace 'your_collection' with your actual collection name

    // Get documents from the collection
    QuerySnapshot querySnapshot = await collection.get();

    // Loop through the documents and update the 'available' field to true
    querySnapshot.docs.forEach((doc) async {
      // Update the document with the 'available' field set to true
      await collection.doc(doc.id).update({
        'paymentStatus': "paid",
        'status': 'delivered'
      });
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
        backgroundColor: backgroundVariantColor,
        //Color(0xFF0c1206),
        appBar: AppBar(

          backgroundColor:backgroundVariantColor,
          elevation:0 ,
          title:
          GestureDetector(
            onTap: ()
            async{
              final prefs = await SharedPreferences.getInstance();

              //var blendedDataModify = Provider.of<BlenditData>(context, listen: false);
              Prediction? p = await PlacesAutocomplete.show(context: context,
                  apiKey: kGoogleMapsApiKey,
                  types: [],
                  strictbounds: true,
                  mode: Mode.overlay,
                  location: Location(lat: 0.3173, lng: 32.5927), // 0.3172959363980288, 32.59267831534121
                  radius: 30,
                  //prefs.getInt(kCoverageDistance),
                  language: 'en', components: [Component(Component.country, 'UG')]);
              if (p != null){
                // print(p.description);
                location = p.description!;
                // Provider.of<BlenditData>(context, listen: false).setLocation(p.description!);
                GoogleMapsPlaces _places = GoogleMapsPlaces(
                  apiKey: kGoogleMapsApiKey,
                  //apiHeaders: await GoogleApiHeaders().getHeaders(),
                );
                PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
                final lat = detail.result.geometry!.location.lat;
                final lng = detail.result.geometry!.location.lng;
                final prefs = await SharedPreferences.getInstance();
                // prefs.setString(kLocationName, p.description!);
                // prefs.setDouble(kLocationLongitude, lng);
                // prefs.setDouble(kLocationLatitude, lat);

                return CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    widget: Column(
                      children: [
                       Text('Show results around $location', textAlign: TextAlign.center, style: kNormalTextStyle,),

                      ],
                    ),
                    title: 'Update Location',

                    confirmBtnColor: kAppPinkColor,
                    confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                    lottieAsset: 'images/places.json', showCancelBtn: true, backgroundColor: kBlack,


                    onConfirmBtnTap: (){
                      setState((){
                        // CommonFunctions().uploadUserLocation(lat, lng, p.description!);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pushNamed(context, SpecialistListPage.id);


                      });
                    }


                );

              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Lottie.asset('images/bilungo.json',
                  height: 30,
                ),
                Flexible(

                    child: Text(location,style: kBannersFontNormal,overflow: TextOverflow.fade,)),
              ],
            ),
          ),
          actions: [
            blendedData.basketNumber == 0?Container():Stack(children: [
              Positioned(
                top: 4,
                right: 2,
                child: CircleAvatar(
                    backgroundColor: kAppPinkColor,
                    radius: 10,
                    child: Text(
                      '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
              ) ,
              IconButton
                (onPressed: (){
                if (blendedData.basketNumber == 0) {

                }else {
                  Navigator.pushNamed(context, CheckoutPage.id);
                }
              },
                icon: Icon(LineIcons.shoppingBasket),),
            ]
            )
          ],
          automaticallyImplyLeading: false,

        ),

        body: SingleChildScrollView(
            // padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundVariantColor
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [kGreenThemeColor, kGreenThemeColor, Colors.yellow, kAppPinkColor],
                  // ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('$name, find \nthe Best for you', textAlign:TextAlign.start , style: const TextStyle(
                    //     fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25
                    // ),),
                    // SizedBox(height: 20,),
                    // searchBar(),
                Container(

                      decoration: BoxDecoration(
                        // color: kBlueDarkColor,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [backgroundVariantColor, backgroundVariantColor,backgroundVariantColor,backgroundVariantColor],
                          ),
                       // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text('Challenge Yourself (Gyms & Pros)', textAlign:TextAlign.start , style: kHeading2TextStyleBold.copyWith(color:kPureWhiteColor,fontWeight: FontWeight.bold),),
                            kSmallHeightSpacing,
                            Container(
                              height: 140,
                              width: double.maxFinite,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('providers')
                                      .where('promote', isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                        // color: Colors.black,
                                      );
                                    } else {
                                      itemsGym=[];
                                      descListGym = [];
                                      imagesGym = [];
                                      productsGym = [];
                                      aboutGym = [];
                                      providerImagesGym = [];
                                      coordinatesGym = [];
                                      phoneNumberGym = [];



                                      var events = snapshot.data!.docs;
                                      for (var event in events) {
                                        descListGym.add(event.get('description'));
                                        itemsGym.add(event.get('name'));
                                        imagesGym.add(event.get('image'));
                                        // prices.add(event.get('price'));
                                        productsGym.add(event.get('products'));
                                        aboutGym.add(event.get('about'));
                                        locations.add(event.get('location'));
                                        providerId.add(event.get('id'));
                                        phoneNumberGym.add(event.get('phone'));
                                        providerImagesGym.add(event.get('placeImages'));
                                        coordinatesGym.add(event.get('cord'));
                                      }
                                    }
                                    return SpecialistCategories(categoriesNumber: itemsGym.length, categories: itemsGym, categoryId: providerId, categoriesMainImage: imagesGym, categoriesProducts: productsGym, categoriesLocations: locations, categoriesAbout: aboutGym, categoriesPhoneNumber: phoneNumberGym, categoriesCoordinates: coordinatesGym, categoriesLocationImages: providerImagesGym,);
                                  }),
                            ),
                            TextButton(child: Text("See more..", style: kHeading2TextStyleBold.copyWith(color: Colors.blue, )), onPressed: () {

                              Get.snackbar('Coming soon', "We cant wait..",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: kCustomColor,
                                  colorText: kBlack,
                                  icon: Icon(Icons.check_circle, color: kGreenThemeColor,));
                            },
                            ),
                          ],
                        ),
                      ),
                    ),

                   Container(
                     decoration: BoxDecoration(
                         color: backgroundColor,
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                     ),
                     child: Padding(padding:EdgeInsets.all(20),
                     child: Column(
                       children: [
                         Text("Featured Products", style: kHeading2TextStyleBold.copyWith(color: textColor, fontWeight:FontWeight.bold),
                         ),
                         // kLargeHeightSpacing,
                         Row(
                           children: [
                             Padding(padding: const EdgeInsets.only(top: 20, ),
                               child:
                               GestureDetector(
                                 onTap: (){},
                                 child:
                                 Container(
                                   height: 35,
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       color: kPureWhiteColor
                                   ),
                                   padding: EdgeInsets.symmetric(horizontal: 8),
                                   margin: EdgeInsets.only(right: 10),
                                   child: Row(
                                     children: [
                                       Image.asset('images/blend.jpeg')
                                     ],
                                   ),

                                 ),
                               ),
                             ),
                             Expanded(
                                 child: Categories(categoriesNumber: categories.length, categories: categories, pageName: pages, backgroundColor: backgroundVariantColor, textColor: kPureWhiteColor,))
                           ],
                         ),
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
                                     mainAxisSpacing: 10,
                                     itemCount: items.length,

                                     crossAxisSpacing: 10,
                                     physics: NeverScrollableScrollPhysics(),
                                     scrollDirection: Axis.vertical,
                                     shrinkWrap: true,
                                     itemBuilder: (context, index) {
                                       return GestureDetector(
                                         onTap: () {
                                           showDialogFunc(
                                               context, images[index], items[index],
                                               descList[index], prices[index]);
                                         },
                                         child:
                                         Container(
                                             height: 160,
                                             width: 100,
                                             padding: EdgeInsets.symmetric(horizontal: 4),
                                             margin: EdgeInsets.all(5),
                                             alignment: Alignment.bottomCenter,
                                             decoration: BoxDecoration(
                                                 boxShadow: [
                                                   // BoxShadow(
                                                   //   color: Colors.white.withOpacity(0.4),
                                                   //   spreadRadius: 1,
                                                   //   blurRadius: 1,
                                                   //   offset: Offset(0, 1), // changes position of shadow
                                                   // ),
                                                 ],
                                                 borderRadius: BorderRadius.circular(20),
                                                 color: Colors.white,
                                                 image: DecorationImage(
                                                   fit: BoxFit.cover,
                                                   image:
                                                   CachedNetworkImageProvider(images[index]),
                                                   // NetworkImage(categoriesImages[index]),
                                                 )
                                             ),
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               children: [
                                                 Container(

                                                   width: double.maxFinite,
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(5),
                                                       color:  colours[index]
                                                   ),
                                                   child: Padding(

                                                     padding: EdgeInsets.symmetric(
                                                         horizontal: 12),

                                                     child: Row(
                                                       mainAxisAlignment:
                                                       MainAxisAlignment.spaceBetween,
                                                       children: [
                                                         Column(
                                                           crossAxisAlignment: CrossAxisAlignment
                                                               .center,
                                                           children: [
                                                             Text(items[index],
                                                               overflow: TextOverflow.clip,
                                                               textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   color: Colors.white,
                                                                   fontSize: 12, fontWeight: FontWeight.bold

                                                               ),),
                                                             Text(
                                                               'Ugx ${formatter.format(
                                                                   prices[index])}',
                                                               style: TextStyle(
                                                                   color: Colors.white,
                                                                   fontSize: 12),)
                                                           ],
                                                         ),
                                                       ],
                                                     ),),
                                                 ),
                                               ],
                                             )

                                           // Padding(
                                           //   padding: const EdgeInsets.all(6.0),
                                           //   child: Padding(
                                           //     padding: const EdgeInsets.all(1.0),
                                           //     child: Text(
                                           //         categories[index],
                                           //         style: kNormalTextStyle.copyWith(color: kPureWhiteColor)
                                           //     ),
                                           //   ),
                                           // ),
                                         ),
                                         // Container(
                                         //   // margin: EdgeInsets.only(top: 10,
                                         //   //     right: 0,
                                         //   //     left: 0,
                                         //   //     bottom: 3),
                                         //   height: 150,
                                         //   decoration: BoxDecoration(
                                         //     borderRadius: BorderRadius.circular(25),
                                         //     color: Colors.red
                                         //     //colours[index],
                                         //   ),
                                         //   child: Column(
                                         //     children: [
                                         //       // FadeInImage.assetNetwork(
                                         //       //   placeholder: 'images/loading.gif',
                                         //       //   image: images[index],
                                         //       //   height: 170,
                                         //       //   width: double.infinity,
                                         //       //   fit: BoxFit.cover,
                                         //       // ),
                                         //
                                         //       Image.asset("images/child.jpg", fit: BoxFit.contain,),
                                         //
                                         //       Padding(
                                         //
                                         //         padding: EdgeInsets.symmetric(
                                         //             horizontal: 12),
                                         //         child: Row(
                                         //           mainAxisAlignment: MainAxisAlignment
                                         //               .spaceBetween,
                                         //           children: [
                                         //             Column(
                                         //               crossAxisAlignment: CrossAxisAlignment
                                         //                   .start,
                                         //               children: [
                                         //                 Text(items[index],
                                         //                   style: TextStyle(
                                         //                       color: Colors.white,
                                         //                       fontSize: 12),),
                                         //                 Text(
                                         //                   'Ugx ${formatter.format(
                                         //                       prices[index])}',
                                         //                   style: TextStyle(
                                         //                       color: Colors.white,
                                         //                       fontSize: 12),)
                                         //               ],
                                         //             ),
                                         //           ],
                                         //         ),)
                                         //     ],
                                         //   ),
                                         // ),
                                       );
                                     },
                                     staggeredTileBuilder: (index) =>
                                         StaggeredTile.fit(1));
                             })
                       ],
                     ),
                     ),
                   ),



                  ],
                ),
              ),
            )
        ),
      );


  }
  buildNumber(String number) => Container(
    padding: EdgeInsets.all(16),
    color: Colors.orange,
    child: GridTile(
      header: Text(
        'Header $number',
        textAlign: TextAlign.center,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
          textAlign: TextAlign.center,
        ),
      ),
      footer: Text(
        'Footer $number',
        textAlign: TextAlign.center,
      ),
    ),
  );

  Padding questionBlocks(String speciality, String id) {
    var randomColors = [Colors.teal, Colors.blueAccent, Colors.black12, Colors.deepPurpleAccent, Colors.white12];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector (
        onTap: (){
          Provider.of<BlenditData>(context, listen: false).setCustomJuiceSpeciality(id, speciality);
          Navigator.pushNamed(context, ChooseJuicePage.id);
        },
        child: Container(
          // color: Colors.white,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color:  randomColors[4]
          ),
          child: Center(child: Text(
            speciality,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),

        ),
      ),
    );
  }

  TextField searchBar() {
    return TextField(
      onTap: (){
        Navigator.pushNamed(context, AllProductsPage.id);
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding:EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: Icon(LineIcons.search),
          hintText: 'Chicken Salad'

      ),
    );
  }

  TileNow({required int index}) {
    return Container(
      height: 10,
      child: Text("$index"),
    );
  }

}

class Categories extends StatelessWidget {
  Categories({required this.categoriesNumber, required this.categories, required this.pageName, required this.backgroundColor, required this.textColor});
  final int categoriesNumber;
  final List categories;
  final List pageName;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 20), child: SizedBox(
      height: 35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesNumber,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, pageName[index]);

              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: backgroundColor
                ),
                child: Row(
                  children: [
                    Text(categories[index], style: kNormalTextStyle.copyWith(color: textColor),)
                  ],

                ),
              ),

            );
          }),
    ),

    );
  }
}
