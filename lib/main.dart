import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opener/Authentications/SignupPage.dart';
import 'package:opener/Authentications/complete_reg.dart';
import 'package:opener/HomePage/home_page.dart';

import 'Authentications/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Opener());
}

class Opener extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return showPage(HomePage());
    } else {
      return showPage(LoginPage());
    }
  }

  Widget showPage(Widget widget) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget,

    );
  }
}
