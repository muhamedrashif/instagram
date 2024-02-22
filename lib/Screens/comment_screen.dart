
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagram/resources/firestore_method.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  String uid=FirebaseAuth.instance.currentUser!.uid;
   CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // uu = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
              
                  CommentCard(snap: snapshot.data!.docs[index].data()));
                  
        },
      ),
      bottomNavigationBar: SafeArea(
        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
               .where('uid', isEqualTo: widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
             // var order = snapshot.data?.docs;

              return 
         Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                   snapshot.data?.docs[0]['photoUrl'],
                  //   'https://images.unsplash.com/photo-1691745034385-d5376238a97c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1fE04alZiTGJUUndzfHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=600&q=60'
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${ snapshot.data?.docs[0]['username']}',
                        // 'Comment as username',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                       widget.uid,
                        snapshot.data?.docs[0]['username'],
                        snapshot.data?.docs[0]['photoUrl'],
                      // widget.snap['uid'],
                      // widget.snap['username'],
                      // widget.snap['photoUrl']
                      );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        );
   } )
    ));
  }
}
