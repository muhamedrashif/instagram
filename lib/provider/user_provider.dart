

import 'package:flutter/widgets.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods=AuthMethods();

//   User get getUser => _user!;

//   Future<void> rerfreshUser()async{
// User user =await _authMethods.getUserdetails();
// _user=user;
// notifyListeners();

//   }
  
   late User user;
  bool loading = false;

  rerfreshUser() async {
    loading = true;

    user = (await AuthMethods().getUserdetails());
    loading = false;

    notifyListeners();
  }
 
  }
  
