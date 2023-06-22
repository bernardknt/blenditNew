import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
class LineTitles {
  static getTitleData () => FlTitlesData(
    show: true,
    rightTitles: AxisTitles(
        axisNameWidget: Text("", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 14),)

    ),
    topTitles: AxisTitles(
      axisNameWidget: Column(
        children: [
          Text("Beat the Red Line", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 12),),
        ],
      )

    ),
    leftTitles: AxisTitles(
        axisNameWidget: Text("Goal Points", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 12),),
      axisNameSize: 40,
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: (value, titleMeta){
            switch (value.toInt()){
              // case 1: return Text("Tue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),);
              case 20: return Text("20", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
              // case 3: return Text("Thu", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),);
              case 40: return Text("40", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
             // case 5: return Text("Sat", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 10),);
              case 60: return Text("60", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
              case 80: return Text("80", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
              case 100: return Text("100", style: kNormalTextStyle.copyWith(color:kBlack, fontSize: 10),);

            }
            return Text("", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
          }
      )



    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTitlesWidget: (value, titleMeta){
          switch (value.toInt()){
            case 1: return Text("Day 2", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
            case 2: return Text("Day 3", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
            case 3: return Text("Day 4", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
            case 4: return Text("Day 5", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
            case 5: return Text("Day 6", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
            case 6: return Text("Day 7", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
          }
          return Text("Day 1", style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 10),);
        }
      )
    )
  );
}