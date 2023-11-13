
import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/screens/gyms_pages/showGymProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/font_constants.dart';
import '../../widgets/gyms_and_store_onboarding.dart';
import '../../widgets/show_summary_dialog.dart';


class SpecialistCategories extends StatelessWidget {
  SpecialistCategories(
      {
        required this.categoriesNumber,
        required this.categories,
        required this.categoryId,
        required this.categoriesMainImage,
        required this.categoriesProducts,
        required this.categoriesLocations,
        required this.categoriesAbout,
        required this.categoriesPhoneNumber,
        required this.categoriesCoordinates,
        required this.categoriesLocationImages,
        required this.categoriesSessionTime

      });

  final int categoriesNumber;

  final List categories;
  final List categoriesSessionTime;
  final List categoryId;
  final List categoriesMainImage;
  final List<Map> categoriesProducts;
  final List categoriesLocations;
  final List categoriesAbout;
  final List categoriesPhoneNumber;
  final List<GeoPoint>  categoriesCoordinates;
  final List categoriesLocationImages;
  @override

  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
        crossAxisCount: 1,
        itemCount: categoriesNumber,
        crossAxisSpacing: 5,
        scrollDirection: Axis.horizontal,
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true ,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: ()async {
              final prefs = await SharedPreferences.getInstance();
              bool isFirstStoreVisit = prefs.getBool(kIsFirstStoreVisit) ?? true;
              Provider.of<AiProvider>(context, listen: false).clearServiceProviderInfo();
              Provider.of<AiProvider>(context, listen: false).resetSelectedTimeValues();

              showGymProvider(context,
                  categoriesMainImage[index],
                  categories[index],
                  categoriesLocations[index],
                  categoriesProducts[index],
                  categoriesAbout[index],
                  categoriesPhoneNumber[index],
                  categoriesCoordinates[index],
                  categoriesLocationImages[index],
                  categoryId[index],
                categoriesSessionTime[index]
              );
              if(isFirstStoreVisit == true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> GymsAndServiceProviderOnboarding())
                );
              }

            },
            child:
            Container(
              height: 120,
              width: 50,
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.all(5),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                    CachedNetworkImageProvider(categoriesMainImage[index]),
                    // NetworkImage(categoriesImages[index]),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                      categories[index],
                      style: kNormalTextStyle.copyWith(color: kPureWhiteColor)
                  ),
                ),
              ),
            ),
          );
        }, staggeredTileBuilder: (index)=> const StaggeredTile.fit(1));

  }
}

