
import 'package:blendit_2022/models/blendit_data.dart';
import 'package:blendit_2022/screens/delivery_page.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class DeliveryOptionsDialog extends StatelessWidget {
  DateTime now = DateTime.now();

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
                    var after = DateTime(now.year, now.month, now.day, now.hour +1, now.minute );
                    print('Entered time is $now, expected delivery time is $after');
                    Provider.of<BlenditData>(context, listen: false).setDeliveryDateTime(after);
                    CoolAlert.show(
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

                },
                  style: TextButton.styleFrom(
                    //elevation: ,
                      shadowColor: kBlueDarkColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                      backgroundColor: Colors.green),icon: Icon(LineIcons.thumbsUp, color: Colors.white,),
                  label: Text('Now', style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white), ), ),
                  SizedBox(width: 10,),
                  TextButton.icon(onPressed: (){
                    DatePicker.showDateTimePicker(context,  onConfirm: (date){
                      deliveryTime = date;
                      Provider.of<BlenditData>(context, listen: false).setDeliveryDateTime(date);
                      print(deliveryTime);

                      CoolAlert.show(
                          lottieAsset: 'images/purple.json',
                          context: context,
                          type: CoolAlertType.success,
                          widget: SingleChildScrollView(
                            child: Container(

                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Please add Avocado in my salad',
                                ),
                                onChanged: (description){
                                  chefInstructions = description;

                                },
                              ),
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
                    });
                  },
                    style: TextButton.styleFrom(
                      //elevation: ,
                        shadowColor: kBlueDarkColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)
                        ),
                        backgroundColor: kBlueDarkColor),icon: Icon(LineIcons.userClock, color: Colors.white,),
                    label: Text('Choose Custom Time', style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white), ), ),
                ]
              ),
              // Color(0xFFF2efe4)

            ]
        ),
      ),
    );
  }
}

