


import 'package:blendit_2022/screens/blender_page.dart';
import 'package:blendit_2022/screens/home_page_original.dart';
import 'package:blendit_2022/screens/new_settings.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/utilities/font_constants.dart';
import 'package:flutter/material.dart';

class ControlPageWeb extends StatefulWidget {
  static String id = "control_page_web";
  const ControlPageWeb({super.key});

  @override
  State<ControlPageWeb> createState() => _ControlPageWebState();
}

class _ControlPageWebState extends State<ControlPageWeb> {
  Widget _selectedWidget = NewBlenderPage();
  Color selectedColor = kGreenThemeColor.withOpacity(0.5);// Default selected widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: kChatGPTBlack,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Blendit', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 20)),
                  kLargeHeightSpacing,
                  kLargeHeightSpacing,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  _selectedWidget is NewBlenderPage ? selectedColor : null,
                    ),
                    child: ListTile(
                      title: Text('Blender', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
                      //tileColor: _selectedWidget is NewBlenderPage ? Colors.green : null,
                      onTap: () {
                        setState(() {
                          _selectedWidget = NewBlenderPage();
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  _selectedWidget is HomePageOriginal ? selectedColor : null,
                    ),
                    child: ListTile(
                      title: Text('Store', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
                      //tileColor: _selectedWidget is HomePageOriginal ? Colors.green : null,
                      onTap: () {
                        setState(() {
                          _selectedWidget = HomePageOriginal();
                        });
                      },
                    ),
                  ),
                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  _selectedWidget is NewSettingsPage ? selectedColor : null,
                    ),
                    child: ListTile(
                      title: Text('Settings', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),

                      onTap: () {
                        setState(() {
                          _selectedWidget = NewSettingsPage();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _selectedWidget, // Display the selected widget
          ),
        ],
      ),
    );
  }
}

