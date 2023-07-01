





import 'package:blendit_2022/models/CommonFunctions.dart';
import 'package:blendit_2022/utilities/constants.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'delivery_page.dart';

class IosOnboarding extends StatelessWidget {
  const IosOnboarding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      CupertinoOnboarding(
      onPressedOnLastPage: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool(kFirstTimePhoto, false);
        Navigator.pop(context);
        CommonFunctions().pickImage(ImageSource.camera, 'pic${DateTime.now().toString()}${uuid.v1().split("-")[0]}', context, false, "", []);


      },
      pages: [
        WhatsNewPage(
          title: const Text("Snap 📸 and Achieve 💪"),
          features: const [
            WhatsNewFeature(
              title: Text('Snap Your Food, Ingredients or Fridge'),
              description: Text(
                  'Take photos of your meals, snacks, and ingredients and get real-time feedback on there value to you'),
              icon: Icon(CupertinoIcons.camera),
            ),
            WhatsNewFeature(
              title: Text("Achieve Your Health Goals"),
              description: Text(
                  "Get personalized recommendations based on your individual needs. Stay motivated and on track with your nutrition journey"),
              icon: Icon(CupertinoIcons.star),
            ),
            WhatsNewFeature(
              title: Text('Upload Responsibly'),
              description: Text(
                  "Make sure that all photos taken are non offensive and appropriate. Lets Go"),
              icon: Icon(CupertinoIcons.camera_viewfinder),
            ),
          ],
        ),
        // const CupertinoOnboardingPage(
        //   title: Text('Support For Multiple Pages'),
        //   body: Icon(
        //     CupertinoIcons.square_stack_3d_down_right,
        //     size: 200,
        //   ),
        // ),
        // const CupertinoOnboardingPage(
        //   title: Text('Great Look in Light and Dark Mode'),
        //   body: Icon(
        //     CupertinoIcons.sun_max,
        //     size: 200,
        //   ),
        // ),
        // const CupertinoOnboardingPage(
        //   title: Text('Beautiful and Consistent Appearance'),
        //   body: Icon(
        //     CupertinoIcons.check_mark_circled,
        //     size: 200,
        //   ),
        // ),
      ],
    );
  }
}