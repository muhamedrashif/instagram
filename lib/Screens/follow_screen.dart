import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/widgets/following_card.dart';

class FollowScreen extends StatefulWidget {
  final snap;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FollowScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
//   var userData = {};
//  List followers=[];

//   bool _isLoading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }

//   getData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       var userSnap = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(widget.snap['uid'])
//           .get();

//        userData = userSnap.data()!;
//        followers = userSnap.data()!['followers'];
//       // following = userSnap.data()!['following'].length;
//       // isFollowing = userSnap
//       //     .data()!['followers']
//       //     .contains(FirebaseAuth.instance.currentUser!.uid);
//       setState(() {});
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }
  @override
  Widget build(BuildContext context) {
    // uu = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(widget.snap['username']),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.snap['uid'])
            .collection('followers')
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
                  FollowingCard(snap: snapshot.data!.docs[index].data()));
          // ListView.builder(
          //     itemCount: userData.length,
          //     itemBuilder: (context, index) =>
          //         FollowingCard(snap: userSnap.data()!['followers'].data()));
        },
      ),
    );
  }
}
// StreamBuilder<DocumentSnapshot>(
//   stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return CircularProgressIndicator(); // Loading indicator while fetching data
//     }

//     var userData = snapshot.data.data();
//     List<String> following = userData['following'];
//     List<String> followers = userData['followers'];

//     return Column(
//       children: [
//         Text('Following (${following.length})'),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: following.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(following[index]),
//               // Add any additional UI elements you want here
//             );
//           },
//         ),
//         Text('Followers (${followers.length})'),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: followers.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(followers[index]),
//               // Add any additional UI elements you want here
//             );
//           },
//         ),
//       ],
//     );
//   },
// )