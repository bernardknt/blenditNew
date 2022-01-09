
import 'package:blendit_2022/utilities/constants.dart';
import 'package:blendit_2022/widgets/blogPostWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class BlogPage extends StatefulWidget {
  static String id = 'blog_page';
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {

  final _random = new Random();
  var backgroundColors = [Colors.black, Colors.red.shade900, Colors.purpleAccent, Colors.deepPurple, Colors.green, Colors.indigoAccent];
  var blogPosts = [];
  var images = [];
  var blogTitles = [];
  var likes = [];
  var postLikers = [];
  var sender = [];
  var date= [];
  var blogId = [];
  var comments = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();


  Future<dynamic> getPosts() async {
    blogPosts = [];
    images = [];
    blogTitles = [];
    likes = [];
    sender = [];
    date= [];
    blogId = [];
    comments = [];
    //postLikers = [];

    final blenditBlogs = await FirebaseFirestore.instance
        .collection('blogs')
        .orderBy('time',descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        blogPosts.add(doc['blog']);
        blogTitles.add(doc['label']);
        sender.add(doc['sender']);
        images.add(doc['image']);
        likes.add(doc['likes']);
        date.add(doc['time']);
        blogId.add(doc['id']);
        comments.add(doc['comments']);
        postLikers.add(doc['likers']);
      });
      setState(() {
        //print(comments);
      });
    });
    return blenditBlogs ;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPrayers();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { _refreshIndicatorKey.currentState!.show();});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kBlueDarkColor,

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getPosts,
        child: Stack(
            children:[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('blogs').orderBy('time',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    blogPosts = [];
                    images = [];
                    blogTitles = [];
                    likes = [];
                    postLikers = [];
                    sender = [];
                    date= [];
                    blogId = [];
                    comments = [];
                    var blogs = snapshot.data!.docs;
                    for (var blog in blogs) {
                      sender.add(blog.get('sender'));
                      blogPosts.add(blog.get('blog'));
                      images.add(blog.get('image'));
                      blogId.add(blog.get('id'));
                      blogTitles.add(blog.get('label'));
                      comments.add(blog.get('comments'));
                      likes.add(blog.get('likes'));
                      postLikers.add(blog.get('likers'));
                      date.add(blog.get('time').toDate());
                      print('Some data');
                    }
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sender.length,
                      itemBuilder: (context, index){
                        return blogPostWidget(blogPosts: blogPosts[index],cardColor: backgroundColors[_random.nextInt(backgroundColors.length)]
                            ,
                            sender: sender[index],comments:comments[index] ,
                            blogTitle: blogTitles[index], imageUrl:images[index] , likes: likes[index].toString(),
                            blogId: blogId[index], likers: postLikers[index], tokenID: '',
                        );
                      });
                },
              ),
            ] ),
      ),
    );
  }
}

