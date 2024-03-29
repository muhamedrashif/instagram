

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/firestore_method.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/util/util.dart';
import 'dart:typed_data';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   _AddPostScreenState createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   _selectImage(BuildContext parentContext) async {
//     return showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Take a photo'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Uint8List file = await pickImage(ImageSource.camera);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Choose from Gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   Uint8List file = await pickImage(ImageSource.gallery);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   // void postImage(String uid, String username, String profImage) async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   // start the loading
//   //   try {
//   //     // upload to storage and db
//   //     String res = await FireStoreMethods().uploadPost(
//   //       _descriptionController.text,
//   //       _file!,
//   //       uid,
//   //       username,
//   //       profImage,
//   //     );
//   //     if (res == "success") {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       if (context.mounted) {
//   //         showSnackBar(
//   //           context,
//   //           'Posted!',
//   //         );
//   //       }
//   //       clearImage();
//   //     } else {
//   //       if (context.mounted) {
//   //         showSnackBar(res, context);
//   //       }
//   //     }
//   //   } catch (err) {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     showSnackBar(
//   //       context,
//   //       err.toString(),
//   //     );
//   //   }
//   // }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserProvider userProvider = Provider.of<UserProvider>(context);

//     return _file == null
//         ? Center(
//             child: IconButton(
//               icon: const Icon(
//                 Icons.upload,
//               ),
//               onPressed: () => _selectImage(context),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: mobileBackgroundColor,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: clearImage,
//               ),
//               title: const Text(
//                 'Post to',
//               ),
//               centerTitle: false,
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {},
//                   // postImage(
//                   //   userProvider.getUser.uid,
//                   //   userProvider.getUser.username,
//                   //   userProvider.getUser.photoUrl,
//                   // ),
//                   child: const Text(
//                     "Post",
//                     style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0),
//                   ),
//                 )
//               ],
//             ),
//             // POST FORM
//             body: Column(
//               children: <Widget>[
//                 isLoading
//                     ? const LinearProgressIndicator()
//                     : const Padding(padding: EdgeInsets.only(top: 0.0)),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         userProvider.getUser.photoUrl,
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: TextField(
//                         controller: _descriptionController,
//                         decoration: const InputDecoration(
//                             hintText: "Write a caption...",
//                             border: InputBorder.none),
//                         maxLines: 8,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 45.0,
//                       width: 45.0,
//                       child: AspectRatio(
//                         aspectRatio: 487 / 451,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage(_file!),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//               ],
//             ),
//           );
//   }
// }

class AddPostScreen extends StatefulWidget {
  final uid;
  AddPostScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => _selectImage(context),
                icon: Icon(Icons.upload)),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .where('uid', isEqualTo: widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
            //  var order = snapshot.data?.docs;

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: clearImage,
                  ),
                  title: const Text(
                    'Post to',
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => postImage(
                        // snapshot.data?.docs[0][''],
                        widget.uid,
                        snapshot.data?.docs[0]['username'],
                        snapshot.data?.docs[0]['photoUrl'],
                        // userProvider.getUser.uid,
                        // userProvider.getUser.username,
                        // userProvider.getUser.photoUrl,
                      ),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(padding: EdgeInsets.only(top: 0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data?.docs[0]['photoUrl'],
                            //   'https://plus.unsplash.com/premium_photo-1671308540338-cb3d66f569c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=60'
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                            ),
                            maxLines: 8,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  // image:
                                  // NetworkImage(
                                  //     'https://plus.unsplash.com/premium_photo-1671308540338-cb3d66f569c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
                                  //      DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    )
                  ],
                ),
              );
            });
  }
}
