import 'package:blendit_2022/models/ai_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utilities/constants.dart';
import '../utilities/font_constants.dart';



class TutorialPage extends StatefulWidget {

  static String id = 'youtube_page';


  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  double buttonHeight = 40.0;

  String youtubeUrl = 'https://www.youtube.com/watch?v=8DhO5YOhTx4&list=RD8DhO5YOhTx4&start_radio=1&ab_channel=WilliamMcDowellMusic';
  late YoutubePlayerController _controller;
  List videos = [
    'https://www.youtube.com/shorts/ELOtHmqW3Xg',
    // 'https://www.youtube.com/watch?v=981ola1eX8E&ab_channel=TraviAgency',
    // 'https://www.youtube.com/watch?v=Jzn_4sjSmWk&ab_channel=S%C3%A1vaArabad%C5%BEiev'

  ];
  List titles = [
    'Get recipes using camera',
    // 'Adding Services and Products to Your Store',
    // 'Recording your Offline Sales'

  ];

  void defaultInitialization(){
    titles = Provider.of<AiProvider>(context, listen: false).youtubeVideos.keys.toList();
    videos  = Provider.of<AiProvider>(context, listen: false).youtubeVideos.values.toList();

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(youtubeUrl)! ,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
  }




  @override
  Widget build(BuildContext context){

  return Scaffold(
    backgroundColor: kBlack,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kBlack,
      foregroundColor: kAppPinkColor,
      title: Text('Tutorial Videos', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      centerTitle: true,
    ),
        body: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (BuildContext context, int index) {

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('${index + 1}.  ${titles[index]}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),),
                  kSmallHeightSpacing,
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(videos[index])! ,
                      flags: const YoutubePlayerFlags(
                        mute: false,
                        autoPlay: false,
                      ),
                    )

                  ),
                ],
              ),
            );
          },
    ),
  );
  }
  //     )
  // );

  }


