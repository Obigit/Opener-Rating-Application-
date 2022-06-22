import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/PoliceOfficers/police_officers_page.dart';
import 'package:opener/PoliceStations/police_stations_page.dart';

import 'package:opener/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Authentications/LoginPage.dart';
import '../BlurryDialogs/signout_blurry_dialog.dart';
import '../UserProfile/user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
      FirebaseDatabase().reference().child("Users_Details");

  late TabController _tabController;

  late String firstNameFromFirebase = "",
      lastNameFromFirebase,
      userNameFromFirebase,
      avatarFromFirebase = "",
      nationalIdFromFirebase,
      addressFromFirebase,
      postCodeFromFirebase,
      districtFromFirebase,
      stateFromFirebase;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    fetchUsersDetailsFromFirebase();
    super.initState();
  }

  fetchUsersDetailsFromFirebase() {
    /// Fetch First name from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("firstName")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          firstNameFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch Last name from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("lastName")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          lastNameFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch user avatar from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("avatar")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          avatarFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch User name from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("userName")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          userNameFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch National Id  from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("nationalId")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          nationalIdFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch Address from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("address")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          addressFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch post code from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("postCode")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          postCodeFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch district from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("district")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          districtFromFirebase = snapshot.value;
        }
      });
    });

    /// Fetch state from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("state")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          stateFromFirebase = snapshot.value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          greeting() + ", $firstNameFromFirebase",
          style: GoogleFonts.gruppo(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryColor,
        bottom: TabBar(
            //  controller: controller,

            controller: _tabController,
            indicatorColor: Colors.grey,
            //  indicatorColor: kPrimaryColor,
            //  labelColor: kPrimaryColor,
            tabs: const <Tab>[
              Tab(
                text: "Police Stations",
              ),
              Tab(
                text: "Officers on Duty",
                // unreadChatsCount != 0
                //     ? "Chats ($unreadChatsCount)"
                //     : "Chats",
              )
            ]),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                          firstNameFromFirebase,
                          lastNameFromFirebase,
                          avatarFromFirebase,
                          userNameFromFirebase,
                          nationalIdFromFirebase,
                          addressFromFirebase,
                          postCodeFromFirebase,
                          districtFromFirebase,
                          stateFromFirebase)));
            },
            child: avatarFromFirebase != ""
                ? CircleAvatar(
                    backgroundColor: Color(0xFFCBB6E9),
                    radius: 20,
                    backgroundImage: NetworkImage(avatarFromFirebase),
                  )
                : Image.asset(
                    "images/ic_default_avatar.png",
                    width: 40,
                    height: 40,
                  ),
          ),

          Container(
            margin: EdgeInsets.only(right: 10),
          )

          // IconButton(onPressed: (){
          //
          //   showBlurryDialog(context);
          //
          //   // FirebaseAuth.instance.signOut().then((value) {
          //   //
          //   //   Navigator.of(context).popUntil((route) => route.isFirst);
          //   //   Navigator.pushReplacement(context,
          //   //       MaterialPageRoute(builder: (context) => LoginPage()));
          //   //
          //   //
          //   //
          //   // });
          // }, icon: Icon(Icons.logout_outlined))
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   heroTag: null,
      //   onPressed: () {},
      //   label: Text('Emergency',listl
      //     style: GoogleFonts.quicksand(
      //
      //       color: Colors.black
      //     ),
      //
      //   ),
      //  // icon: Icon(Icons.call_outlined),
      //   backgroundColor: Colors.transparent,
      // ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Container(
                    //  color: kPrimaryPurple,
                    child: Center(
                        child: Image.asset(
              "images/ic_drawer_header.png",
              width: 250,
              height: 250,
            )))),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              title: Text(
                "Home",
                style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.home_outlined,
                color: kPrimaryColor,
              ),
            ),
            ListTile(
              onTap: () {
                sendEmailToForReportIssues("openersec@gmail.com");
              },
              title: Text(
                "Report an Issue",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              leading: Icon(Icons.report_problem_outlined),
            ),
            ListTile(
              onTap: () {
                showNormalToastBottom("Opener v1.0");
              },
              title: Text(
                "About",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              leading: Icon(Icons.info_outline),
            ),
            ListTile(
              onTap: () {
                showNormalToastBottom("Kindly email us at openersec@gmail.com");
              },
              title: Text(
                "Help",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              leading: Icon(Icons.help_outline),
            ),
            ListTile(
              onTap: () {
                showBlurryDialog(context);
              },
              title: Text(
                "Logout",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              leading: Icon(Icons.logout_outlined),
            ),
            ListTile(
              onTap: () {
                showNormalToastBottom("Call: +234 803 2003 913 or +234 705 7337 653");
              },
              title: Text(
                "Emergency",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              leading: Icon(Icons.call_outlined),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[PoliceStationsPage(), PoliceOfficersPage()]),
          ),
          // TODO: Display a banner when ready
          // ignore: sdk_version_ui_as_code
        ],
      )),
    );
  }

  showBlurryDialog(BuildContext context) {
    // ignore: sdk_version_set_literal
    VoidCallback continueCallBack = () {
      // code on continue comes here

      FirebaseAuth.instance.signOut().whenComplete(() {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));

        showNormalToastBottom("Sign out successful");
      });

      Navigator.of(context).pop();
    };
    SignoutBlurryDialog alert = SignoutBlurryDialog(
        "Sign out", "Are you sure you want to sign out now?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  sendEmailToForReportIssues(String emailAddress) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        queryParameters: {'subject': 'I WANT TO REPORT AN ISSUE', 'body': ""});
    launch(_emailLaunchUri.toString());
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
}
