import 'dart:async';
import 'package:blendit_2022/screens/news_comments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class blogPostWidget extends StatelessWidget {

  blogPostWidget ({required this.cardColor, required this.imageUrl,
    required this.blogPosts, required this.sender, required this.likes,
    required this.blogTitle, required this.blogId, required this.comments, required this.likers, required this.tokenID });

  final String sender; final String blogTitle; final String blogPosts; final String imageUrl;
  final Color cardColor; final String likes; final String blogId; final List comments;
  final List likers; final String tokenID;


  @override
  Future <dynamic> handleBlogLikes(docId) async{
    if (likers.contains(tokenID)){

    }else{
      return FirebaseFirestore.instance
          .collection('blogs')
          .doc(docId)
          .update({
        'likes': FieldValue.increment(1),
        'likers': FieldValue.arrayUnion([tokenID]),
      })
          .then((value) => print('Likes Updated'))
          .catchError((error) => print('Failed to update')
      );// //.update({'company':'Stokes and Sons'}
    }

  }

  Widget build(BuildContext context) {
    Timer _timer;
    animationTimer() {
      _timer = new Timer(const Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            ReadComments(prayerId: blogId, cardColor: cardColor, imageUrl: imageUrl, prayerTitle: blogTitle,comments: comments, likes: likes, prayerSender: sender, prayerRequests: blogPosts,),
        ),
        );


      },
      child: Container(
        //width: double.infinity,

        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 16, left:16, right: 16),
        decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              children: [
                //CupertinoSearchTextField(),
                Text("${sender} shared" , style: TextStyle(color: Colors.white),),
                SizedBox(width: 5,),
                Icon(Icons.family_restroom_sharp, size: 15, color: Colors.white,)
              ],
            ),

            Padding(padding: EdgeInsets.only(top:16),
              child:
              Row(
                children: [
                  Expanded(

                    flex:1,
                    child: Container(

                      //height: 100,
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 60,
                          width: 60,
                          child: Image.network(imageUrl, fit: BoxFit.cover,),

                        ),
                      ),

                    ), ),
                  Expanded(

                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child:
                        Column(
                          children: [
                            RichText(text: TextSpan(text: (blogPosts),
                                //style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                style: GoogleFonts.lato(fontSize: 16.8),
                                children: [
                                  //TextSpan(text: '\n30s ago', style: GoogleFonts.raviPrakash(), )
                                ]
                            ),),
                            SizedBox(height: 5,),
                            //_buildDivider(),
                          ],
                        ),

                      ))
                ],
              ),
            ),
            Row(children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    //SizedBox(height: 10,),
                    child: Text(blogTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(

                    margin: EdgeInsets.only(right:10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,


                      children: [
                        Text(likes,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
                            )),
                        SizedBox(width: 3,),

                        GestureDetector(
                            onTap: (){
                              animationTimer();
                              handleBlogLikes(blogId);


                              showCupertinoModalPopup(context: context, builder: (context) => Container(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                //color: Color(0xFF757575),
                                child: Lottie.asset('images/success.json',
                                    height: 200),
                              ));
                            },
                            child: Icon(CupertinoIcons.heart, color: Colors.white,size: 23,)),
                        SizedBox(width: 10,),
                        Text(comments.length.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
                            )),
                        SizedBox(width: 3,),
                        Icon(CupertinoIcons.text_bubble, color: Colors.white,size: 23,),

                      ],
                    ),
                  )),
            ],)
          ],
        ),
      ),
    );
  }
}



