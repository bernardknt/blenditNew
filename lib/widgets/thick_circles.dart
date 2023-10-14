

import 'package:flutter/cupertino.dart';

import '../utilities/constants.dart';


class ThickCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2.5, color: kBlack)
      ),
    );
  }
}
