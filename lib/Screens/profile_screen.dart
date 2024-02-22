import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instagram/Screens/EditProfile_screen.dart';
import 'package:instagram/Screens/follow_screen.dart';
import 'package:instagram/Screens/following_screen.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/util/util.dart';

import 'package:instagram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final snap=FirebaseAuth.instance.currentUser!.uid;
   ProfileScreen({required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool _isLoading = false;


// follow


 Future<void> followUser(String snap, String uid) async {
  // Update the current user's following array
  FirebaseFirestore.instance.collection('user').doc(snap).update({
    'following': FieldValue.arrayUnion([uid]),
  });

  // Update the other user's followers array
  FirebaseFirestore.instance.collection('user').doc(uid).update({
    'followers': FieldValue.arrayUnion([snap]),
  });
}


//unfollow


Future<void> unfollowUser(String snap, String uid) async {
  // Update the current user's following array
  FirebaseFirestore.instance.collection('user').doc(snap).update({
    'following': FieldValue.arrayRemove([uid]),
  });

  // Update the other user's followers array
  FirebaseFirestore.instance.collection('users').doc(uid).update({
    'followers': FieldValue.arrayRemove([snap]),
  });
}




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();
      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']
                  //  'username'
                  ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          //  SizedBox(
                          //   width: 15,
                          // ),

                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(userData['photoUrl']
                                //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ4dZTTbipC2IaQGf7F_5Y16hmfulfFBAZ6A&usqp=CAU'
                                ),
                            radius: 40,
                          ),
                          Container(
                            //  color: Colors.white,
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Column(
                              children: [
                                Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        //  color: Colors.red,
                                        child: buildStateColumn(
                                            postLen,
                                            // 20,
                                            "posts")),
                                    InkWell(
                                      child: buildStateColumn(
                                          followers
                                          //189
                                          ,
                                          "followers"),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => FollowScreen(
                                              snap: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    InkWell(
                                      child: buildStateColumn(
                                        following
                                        // 13
                                        ,
                                        "following",
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FollowingScreen(
                                              snap: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        text: 'Edit Profile',
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: ()  {
                                        
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EditProfileScreen()));
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            text: 'Unfollow',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await 
                                                  unfollowUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);

                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            text: 'follow',
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              await followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          // 'username',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(userData['bio']
                            //  'Some description',
                            ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];

                          return Container(
                            child: Image(
                              image: NetworkImage(
                                  (snap.data()! as dynamic)['photoUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  },
                )
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
