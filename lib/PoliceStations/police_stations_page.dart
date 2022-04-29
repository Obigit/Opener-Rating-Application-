import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/PoliceOfficers/all_officers_within_station.dart';
import 'package:opener/PoliceOfficers/officers_on_duty_page.dart';
import 'package:opener/PoliceStations/police_station_details.dart';
import 'package:opener/constants.dart';
import 'package:opener/models/police_stations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PoliceStationsPage extends StatefulWidget {
  @override
  State<PoliceStationsPage> createState() => PoliceStationsPageState();
}

class PoliceStationsPageState extends State<PoliceStationsPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
          FirebaseDatabase().reference().child("Users_Details"),
      stationsRef = FirebaseDatabase().reference().child("Police_Stations");

  List<PoliceStations> policeStationsList = [];
  late PoliceStations policeStations;

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
              ? searchForStation(searchedText)
              : fetchStationsWithinDistricts(currentUserDistrict);
        }
      });
    });

    fetchUsersDetails();

    super.initState();
  }

  fetchStationsWithinDistricts(String currentUserDistrict) {
    stationsRef
        .orderByChild("district")
        .equalTo(currentUserDistrict)
        .onValue
        .listen((event) {
      var KEYS = event.snapshot.value.keys;
      var DATA = event.snapshot.value;

      policeStationsList.clear();

      for (var individualKey in KEYS) {
        policeStations = PoliceStations(
          DATA[individualKey]["stationId"],
          DATA[individualKey]["stationName"],
          DATA[individualKey]["address"],
          DATA[individualKey]["postCode"],
          DATA[individualKey]["phoneNumber"],
          DATA[individualKey]["state"],
          DATA[individualKey]["district"],
          DATA[individualKey]["totalRatings"],
          DATA[individualKey]["totalRaters"],
        );

        //  postsList.add(posts);
        setState(() {
          policeStationsList.insert(0, policeStations);
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
        policeStationsList.length == 0
            ? Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Text(
                    "No available stations to show within your district or the system is fetching the stations from the server",
                    // "Loading...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ))
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: policeStationsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return StationsUI(
                      policeStationsList[index].stationId,
                      policeStationsList[index].stationName,
                      policeStationsList[index].address,
                      policeStationsList[index].postCode,
                      policeStationsList[index].phoneNumber,
                      policeStationsList[index].state,
                      policeStationsList[index].district,
                      policeStationsList[index].totalRatings,
                      policeStationsList[index].totalRaters);
                },
              ),
      ],
    )));
  }

  Widget StationsUI(
      String stationId,
      String stationName,
      String address,
      String postCode,
      String phoneNumber,
      String state,
      String district,
      String totalRatings,
      String totalRaters) {
    return Container(
      //width: double.infinity,

      margin: EdgeInsets.all(8),

      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PoliceStationsDetails(
                        stationId,
                        stationName,
                        address,
                        postCode,
                        phoneNumber,
                        state,
                        district,
                        totalRatings,
                        totalRaters,
                        firstNameFromFirebase,
                        lastNameFromFirebase)));
          },
          // child: Card(
          //   elevation: 8,
          //   shadowColor: kPrimaryColor,
          //   shape: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(20.0),
          //       borderSide: BorderSide(color: Colors.transparent)),
          //
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/ic_police_station.png",
                        width: 90,
                        height: 90,
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
                            convertToTitleCase(stationName),
                            style: GoogleFonts.quicksand(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 7),
                          ),
                          Text(
                            convertToTitleCase(address) + " | $phoneNumber",
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
                          Row(
                            children: [
                              Container(
                                // width: 150,
                                height: 35,
                                child: RaisedButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OfficersOnDutyPage(
                                                    stationName)));
                                  },
                                  child: Text(
                                    "See who's on Duty",
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 5),
                                //    width: 150,
                                height: 35,
                                child: RaisedButton(
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllOfficersWithinStation(
                                                    stationName)));
                                  },
                                  child: Text(
                                    "View All Officers",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ))
                            ],
                          )
                        ],
                      ))
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
    );
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
                              searchForStation(searchedText.toLowerCase());
                              //
                              // showNormalToastBottom(
                              //     "Searching For: $searchedText");
                            });
                          },
                          style: GoogleFonts.quicksand(color: kPrimaryColor),
                          decoration: const InputDecoration(
                            hintText: "Search by Station Name",
                            hintStyle: TextStyle(color: kPrimaryLightColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: kPrimaryLightColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        )),
                      ),
                      Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  searchForStation(String searchedText) {
    stationsRef
        .orderByChild("stationName")
        .startAt(searchedText)
        .endAt(searchedText + "\uf8ff")
        .onValue
        .listen((event) {
      var KEYS = event.snapshot.value.keys;
      var DATA = event.snapshot.value;

      policeStationsList.clear();

      for (var individualKey in KEYS) {
        policeStations = PoliceStations(
          DATA[individualKey]["stationId"],
          DATA[individualKey]["stationName"],
          DATA[individualKey]["address"],
          DATA[individualKey]["postCode"],
          DATA[individualKey]["phoneNumber"],
          DATA[individualKey]["state"],
          DATA[individualKey]["district"],
          DATA[individualKey]["totalRatings"],
          DATA[individualKey]["totalRaters"],
        );

        //  postsList.add(posts);
        setState(() {
          policeStationsList.insert(0, policeStations);
        });
      }
    });
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
