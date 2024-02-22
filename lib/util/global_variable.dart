import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/add_post_screen.dart';
import 'package:instagram/Screens/feed_screen.dart';
import 'package:instagram/Screens/current_profile_screen.dart';
import 'package:instagram/Screens/search_screen.dart';

const webScreensize = 600;

final homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  Text(
    "Notofication",
  ),
  CurretProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
