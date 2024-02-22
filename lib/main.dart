//https://github.com/RivaanRanawat/instagram-flutter-clone

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/login_screen.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'responsive/mobile_screen_layout.dart';
import 'responsive/web_screen_layout.dart';
import 'util/colors.dart';
import 'package:flutter/services.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();

   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  //  DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    
      providers: [ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
              }
              return const LoginScreen();
            },
          )),
    );
  }
}
