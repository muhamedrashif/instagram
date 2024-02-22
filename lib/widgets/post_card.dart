
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/comment_screen.dart';
import 'package:instagram/Screens/like_screen.dart';
import 'package:instagram/Screens/profile_screen.dart';
import 'package:instagram/Screens/view_comment_screen.dart';
import 'package:instagram/resources/firestore_method.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/util/util.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
      var comments = snap.docs.toString();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final User user =provider.of<UserProvider>(context).getUser();
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snap) {
          //  var order = snap.data?.docs;
          return Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //      color: width>webScreensize?secondaryColor:mobileBackgroundColor,
            //   )
            // ),
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          widget.snap['profImage'],
                          //   uu.user.photoUrl,
                          // 'https://images.unsplash.com/photo-1690687067446-00f9300bbf9b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDR8YWV1NnJMLWo2ZXd8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                child: Text(
                                  widget.snap['username'],
                                  // uu.user.username,
                                  //  snap['username'],
                              
                                  //   'username',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                                 onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                     uid:widget.snap['uid'] ,
                                    )));
                          },
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          
                        },
                          // onPressed: () {
                          //   showDialog(
                          //       context: context,
                          //       builder: (context) => Dialog(
                          //             child: ListView(
                          //               padding: const EdgeInsets.symmetric(
                          //                   vertical: 16),
                          //               shrinkWrap: true,
                          //               children: [
                          //                 'Delete',
                          //               ]
                          //                   .map((e) => InkWell(
                          //                         onTap: () async {
                          //                           FirestoreMethods()
                          //                               .deletePost(widget
                          //                                   .snap['postId']);
                          //                           Navigator.of(context).pop();
                          //                         },
                          //                         child: Container(
                          //                           padding: const EdgeInsets
                          //                                   .symmetric(
                          //                               vertical: 12,
                          //                               horizontal: 16),
                          //                           child: Text(e),
                          //                         ),
                          //                       ))
                          //                   .toList(),
                          //             ),
                          //           ));
                          // },
                          icon: const Icon(Icons.more_vert))
                    ],
                  ),
                ),

                // Image Section
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'],
                        widget.uid, widget.snap['likes']);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['photoUrl'],
                          //   uu.user.photoUrl,
                          // snap['postUrl'],

                          // 'https://plus.unsplash.com/premium_photo-1681245769078-c9f9d6d3bdfd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwbHVzLWZlZWR8NTl8fHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=600&q=60',
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 100,
                          ),
                          isAnimation: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),

                // Like Comment Section
                Row(
                  children: [
                    LikeAnimation(
                      isAnimation: widget.snap['likes'].contains(
                        widget.uid,
                      ),
                      smallLike: true,
                      child: IconButton(
                          onPressed: () async {
                            await FirestoreMethods().likePost(
                                widget.snap['postId'],
                                widget.uid,
                                widget.snap['likes']);
                          },
                          icon: widget.snap['likes'].contains(
                            widget.uid,
                          )
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border)),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    snap: widget.snap,
                                  )));
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                        )),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_border)),
                    ))
                  ],
                ),
                // Description and Number of Comments
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: TextButton(
                          child: Text(
                            'View ${widget.snap['likes'].length} likes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          // 'View $likeLen likes',
                          // //  '1,834 likes',
                          // style: Theme.of(context).textTheme.bodyText2,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LikeScreen(
                                      snap: widget.snap,
                                    )));
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: RichText(
                          text: TextSpan(
                              style: const TextStyle(color: primaryColor),
                              children: [
                                TextSpan(
                                    text: widget.snap['username'],
                                    //    snap['username'],

                                    //   'username',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                  text: ' ${widget.snap['description']}',

                                  //  ' Hey this is some description to be replaced'
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => CommentScreen(
                          //           snap: FirebaseFirestore.instance
                          //               .collection('posts')
                          //                .doc(widget.snap['comments'])
                          //               .get()
                          //               ,
                          //         )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextButton(
                            child: Text(
                              'View all $commentLen comments',
                              // 'View all 200 comments',
                              style: const TextStyle(
                                  fontSize: 16, color: secondaryColor),
                            ),
                             onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewCommentScreen(
                                      snap: widget.snap,
                                    )));
                          },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          //       '16/8/2023',
                          style: const TextStyle(
                              fontSize: 14, color: secondaryColor),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
