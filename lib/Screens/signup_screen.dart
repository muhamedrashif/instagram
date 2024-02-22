import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/util/colors.dart';
import 'package:instagram/util/util.dart';
import 'package:instagram/widgets/text_field_input.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(res, context);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'asset/fonts/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign up',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}






















// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:instagram/resources/auth_methods.dart';
// import 'package:instagram/responsive/mobile_screen_layout.dart';
// import 'package:instagram/responsive/responsive_layout.dart';
// import 'package:instagram/responsive/web_screen_layout.dart';
// import 'package:instagram/util/colors.dart';
// import 'package:instagram/util/util.dart';
// import 'package:instagram/widgets/text_field_input.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final TextEditingController _bioController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   Uint8List? _image;
//   bool _isLoading = false;
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _bioController.dispose();
//     _usernameController.dispose();
//   }

//   void selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = im;
//     });
//   }

//   void signUpUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     String res = await AuthMethods().signUpUser(
//         email: _emailController.text,
//         password: _passwordController.text,
//         username: _usernameController.text,
//         bio: _bioController.text,
//         file: _image!);
//     setState(() {
//       _isLoading = false;
//     });
//     if (res != 'success') {
//       showSnackBar(res, context);
//     } else {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const ResponsiveLayout(
//               webScreenLayout: WebScreenLayout(),
//               mobileScreenLayout: MobileScreenLayout())));
//     }
//   }

//   void navigateToLogin() {
//     Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const SignupScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 32),
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Flexible(
//               child: Container(),
//               flex: 21,
//             ),
//             // svg image
//             SvgPicture.asset(
//               "asset/fonts/ic_instagram.svg",
//               color: primaryColor,
//               height: 64,
//             ),
//             const SizedBox(
//               height: 64,
//             ),
//             // circular widget to accept and selected file
//             Stack(
//               children: [
//                 _image != null
//                     ? CircleAvatar(
//                         radius: 64,
//                         backgroundImage: MemoryImage(_image!),
//                       )
//                     : CircleAvatar(
//                         radius: 64,
//                         backgroundImage: AssetImage("asset/fonts/profile.jpg"),
//                       ),
//                 Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: IconButton(
//                         onPressed: selectImage,
//                         icon: const Icon(
//                           Icons.add_a_photo,
//                           //color: Colors.white,
//                         )))
//               ],
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             // text field input for username
//             TextFieldInput(
//                 textEditingController: _usernameController,
//                 hintText: 'Enter your username',
//                 textInputType: TextInputType.text),
//             const SizedBox(
//               height: 24,
//             ),
//             // text field input for eamil
//             TextFieldInput(
//                 textEditingController: _emailController,
//                 hintText: 'Enter your email',
//                 textInputType: TextInputType.emailAddress),
//             const SizedBox(
//               height: 24,
//             ),
//             // text feild input for password
//             TextFieldInput(
//               textEditingController: _passwordController,
//               hintText: 'Enter your password',
//               textInputType: TextInputType.text,
//               isPass: true,
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             // text field input for bio
//             TextFieldInput(
//                 textEditingController: _bioController,
//                 hintText: 'Enter your bio',
//                 textInputType: TextInputType.text),
//             const SizedBox(
//               height: 24,
//             ),
//             // button login
//             InkWell(
//               onTap:
//                 signUpUser,
//               child: Container(
//                 child: _isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: primaryColor,
//                         ),
//                       )
//                     : const Text('Sign up'),
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: const ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                       Radius.circular(4),
//                     )),
//                     color: blueColor),
//               ),
//             ),
//             Flexible(
//               child: Container(),
//               flex: 2,
//             ),
//             // transilationing to singing up
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   child: const Text("Don't have an account?"),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                 ),
//                 GestureDetector(
//                   onTap: navigateToLogin,
//                   child: Container(
//                     child: const Text(
//                       "Log in.",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }
