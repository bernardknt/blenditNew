
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/salads_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/itemsDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
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

class HomePage extends StatefulWidget {
  static String id = 'home_page';

  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
      backgroundColor: Color(0xFF0c1206),
      appBar: AppBar(

        backgroundColor: Colors.transparent,
       // foregroundColor: Colors.blue,

        brightness: Brightness.light,
        elevation:8 ,
        actions: [
          Stack(children: [
            Positioned(
              top: 4,
              right: 2,
              child: CircleAvatar(radius: 10,
                  child: Text(
                    '${blendedData.basketNumber}', style: TextStyle(fontSize: 10),)),
            ) ,
            IconButton
              (onPressed: (){
              Navigator.pushNamed(context, CheckoutPage.id);
            },
                icon: Icon(LineIcons.shoppingBasket),),
          ]
          )
        ],
        title: Text(""),
        centerTitle: true,
        leading:Transform.translate(offset: const Offset(20*0.5, 0),
         child: IconButton(
           icon: Image.asset('images/blender_component.png'),
           onPressed: () {
             Navigator.pushNamed(context, LoyaltyPage.id);
           },
         ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$name, find \nthe Best for you', textAlign:TextAlign.start , style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25
              ),),
              SizedBox(height: 20,),
              searchBar(),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.only(top: 20, ),
                  child:
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
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
                      child: Categories(categoriesNumber: categories.length, categories: categories, pageName: pages,))
                ],
              ),
              const SizedBox(height: 20,),
              const Text("Today's Special", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20,),
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
                                      showDialogFunc(
                                          context, images[index], items[index],
                                          descList[index], prices[index]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10,
                                          right: 0,
                                          left: 0,
                                          bottom: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: colours[index],
                                      ),
                                      child: Column(
                                        children: [
                                          FadeInImage.assetNetwork(
                                            placeholder: 'images/loading.gif',
                                            image: images[index],
                                            height: 170,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          // Image.asset(images[index],
                                          // width: double.infinity,
                                          //   fit: BoxFit.cover,
                                          //   height: 170,
                                          // ),
                                          Padding(

                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(items[index],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),),
                                                      Text(
                                                        'Ugx ${formatter.format(
                                                            prices[index])}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),)
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
  Categories({required this.categoriesNumber, required this.categories, required this.pageName});
  final int categoriesNumber;
  final List categories;
  final List pageName;

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
              color: Colors.white
            ),
            child: Row(
               children: [
                Text(categories[index])
              ],

            ),
          ),

        );
        }),
                    ),

                  );
  }
}
