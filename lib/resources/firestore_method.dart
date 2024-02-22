import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/posts.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          photoUrl: photoUrl,
          username: username,
          datePublished: DateTime.now(),
          postId: postId,
          profImage: profImage,
          comments: [],
          likes: []
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
// post likes

//  Future<void> likepost(String postId, String like, String uid, String name,
//       String profilePic) async {
//     try {
//       if (like.isNotEmpty) {
//         String likeId = const Uuid().v1();
//         await _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('likes')
//             .doc(likeId)
//             .set({
//           'profilePic': profilePic,
//           'name': name,
//           'uid': uid,
//           'like': like,
//           'likeId': likeId,
//           'datePublished': DateTime.now(),
//         });
//       } else {
//         print('Text is empty');
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      //    DocumentSnapshot snap =
      //     await _firestore.collection('posts').doc(uid).get();
      // List likes = (snap.data() as dynamic)['likes'];


      // log(likes.length.toString());

      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
// post comments
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

 // Delete comment

  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
// // Follow a user
// Future<void> followUser(String uid,String ) async {
//   // Update the current user's following list
//   FirebaseFirestore.instance.collection('user').doc(uid).update({
//     'following': FieldValue.arrayUnion([uid]),
//   });

//   // Update the other user's followers list
//   FirebaseFirestore.instance.collection('user').doc(uid).update({
//     'followers': FieldValue.arrayUnion([uid]),
//   });
// }



// // Unfollow a user
// Future <void> unfollowUser(String uid, userData) async {
//   // Update the current user's following list
//   FirebaseFirestore.instance.collection('user').doc(uid).update({
//     'following': FieldValue.arrayRemove([uid]),
//   });

//   // Update the other user's followers list
//   FirebaseFirestore.instance.collection('user').doc(uid).update({
//     'followers': FieldValue.arrayRemove([uid]),
//   });
// }


  // Future<void> followUser(String uid, String followId) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('user').doc(uid).get();
  //     List following = (snap.data() as dynamic)['following'];

  //     if (following.contains(followId)) {
  //       await _firestore.collection('user').doc(followId).update({
  //         'following': FieldValue.arrayRemove([uid])
  //       });
  //       await _firestore.collection('user').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('user').doc(followId).update({
  //         'following': FieldValue.arrayUnion([uid])
  //       });
  //       await _firestore.collection('user').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //  Future<void> followerUser(String uid, String followId) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('user').doc(uid).get();
  //     List follower = (snap.data() as dynamic)['follower'];

  //     if (follower.contains(followId)) {
  //       await _firestore.collection('user').doc(followId).update({
  //         'following': FieldValue.arrayRemove([uid])
  //       });
  //       await _firestore.collection('user').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('user').doc(followId).update({
  //         'following': FieldValue.arrayUnion([uid])
  //       });
  //       await _firestore.collection('user').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
