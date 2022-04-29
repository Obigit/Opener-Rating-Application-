import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/BlurryDialogs/blurry_dialog.dart';
import 'package:opener/PoliceOfficers/all_officers_within_station.dart';
import 'package:opener/PoliceOfficers/officers_on_duty_page.dart';
import 'package:opener/PoliceStations/police_station_review_page.dart';
import 'package:opener/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PoliceStationsDetails extends StatefulWidget {
  String stationId,
      stationName,
      address,
      postCode,
      phoneNumber,
      state,
      district,
      totalRatings,
      totalRaters,
      currentUserFirstName,
      currentUserLastName;

  PoliceStationsDetails(
      this.stationId,
      this.stationName,
      this.address,
      this.postCode,
      this.phoneNumber,
      this.state,
      this.district,
      this.totalRatings,
      this.totalRaters,
      this.currentUserFirstName,
      this.currentUserLastName);

  @override
  State<PoliceStationsDetails> createState() => _PoliceStationsDetailsState();
}

class _PoliceStationsDetailsState extends State<PoliceStationsDetails> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
          FirebaseDatabase().reference().child("Users_Details"),
      stationsRef = FirebaseDatabase().reference().child("Police_Stations");

  bool anonymous = false;
  double ratingValue = 1;

  late String userAvatar;

  TextEditingController commentsTC = TextEditingController();

  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    usersDetailsRef.keepSynced(true);
    stationsRef.keepSynced(true);

    /// Fetch user avatar from firebase
    usersDetailsRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("avatar")
        .once()
        .then((snapshot) {
      setState(() {
        if (snapshot.value != null) {
          userAvatar = snapshot.value;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details",
          style: GoogleFonts.quicksand(),
          ),
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {

            _launchCaller(widget.phoneNumber);
          },
          label: Text('Call this Station',
          style: GoogleFonts.quicksand(),
          ),
          icon: Icon(Icons.call_outlined),
          backgroundColor: kPrimaryLightColor,
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(12),
              child: Container(
                margin: EdgeInsets.all(12),
                child: Wrap(
                  children: [
                    Text(
                      "POLICE STATION DETAILS",
                      style:
                      GoogleFonts.gruppo(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),

                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.home_work_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          convertToTitleCase(widget.stationName),
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        )
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Expanded(
                            child: Text(
                          convertToTitleCase(widget.address),
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        ))
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.star_outline),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 3),
                          child: Text(
                            widget.totalRaters != "0"
                                ? (double.parse(widget.totalRatings) /
                                        int.parse(widget.totalRaters))
                                    .toStringAsFixed(1)
                                : "",
                            style:  GoogleFonts.quicksand(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RatingBarIndicator(
                          rating: widget.totalRaters != "0"
                              ? double.parse(widget.totalRatings) /
                                  int.parse(widget.totalRaters)
                              : 0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          child: Text("(" + widget.totalRaters + ")",
                          style: GoogleFonts.quicksand(),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PoliceStationReviewPage(
                                              widget.stationId,
                                              widget.stationName)));
                            },
                            child: Text(
                              "See Reviews",
                              style: GoogleFonts.quicksand(fontSize: 12),
                            ))
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.my_location_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          widget.postCode,
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        )
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.call_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          widget.phoneNumber,
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        )
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.location_city_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          widget.state,
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        )
                      ],
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Icon(Icons.home_repair_service_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          widget.district,
                          style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
                        )
                      ],
                    ),
                    topMargin(),
                    Container(
                      margin: EdgeInsets.only(top: 7),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // width: 150,
                          height: 45,
                          child: RaisedButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfficersOnDutyPage(
                                          widget.stationName)));
                            },
                            child:  Text("See who's on Duty",
                            style: GoogleFonts.quicksand(),
                            ),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          //  width: 150,
                          height: 45,
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllOfficersWithinStation(
                                              widget.stationName)));
                            },
                            child:  Text("View All Officers",
                            style: GoogleFonts.quicksand(),
                            ),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                    ),
                    Text(
                      "RATE THIS STATION",
                      style:
                      GoogleFonts.gruppo(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    topMargin(),
                    Text(
                        "Kindly use this section to leave a rating for this police station",
                    style: GoogleFonts.quicksand(),),
                    topMargin(),
                    topMargin(),
                    Center(
                        child: RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratingValue = rating;
                        });
                      },
                    )),
                    topMargin(),
                    topMargin(),
                    TextFormField(
                      controller: commentsTC,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Comments",
                          labelText: "Please write a comment here",
                          labelStyle: const TextStyle(
                            color: kPrimaryLightColor,
                          ),
                          fillColor: kPrimaryLightColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          // contentPadding: EdgeInsets.symmetric(
                          //     vertical: 50, horizontal: 8)
                        ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: kPrimaryColor,
                            value: anonymous,
                            onChanged: (bool? value) {
                              setState(() {
                                anonymous = value!;
                              });
                            },
                          ),
                           Text(
                            "Hide my identity (Anonymous)",
                            style: GoogleFonts.quicksand(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    topMargin(),
                    Center(
                        child: Container(
                      width: double.infinity,
                      height: 55,
                      child: RaisedButton(
                        color: kPrimaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (commentsTC.text.isEmpty) {
                            showErrorToast("Enter your comment to continue");
                          } else {
                            showBlurryDialog(context);
                          }
                        },
                        child:  Text("Submit Rating",

                        style: GoogleFonts.quicksand(),),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 60),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  showBlurryDialog(BuildContext context) {
    // ignore: sdk_version_set_literal
    VoidCallback continueCallBack = () {
      // code on continue comes here
      performActionForSubmitRating();

      Navigator.of(context).pop();
    };
    BlurryDialog alert = BlurryDialog(
        "Submit Rating",
        "You are about to give " +
            widget.stationName.toUpperCase() +
            " of " +
            widget.district +
            ", " +
            widget.state +
            " '$ratingValue Rating'. Do you wish to proceed?",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchCaller(String phoneNumber) async {
    if (await canLaunch("tel:$phoneNumber")) {
      await launch("tel:$phoneNumber");
    } else {
      throw 'Could not make call. try again';
    }
  }

  void performActionForSubmitRating() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateForPost = dateFormat.format(DateTime.now());

    /// Save for total ratings
    stationsRef
        .child(widget.stationId)
        .child("totalRatings")
        .set((double.parse(widget.totalRatings) + ratingValue).toString());

    /// Save for total raters
    stationsRef
        .child(widget.stationId)
        .child("totalRaters")
        .set((int.parse(widget.totalRaters) + 1).toString());

    /// Add comment to rating
    String ratingId =
        stationsRef.child(widget.stationId).child("ratings").push().key;

    stationsRef.child(widget.stationId).child("ratings").child(ratingId).set({
      "raterName":
          widget.currentUserFirstName + " " + widget.currentUserLastName,
      "raterAvatar": userAvatar,
      "rating": "$ratingValue",
      "comments": commentsTC.text,
      "anonymous": "$anonymous",
      "date": currentDateForPost + "Z",
    }).whenComplete(() {
      showNormalToastBottom("Rating was successful");
      setState(() {});
    });
  }

  Widget topMargin() {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
}
