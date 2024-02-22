
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FollowingCard extends StatefulWidget {
  final snap;
  const FollowingCard({
    Key? key,
    required this.snap,
  }) : super(key: key);
  @override
  @override
  State<FollowingCard> createState() => _FollowingCardState();
}

class _FollowingCardState extends State<FollowingCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: widget.snap['uid'])
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //   var order = snapshot.data?.docs;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    // uu.user.photoUrl,
                    widget.snap['profilePic'],

                    // 'https://plus.unsplash.com/premium_photo-1681245141314-fb0b76bf164e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwbHVzLWZlZWR8NzF8fHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=600&q=60'
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: ' ${widget.snap['name']}',
                                // 'username',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                           
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd()
                                .format(widget.snap['datePublished'].toDate()),
                            // '17/08/2023',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
               
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.messenger_outline,
                    size: 16,
                  ),
                )
              ],
            ),
          );
        });
  }
}
