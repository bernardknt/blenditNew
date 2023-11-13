import 'package:blendit_2022/models/ai_data.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utilities/font_constants.dart';

class DateSelectionWidget extends StatelessWidget {

  DateSelectionWidget({required this.selectedTime});
  final DateTime selectedTime;
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 180,
        // width: 150,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,// You can change this number based on how many cards you want.
          itemBuilder: (BuildContext context, int index) {

            // Generate a unique date for each card (you can modify this logic as needed).
            int currentMonth = DateTime.now().month;

            //DateTime currentDate = selectedTime.add(Duration(days: index));
            DateTime currentDate = DateTime( DateTime.now().year, currentMonth ,DateTime.now().day, selectedTime.hour, selectedTime.minute  );
            print(DateFormat('dd/MMM/yyy kk:mm ').format(currentDate));
            print(DateTime.now().month);
            // Get current hour and minute values
            int currentHour = DateTime.now().hour;
            int currentMinute = DateTime.now().minute;

            // Get selected hour and minute values
            int selectedHour = selectedTime.hour;
            int selectedMinute = selectedTime.minute;

            // Check if current hour is less than selected hour
            // or if current hour is equal to selected hour but current minute is less than selected minute
            if (currentHour < selectedHour || (currentHour == selectedHour && currentMinute < selectedMinute)) {
              print("THIS IS TRUE $currentHour < $selectedHour");
              currentDate = currentDate.add(Duration(days: index));
            } else {
              print("THIS RUN");
              currentDate = currentDate.add(Duration(days: index + 1));
            }

            return GestureDetector(

              onTap: (){
                Provider.of<AiProvider>(context, listen: false).setSelectedTimeValues(index, Provider.of<AiProvider>(context, listen: false).boxElevation[index], currentDate);

              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Provider.of<AiProvider>(context).boxElevationSelectedColorOfBoxes[index], width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  shadowColor: kGreenThemeColor,
                  elevation: Provider.of<AiProvider>(context).boxElevation[index],
                  //boxElevation[index],

                  margin: EdgeInsets.all(8.0),
                  child:

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${ DateFormat('EEEE').format(currentDate)}', style: kNormalTextStyle.copyWith(fontSize: 20, color: Colors.blueAccent),),
                        kSmallHeightSpacing,
                        SizedBox(
                            width: 90,

                            child: _buildDivider()),
                        Text('${ DateFormat('MMMM').format(currentDate)}', style: kNormalTextStyle,),
                        kSmallHeightSpacing,

                        CircleAvatar(
                            backgroundColor: kBlack,
                            child: Text('${currentDate.day}', style: TextStyle(fontSize: 18.0, color: kGreenThemeColor, fontWeight: FontWeight.bold),)),
                        kSmallHeightSpacing,
                        Text('${ DateFormat('kk:mm a').format(currentDate)}', style: kNormalTextStyle,),
                      ],
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  Container _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, ),
      width: double.infinity,
      height: 1.0,
      color: kFontGreyColor,

    );
  }
}