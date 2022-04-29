import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/PoliceOfficers/police_officers_details.dart';
import 'package:opener/PoliceStations/police_station_details.dart';
import 'package:opener/constants.dart';
import 'package:opener/models/police_officers.dart';
import 'package:opener/models/police_stations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliceOfficersPage extends StatefulWidget {
  @override
  State<PoliceOfficersPage> createState() => PoliceOfficersPageState();
}

class PoliceOfficersPageState extends State<PoliceOfficersPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
          FirebaseDatabase().reference().child("Users_Details"),
      stationsRef = FirebaseDatabase().reference().child("Police_Stations"),
      officersDetailsRef =
          FirebaseDatabase().reference().child("Officers_Details");

  List<PoliceOfficers> policeOfficersLists = [];
  late PoliceOfficers policeOfficers;

  late String firstNameFromFirebase = "",
      lastNameFromFirebase = "",
      currentUserDistrict = "",
      searchedText = "";

  bool sortPosts = false;

  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    usersDetailsRef.keepSynced(true);
    stationsRef.keepSynced(true);
    officersDetailsRef.keepSynced(true);

    fetchUsersDetails();

    /// Fetch Current user District

    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("district")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          currentUserDistrict = snapshot.value;

          sortPosts == true
              ? searchForOfficer(searchedText)
              : fetchOfficersOnDuty(currentUserDistrict);
        }
      });
    });

    super.initState();
  }

  fetchOfficersOnDuty(String currentUserDistrict) {
    officersDetailsRef
        .orderByChild("district")
        .startAt(searchedText)
        .endAt(searchedText + "\uf8ff")
        .onValue
        .listen((event) {
      var KEYS = event.snapshot.value.keys;
      var DATA = event.snapshot.value;

      policeOfficersLists.clear();

      for (var individualKey in KEYS) {
        policeOfficers = PoliceOfficers(
          DATA[individualKey]["userId"],
          DATA[individualKey]["firstName"],
          DATA[individualKey]["lastName"],
          DATA[individualKey]["emailAddress"],
          DATA[individualKey]["avatar"],
          DATA[individualKey]["address"],
          DATA[individualKey]["badgeId"],
          DATA[individualKey]["phoneNumber"],
          DATA[individualKey]["vehicleNumber"],
          DATA[individualKey]["licencePlateNumber"],
          DATA[individualKey]["state"],
          DATA[individualKey]["district"],
          DATA[individualKey]["station"],
          DATA[individualKey]["totalRatings"],
          DATA[individualKey]["totalRaters"],
          DATA[individualKey]["onDuty"],
        );

        //  postsList.add(posts);
        setState(() {
          policeOfficersLists.insert(0, policeOfficers);
        });
      }
    });
  }

  fetchUsersDetails() {
    /// Fetch first name from firebase

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

    /// Fetch lastName from firebase

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        addSearch(),
        policeOfficersLists.length == 0
            ? Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Text(
                    "No available officers to show within your district or the system is fetching the officers from the server",
                    // "Loading...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ))
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: policeOfficersLists.length,
                itemBuilder: (BuildContext context, int index) {
                  return OfficersUI(
                    policeOfficersLists[index].userId,
                    policeOfficersLists[index].firstName,
                    policeOfficersLists[index].lastName,
                    policeOfficersLists[index].emailAddress,
                    policeOfficersLists[index].avatar,
                    policeOfficersLists[index].address,
                    policeOfficersLists[index].badgeId,
                    policeOfficersLists[index].phoneNumber,
                    policeOfficersLists[index].vehicleNumber,
                    policeOfficersLists[index].licencePlateNumber,
                    policeOfficersLists[index].state,
                    policeOfficersLists[index].district,
                    policeOfficersLists[index].station,
                    policeOfficersLists[index].totalRatings,
                    policeOfficersLists[index].totalRaters,
                    policeOfficersLists[index].onDuty,
                  );
                },
              ),
      ],
    )));
  }

  Widget addSearch() {
    return Container(
        width: double.infinity,
        height: 54.0,
        child: GestureDetector(
          onTap: () => searchFocusNode.requestFocus(),
          child: Card(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
                borderSide: const BorderSide(color: Colors.transparent)),
            //  color: const Color(0xFF282444),
            child: Container(
                margin: const EdgeInsets.only(
                    top: 7.0, left: 30.0, right: 10.0, bottom: 7.0),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 15.0, right: 10),
                            child: TextFormField(
                              focusNode: searchFocusNode,
                              onChanged: (searchedText) {
                                setState(() {
                                  searchedText = searchedText;
                                  sortPosts = true;
                                  searchForOfficer(searchedText.toLowerCase());

                                  // showNormalToastBottom(
                                  //     "Searching For: $searchedText");
                                });
                              },
                              style:
                                  GoogleFonts.quicksand(color: kPrimaryColor),
                              decoration: const InputDecoration(
                                hintText: "Search by Station Name",
                                hintStyle: TextStyle(color: kPrimaryLightColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: kPrimaryLightColor),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            )),
                      ),
                      const Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  searchForOfficer(String searchedText) {
    officersDetailsRef
        .orderByChild("firstName")
        .startAt(searchedText)
        .endAt(searchedText + "\uf8ff")
        .onValue
        .listen((event) {
      var KEYS = event.snapshot.value.keys;
      var DATA = event.snapshot.value;

      policeOfficersLists.clear();

      for (var individualKey in KEYS) {
        policeOfficers = PoliceOfficers(
          DATA[individualKey]["userId"],
          DATA[individualKey]["firstName"],
          DATA[individualKey]["lastName"],
          DATA[individualKey]["emailAddress"],
          DATA[individualKey]["avatar"],
          DATA[individualKey]["address"],
          DATA[individualKey]["badgeId"],
          DATA[individualKey]["phoneNumber"],
          DATA[individualKey]["vehicleNumber"],
          DATA[individualKey]["licencePlateNumber"],
          DATA[individualKey]["state"],
          DATA[individualKey]["district"],
          DATA[individualKey]["station"],
          DATA[individualKey]["totalRatings"],
          DATA[individualKey]["totalRaters"],
          DATA[individualKey]["onDuty"],
        );

        //  postsList.add(posts);
        setState(() {
          policeOfficersLists.insert(0, policeOfficers);
        });
      }
    });
  }

  Widget OfficersUI(
      String userId,
      String firstName,
      lastName,
      emailAddress,
      String avatar,
      String address,
      String badgeId,
      String phoneNumber,
      String vehicleNumber,
      licencePlateNumber,
      String state,
      district,
      station,
      totalRatings,
      totalRaters,
      onDuty) {
    return Visibility(
        visible: onDuty == "true" ? true : false,
        child: Container(
          //width: double.infinity,

          margin: EdgeInsets.all(8),

          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PoliceOfficersDetails(
                            userId,
                            firstName,
                            lastName,
                            emailAddress,
                            avatar,
                            address,
                            badgeId,
                            phoneNumber,
                            vehicleNumber,
                            licencePlateNumber,
                            state,
                            district,
                            station,
                            totalRatings,
                            totalRaters,
                            onDuty,
                            firstNameFromFirebase +
                                " " +
                                lastNameFromFirebase)));
              },
              child:

                  // Card(
                  //             elevation: 8,
                  //             shadowColor: kPrimaryColor,
                  //             shape: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(color: Colors.transparent)),
                  //             child:

                  Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFCBB6E9),
                                radius: 40,
                                backgroundImage: NetworkImage(avatar),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                              ),
                              Text(
                                "On Duty",
                                style: GoogleFonts.quicksand(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                convertToTitleCase(firstName + " " + lastName) +
                                    " - " +
                                    badgeId.toUpperCase(),
                                style: GoogleFonts.quicksand(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                              ),
                              Text(
                                convertToTitleCase(
                                    "$station | $district, $state"),
                                style: GoogleFonts.quicksand(fontSize: 13),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 3),
                                    child: Text(
                                      totalRaters != "0"
                                          ? (double.parse(totalRatings) /
                                                  int.parse(totalRaters))
                                              .toStringAsFixed(1)
                                          : "",
                                      style: GoogleFonts.quicksand(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: totalRaters != "0"
                                        ? double.parse(totalRatings) /
                                            int.parse(totalRaters)
                                        : 0,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    direction: Axis.horizontal,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: Text(
                                      "($totalRaters)",
                                      style: GoogleFonts.quicksand(),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: null,
                                      onPressed: () {
                                        _launchCaller(phoneNumber);
                                      },
                                      child: Icon(Icons.call_outlined),
                                      backgroundColor: kPrimaryLightColor,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                    ),
                                    FloatingActionButton(
                                      heroTag: null,
                                      onPressed: () {
                                        sendEmailToOfficer(emailAddress);
                                      },
                                      child: Icon(Icons.email_outlined),
                                      backgroundColor: kPrimaryLightColor,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                    ),
                                  ],
                                ),
                              )
                              // Align(
                              //     alignment: Alignment(0.8, -1.0),
                              //     heightFactor: 0.5,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         FloatingActionButton(
                              //           heroTag: null,
                              //           onPressed: () {
                              //             _launchCaller(phoneNumber);
                              //           },
                              //           child: Icon(Icons.call_outlined),
                              //           backgroundColor: kPrimaryLightColor,
                              //         ),
                              //         Container(
                              //           margin: EdgeInsets.only(left: 15),
                              //         ),
                              //         FloatingActionButton(
                              //           heroTag: null,
                              //           onPressed: () {
                              //             sendEmailToOfficer(emailAddress);
                              //           },
                              //           child: Icon(Icons.email_outlined),
                              //           backgroundColor: kPrimaryLightColor,
                              //         ),
                              //         Container(
                              //           margin: EdgeInsets.only(left: 10),
                              //         ),
                              //       ],
                              //     ))
                            ],
                          )),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  )
                ],
              )
              // )
              ),
        ));
  }

  sendEmailToOfficer(String emailAddress) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        queryParameters: {'subject': 'SENDING FROM OPENER APP', 'body': ""});
    launch(_emailLaunchUri.toString());
  }

  _launchCaller(String phoneNumber) async {
    if (await canLaunch("tel:$phoneNumber")) {
      await launch("tel:$phoneNumber");
    } else {
      throw 'Could not make call. try again';
    }
  }

  String convertToTitleCase(String text) {
    if (text == null) {
      return "";
    }

    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  showNormalToastBottom(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor);
  }

  showErrorToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryLightColor);
  }
}
