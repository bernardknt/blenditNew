
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../models/responsive/dimensions.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class DeliveryOptionsDialog extends StatelessWidget {
  DateTime now = DateTime.now();

  Future<void> _pickDateTime() async {

  }

  @override
  Widget build(BuildContext context) {
    var deliveryTime;
    var blendedData = Provider.of<BlenditData>(context);
    var chefInstructions = '';
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBiegeThemeColor, kPinkBlenderColor] ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),  topLeft: Radius.circular(20)),
            color: Colors.green
        ),

        padding: EdgeInsets.all(20),
        child: Column(
            children : [

              Text('Choose Delivery Time', style: TextStyle(fontWeight: FontWeight.bold,
                  color: kBlueDarkColor, fontSize: 20, ),),
              SizedBox(height: 10,),

              Text(' What time would you like your order delivered', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.grey.shade700, fontSize: 18,),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(onPressed: (){
                  //DatePicker.showDateTimePicker(context);

                    DateTime after = DateTime(now.year, now.month, now.day, now.hour +1, now.minute );

                    print(after.hour);
                    if (after.hour >= 8 && after.hour < 19){
                      print('Entered time is $now, expected delivery time is $after');
                      Provider.of<BlenditData>(context, listen: false).setDeliveryDateTime(after);
                      CoolAlert.show(
                          width: MediaQuery.of(context).size.width >mobileWidth? screenDisplayWidth : MediaQuery.of(context).size.width,

                          lottieAsset: 'images/purple.json',
                          context: context,
                          type: CoolAlertType.success,
                          widget: Container(

                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Please add Avocado in my salad',
                              ),
                              onChanged: (description){
                                chefInstructions = description;
                              },
                            ),
                          ),
                          text: 'Do you have any additional information about your order?..Tell us',
                          title: 'Note to the Chef',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          showCancelBtn: true,
                          confirmBtnColor: Colors.green,
                          backgroundColor: Colors.white,
                          onCancelBtnTap: (){
                            Provider.of<BlenditData>(context, listen: false).setChefInstructions('');
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, DeliveryPage.id);
                          },
                          onConfirmBtnTap: (){
                            Provider.of<BlenditData>(context, listen: false).setChefInstructions(chefInstructions);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, DeliveryPage.id);
                          }

                      );
                    }
                    else {

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Ooops! We cant deliver at that Time',textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
                          content: Text('Delivery time must be between 8 am and 6 pm.',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 18)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },);
                    }


                },
                  style: TextButton.styleFrom(
                    //elevation: ,
                      shadowColor: kBlueDarkColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                      backgroundColor: Colors.green),icon: Icon(LineIcons.thumbsUp, color: Colors.white,),
                  label: const Text('Now', style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white), ), ),
                  const SizedBox(width: 10,),
                  TextButton.icon(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2024),
                      );

                      if (selectedDate == null) return;

                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime == null) return;

                      final deliveryTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Check if the delivery time is between 8 am and 6 pm
                      if (deliveryTime.hour >= 8 && deliveryTime.hour < 18) {
                        Provider.of<BlenditData>(context, listen: false).setDeliveryDateTime(deliveryTime);
                        print(deliveryTime);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, DeliveryPage.id);
                      } else {
                        // Show a popup because the delivery time is not within the allowed range
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Ooops! We cant deliver at that Time',textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
                              content: Text('Delivery time must be between 8 am and 6 pm.',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontSize: 18)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      shadowColor: kBlueDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: kBlueDarkColor,
                    ),
                    icon: Icon(LineIcons.userClock, color: Colors.white),
                    label: Text(
                      'Choose Custom Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // TextButton.icon(onPressed: ()async{
                  //   final selectedDate = await showDatePicker(
                  //     context: context,
                  //     initialDate: DateTime.now(),
                  //     firstDate: DateTime(2023),
                  //     lastDate: DateTime(2024),
                  //   );
                  //
                  //   if (selectedDate == null) return;
                  //
                  //   final selectedTime = await showTimePicker(
                  //     context: context,
                  //     initialTime: TimeOfDay.now(),
                  //   );
                  //
                  //   if (selectedTime == null) return;
                  //     // deliveryTime = selectedTime;
                  //     deliveryTime = DateTime(
                  //       selectedDate.year,
                  //       selectedDate.month,
                  //       selectedDate.day,
                  //       selectedTime.hour,
                  //       selectedTime.minute,
                  //     );
                  //     Provider.of<BlenditData>(context, listen: false).setDeliveryDateTime(deliveryTime);
                  //     print(deliveryTime);
                  //   Navigator.pop(context);
                  //   Navigator.pop(context);
                  //   Navigator.pushNamed(context, DeliveryPage.id);
                  //
                  //
                  // },
                  //   style: TextButton.styleFrom(
                  //     //elevation: ,
                  //       shadowColor: kBlueDarkColor,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(18)
                  //       ),
                  //       backgroundColor: kBlueDarkColor),icon: Icon(LineIcons.userClock, color: Colors.white,),
                  //   label: Text('Choose Custom Time', style: TextStyle(fontWeight: FontWeight.bold,
                  //       color: Colors.white), ), ),
                ]
              ),
              // Color(0xFFF2efe4)

            ]
        ),
      ),
    );
  }
}

