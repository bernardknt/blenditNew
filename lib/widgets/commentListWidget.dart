
import 'package:blendit_2022/widgets/roundedIconButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class CommentListWidget extends StatelessWidget {

  CommentListWidget({required this.cardColor, required this.imageUrl, required this.blogComment, required this.senderName});

  final String senderName;
  final String blogComment;
  final String imageUrl;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    var numberOfFollowers = blogComment.length;
    return Container(
      //width: double.infinity,

      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(top: 16, left:16, right: 16),
      decoration: BoxDecoration(
        color: Color(0xFF212121), borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(padding: EdgeInsets.only(top:0),
            child:
            Row(
              children: [
                Expanded(

                  flex:1,
                  child: Container(
                      child: RoundedIconButtons(networkImageToUse: imageUrl, labelText: senderName)
                  ), ),
                Expanded(

                    flex: 5,
                    child: Container(


                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child:
                          RichText(text: TextSpan(text:blogComment,
                            //style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                            style: GoogleFonts.lato(fontSize: 13),
                          ),)
                      ),
                    ))

              ],
            ),
          ),
          Row(children: [
            Expanded(
                flex: 2,
                child: Container(

                )),
            Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(right:10, top: 10),
                )),
          ],)
        ],
      ),
    );
  }
}