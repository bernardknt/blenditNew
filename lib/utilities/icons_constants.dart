import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'constants.dart';
import 'font_constants.dart';

const kIconBuilding = Icon(FontAwesomeIcons.building,color: kFontGreyColor,size: kIconSize,);
const kIconCalendar = Icon(CupertinoIcons.calendar, color: kFontGreyColor,size: kIconSize);

const kIconRoad = Icon (FontAwesomeIcons.road, color: kFontGreyColor,size: kIconSize,);
const kIconClock =  Icon(FontAwesomeIcons.clock,color: kFontGreyColor,size: kIconSize);
const kIconScissor =  Icon(Iconsax.scissor_1,color: kFontGreyColor,size: kIconSize,);
const kIconScissorWhite =  Icon(Iconsax.scissor_1,color: Colors.white,size: kIconSize,);
const kIconStar =  Icon(Iconsax.star1, color: kBlueDarkColor,size: 25,);
const kIconStarWhite =  Icon(Iconsax.star1, color: Colors.white,size: kIconSize,);
const kIconCustomer =  Icon(Iconsax.personalcard, color:  kFontGreyColor,size: kIconSize,);
const kIconLocation =  Icon(Icons.location_on, color: kFontGreyColor,size: kIconSize,);
const kIconLocationWhite =  Icon(Icons.location_on, color: Colors.white,size: kIconSize,);
const kIconApprovedGreen =  Icon(CupertinoIcons.checkmark_seal_fill, color: kNewGreenThemeColor,size: 15,);
const kIconWavyMoneyGrey =  Icon(FontAwesomeIcons.moneyBillWave, color: kFaintGrey,size: 15,);
const kIconWavyMoneyGreen =  Icon(FontAwesomeIcons.moneyBillWave, color: kNewGreenThemeColor,size: 13,);
const kIconFavouriteHeart =  Icon(Iconsax.heart, color:kGreenJavasThemeColor,size: 18 );
const kIconArrowLeft =  CircleAvatar(backgroundColor: kFontGreyColor, radius: 8, child: Icon(Icons.arrow_back, size: 12, color: kPureWhiteColor,));
const kIconArrowRight =  CircleAvatar(backgroundColor: kFontGreyColor, radius: 8, child: Icon(Icons.arrow_forward, size: 12, color: kPureWhiteColor,));
const kIconCancel =  Icon(Icons.cancel, color: kBlack,);