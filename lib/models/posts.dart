import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String photoUrl;
  final String postId;
  final datePublished;
  final String profImage;
  final comments;
  final likes;
  const Post(
      {required this.description,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.datePublished,
      required this.postId,
      required this.profImage,
      required this.comments,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "photoUrl": photoUrl,
        "datePublished": datePublished,
        "postId": postId,
        "profImage": profImage,
        "comments": comments,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        description: snapshot['description'],
        photoUrl: snapshot['photoUrl'],
        datePublished: snapshot['datePublished'],
        postId: snapshot['postId'],
        profImage: snapshot['profImage'],
        comments: snapshot['comments'],
        likes: snapshot['likes ']);
  }
}
