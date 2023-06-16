


import 'package:blendit_2022/utilities/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utilities/line_titles.dart';

class LineChartWidget extends StatelessWidget {
  LineChartWidget({required this.graphValues, required this.targetValues});

    final List<FlSpot> graphValues;
    final List<FlSpot> targetValues;

  final List<Color> gradientColors = [
    // kCustomColor,
    Colors.lightBlueAccent,
    kBlueDarkColor,
    // Colors.red
  ];
  final List<Color> gradientColors2 = [
    // kCustomColor,
    Colors.red,
    kBlueDarkColor,
    // Colors.red
  ];
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX:0,
        maxX: 6,
        minY: 0,
        maxY: 140,
        titlesData: LineTitles.getTitleData(),
        borderData: FlBorderData(
          show: false
        ),
        gridData: FlGridData(
          show: false,

        ),
        lineBarsData: [
          LineChartBarData(
              isCurved: true,
              barWidth: 2,
              color: Colors.red,
              belowBarData: BarAreaData(

                show: false,
                // color: kCustomColor
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors2,
                ),
              ),

              // gradient: gradientColors,
              spots: targetValues
          ),
          LineChartBarData(
            isCurved: true,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: false,
              // color: kCustomColor
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            // dotData:FlDotData(
            //   show: true,
            //
            // ),

            // gradient: gradientColors,
            spots: graphValues
          ),

        ]
      )

    );
  }
}
