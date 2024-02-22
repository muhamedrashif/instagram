import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/util/global_variable.dart';
import 'package:instagram/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
       width > webScreensize
          ? null
          : 
          AppBar(
              backgroundColor: width > webScreensize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                "asset/fonts/ic_instagram.svg",
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.messenger_outline)),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
             Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreensize ? width * 0.3 : 0,
                vertical: width > webScreensize ? 15 : 0,
              ),
              child:
               PostCard(snap: snapshot.data!.docs[index].data()),
            ),
          );
        },
      ),
    );
  }
}
