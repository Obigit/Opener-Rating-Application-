import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'BlurryDialogs/single_button_blurry_dialog.dart';

import 'constants.dart';

class NoInternetConnection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoInternetConnectionState();
  }
}

class NoInternetConnectionState extends State<NoInternetConnection> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference versionsRef =
      FirebaseDatabase().reference().child("Versions");

  bool currentVersionActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4_outlined,
              size: 80.0,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0),
            ),
            Text(
              "You're not connected to the internet. Please check your internet connection and try again.",
              style: TextStyle(fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
            ),
            RaisedButton(
              onPressed: () {
                _checkInternetConnectivity();
              },
              child: Text(
                "TRY AGAIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              color: Color(0xFF6f35a8),
              shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6f35a8)),
                  borderRadius: BorderRadius.circular(13.0)),
            ),
          ],
        ),
      ),
    );
  }

  noInternetConnectionDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };
    SingleBtnBlurryDialog alert = SingleBtnBlurryDialog(
        "No Internet Connection",
        "Oops! You're still not connected to the internet yet. Please kindly check your internet connection and try again.",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      noInternetConnectionDialog(context);
     }
      // else {
    //   versionsRef
    //       // .child(NumberToWord().convert('en-in', int.parse(versionCode)))
    //       .child(versionCode)
    //       .once()
    //       .then((snapshot) {
    //     if (snapshot.value != null) {
    //       currentVersionActive = snapshot.value;
    //
    //       showNormalToastBottom("Checking...");
    //
    //       if (currentVersionActive == true) {
    //         Navigator.of(context).popUntil((route) => route.isFirst);
    //         Navigator.pushReplacement(
    //             context, MaterialPageRoute(builder: (context) => HomePage()));
    //       } else {
    //         Navigator.of(context).popUntil((route) => route.isFirst);
    //         Navigator.pushReplacement(context,
    //             MaterialPageRoute(builder: (context) => Versionoutdated()));
    //       }
    //     }
    //   });
    // }
  }

  showNormalToastBottom(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF6f35a8));
  }
}
