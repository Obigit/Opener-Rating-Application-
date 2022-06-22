import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:opener/Authentications/SignupPage.dart';
import 'package:opener/Authentications/complete_reg.dart';
import 'package:opener/HomePage/home_page.dart';
import 'package:opener/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../BlurryDialogs/blurry_dialog.dart';
import '../BlurryDialogs/single_button_blurry_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
      FirebaseDatabase().reference().child("Users_Details");

  late String recoverPasswordTitle = "Recover Password";

  TextEditingController emailTC = TextEditingController(),
      passwordTC = TextEditingController();

  FocusNode emailAddressFN = FocusNode(), passwordFN = FocusNode();

  bool termsAccepted = false;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: kPrimaryPurple,
      appBar: AppBar(
        title: Text(
          "Login",
          style: GoogleFonts.quicksand(),
        ),
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF253177),
                  Color(0xFF890ed0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Container(
          // color: kPrimaryPurple,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF253177),
                  Color(0xFF890ed0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
              child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.all(12.0),
                child: Container(
                  margin: EdgeInsets.all(12.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Image.asset(
                        "images/ic_login_signup.png",
                        width: 170,
                        height: 170,
                      ),
                      topMargin(),
                      TextFormField(
                        style: GoogleFonts.quicksand(color: Colors.white),
                        controller: emailTC,
                        focusNode: emailAddressFN,
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          labelText: "youremail@example.com",
                          labelStyle: GoogleFonts.quicksand(
                            color: Colors.white,
                          ),
                          hintStyle: GoogleFonts.quicksand(color: Colors.white),
                          fillColor: Colors.white,
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(50),
                          //
                          //
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),

                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      topMargin(),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: passwordTC,
                        focusNode: passwordFN,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Enter your password",
                          labelStyle: GoogleFonts.quicksand(
                            color: Colors.white,
                          ),
                          hintStyle: GoogleFonts.quicksand(color: Colors.white),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            // add padding to adjust icon
                            child: Icon(
                              Icons.password_outlined,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.0),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: FlatButton(
                          onPressed: () {
                            _checkInternetConnectivityForForgotPassword(
                                emailTC.text, passwordTC.text);
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.quicksand(
                                fontSize: 13.0, color: Colors.white),
                          ),
                          textColor: kPrimaryLightColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        child: RaisedButton(
                          onPressed: () {
                            _checkInternetConnectivity(
                                emailTC.text, passwordTC.text);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.quicksand(),
                          ),
                          color: Colors.white,
                          textColor: kPrimaryColor,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                   /*   Container(
                        margin: EdgeInsets.only(top: 12.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          height: 45.0,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Image.asset(
                                  "images/ic_google.png",
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: FractionalOffset.center,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: const Text(
                                          "Login with Google",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          signInWithFacebook();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          height: 45.0,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Image.asset(
                                  "images/ic_fb.png",
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: FractionalOffset.center,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: const Text(
                                          "Login with Facebook",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                      ), */
                      topMargin(),
                      Container(
                        height: 30,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()));
                          },
                          child: Text(
                            "New user? Sign up here",
                            style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                          textColor: kPrimaryLightColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ))),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });

      if (user != null) {
        usersDetailsRef
            .child(user!.uid)
            .child("firstName")
            .once()
            .then((snapshot) {
          setState(() {
            if (snapshot.value != null) {
              /// Go to Home Page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              showNormalToastBottom("Login Successful");


            } else {
              /// Go to Home Page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompleteRegistration()));
            }
          });
        });
      } else {
        showNormalToastBottom("Canceled");
      }
    });
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .whenComplete(() {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });

      if (user != null) {
        usersDetailsRef
            .child(user!.uid)
            .child("firstName")
            .once()
            .then((snapshot) {
          setState(() {
            if (snapshot.value != null) {
              /// Go to Home Page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              showNormalToastBottom("Login Successful");


            } else {
              /// Go to Home Page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompleteRegistration()));
            }
          });
        });
      } else {
        showNormalToastBottom("Canceled");
      }
    });
  }

  void _checkInternetConnectivity(String emailAddress, String password) async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      noInternetConnectionDialog(context);
    } else {
      if (emailAddress == null || password == null) {
        showErrorToast("One or more fields are empty");
      } else if (password.length < 6) {
        showErrorToast("Minimum of 6 characters is required for the password");
      } else {
        Loader.show(context,
            progressIndicator: const LinearProgressIndicator(
              color: kPrimaryColor,
            ));


        firebaseAuth
            .signInWithEmailAndPassword(email: emailAddress, password: password)
            .catchError((err) {
          Loader.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content:
                  const Text("Incorrect email and password combination"),
                  actions: [
                    FlatButton(
                      child: const Text("Okay, Thanks!"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }).then((value) => checkIfUserExist());
      }
    }
  }

  checkIfUserExist() {
    if (FirebaseAuth.instance.currentUser != null) {
      usersDetailsRef
          .child(firebaseAuth.currentUser!.uid)
          .child("userId")
          .once()
          .then((snapshot) {
        setState(() {
          if (snapshot.value != null) {
            /// Go to Home Page
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            showNormalToastBottom("Login Successful");
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CompleteRegistration()));
          }
        });
      });
    } else {
      Loader.hide();
      showErrorToast("Error: Incorrect email and password combination");
    }
  }

  void _checkInternetConnectivityForForgotPassword(
      String emailAddress, String password) async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      noInternetConnectionDialog(context);
    } else {
      if (emailAddress == null || !emailAddress.contains("@")) {
        showErrorToast("Please enter your email address to proceed");
      } else {
        showBlurryDialog(context);
      }
    }
  }

  showBlurryDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
          // code on continue comes here

          firebaseAuth
              .sendPasswordResetEmail(email: emailTC.text)
              .whenComplete(() {
            Navigator.of(context).pop();
            showSingleBtnBlurryDialog(context);
          })
        };

    String emailAddress = emailTC.text;
    BlurryDialog alert = BlurryDialog(
        recoverPasswordTitle,
        "Email: $emailAddress\nWe'll send you a recovery email shortly. Proceed?",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSingleBtnBlurryDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };
    SingleBtnBlurryDialog alert = SingleBtnBlurryDialog(
        "Sent",
        "Please check your email. We just sent you a password recovery link.",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  noInternetConnectionDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };
    SingleBtnBlurryDialog alert = SingleBtnBlurryDialog(
        "No Internet Connection",
        "Oops! It seems you're not connected to the internet. Please kindly check your internet connection and try again.",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryLightColor);
  }

  showNormalToastBottom(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor);
  }

  Widget topMargin() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }
}

////// Resource class /////
