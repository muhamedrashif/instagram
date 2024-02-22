import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/widgets/like_card.dart';

class LikeScreen extends StatefulWidget {
  final snap;
 final uid=FirebaseAuth.instance.currentUser!.uid; 
  LikeScreen({Key? key,required this.snap}) : super(key: key);
    
  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
//  // Reference to the Firestore instance
//    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// List<dynamic> data = [];

     
//    Future<void> fetchData() async {
//      try {
//        // Reference to the document containing the array
//        DocumentReference docRef = _firestore.collection('posts').doc(widget.snap['likes']);

//        // Get the document snapshot
//        DocumentSnapshot docSnapshot = await docRef.get();

//        // Check if the document exists
//        if (docSnapshot.exists) {
//          // Access the array field
//          List<dynamic> yourArray = docSnapshot.get(widget.snap['likes']);
         
//          // Now, you can work with the array data
//          print(yourArray);
//        } else {
//          print('Document does not exist');
//        }

//  } catch (e) {
//        print('Error fetching data: $e');
//      }
//    }
// @override
//      void initState() {
//        super.initState();
//        fetchData().then((arrayData) {
//          setState(() {
//            data = yourArray;
//          });
//        });
//      }

  @override
  Widget build(BuildContext context) {
    // uu = Provider.of<UserProvider>(context, listen: false);
log("message"+widget.snap["postId"]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Likes'),
        centerTitle: false,
      ),
      body:
       StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('likes')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            log(snapshot.data!.docs.length.toString());
          }
          return
          
        //   ListView.builder(
        //    itemCount: data.length,
        //    itemBuilder: (context, index) {
        //      return ListTile(
        //        title: Text(data[index].toString()),
        //        // You can customize the list item here
        //      );
        //    },
        //  ),

          
          
           ListView.builder(
            
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
              
                LikeCard(snap: snapshot.data!.docs[index].data()));
                  
        },
      ),
  
  );
  }

}
