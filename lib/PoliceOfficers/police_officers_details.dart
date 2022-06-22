import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/BlurryDialogs/blurry_dialog.dart';
import 'package:opener/PoliceOfficers/police_officer_review_page.dart';
import 'package:opener/PoliceStations/police_station_review_page.dart';
import 'package:opener/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PoliceOfficersDetails extends StatefulWidget {
  String policeUserId,
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
      currentUserFullName;

  PoliceOfficersDetails(
      this.policeUserId,
      this.firstName,
      this.lastName,
      this.emailAddress,
      this.avatar,
      this.address,
      this.badgeId,
      this.phoneNumber,
      this.vehicleNumber,
      this.licencePlateNumber,
      this.state,
      this.district,
      this.station,
      this.totalRatings,
      this.totalRaters,
      this.onDuty,
      this.currentUserFullName);

  @override
  State<PoliceOfficersDetails> createState() => PoliceOfficersDetailsState();
}

class PoliceOfficersDetailsState extends State<PoliceOfficersDetails> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
          FirebaseDatabase().reference().child("Users_Details"),
      stationsRef = FirebaseDatabase().reference().child("Police_Stations"),
      officersDetailsRef =
          FirebaseDatabase().reference().child("Officers_Details");

  bool anonymous = false;
  double ratingValue = 1;
  late String userAvatar;

  TextEditingController commentsTC = TextEditingController();

  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    usersDetailsRef.keepSynced(true);
    stationsRef.keepSynced(true);
    officersDetailsRef.keepSynced(true);

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
          title: Text("Officer Details",
          style: GoogleFonts.quicksand(),
          ),
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _launchCaller(widget.phoneNumber);
          },
          label: Text('Call Officer ' + convertToTitleCase(widget.firstName),

          style: GoogleFonts.quicksand(),),
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
                    // Text(
                    //   "OFFICER DETAILS",
                    //   style:
                    //       GoogleFonts.acme(fontSize: 25, color: Colors.black),
                    //   textAlign: TextAlign.center,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 3),
                    //   child: Divider(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    // topMargin(),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFCBB6E9),
                        radius: 70,
                        backgroundImage: NetworkImage(widget.avatar),
                      ),
                    ),
                    topMargin(),
                    Center(
                      child: Text(
                        convertToTitleCase(
                            widget.firstName + " " + widget.lastName),
                        style: GoogleFonts.quicksand(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    topMargin(),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Badge ID: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.badgeId),
                        ],
                      ),
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Station: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: convertToTitleCase(widget.station)),
                        ],
                      ),
                    ),
                    topMargin(),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: GoogleFonts.quicksand(
                                  fontSize: 18, color: Colors.black87),
                              children: <TextSpan>[
                                 TextSpan(
                                    text: 'Address: ',
                                    style:
                                    GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: convertToTitleCase(widget.address)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Email: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.emailAddress),
                        ],
                      ),
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Phone No: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.phoneNumber),
                        ],
                      ),
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Vehicle No: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.vehicleNumber),
                        ],
                      ),
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Licence Plate: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.licencePlateNumber),
                        ],
                      ),
                    ),
                    topMargin(),
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'Location: ',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.district + ", " + widget.state),
                        ],
                      ),
                    ),
                    topMargin(),
                    topMargin(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                              style: GoogleFonts.quicksand(),),
                            ),
                          ],
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PoliceOfficerReviewPage(
                                              widget.policeUserId,
                                              widget.firstName)));
                            },
                            child: Text(
                              "See Reviews",
                              style: GoogleFonts.quicksand(fontSize: 12),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                    ),
                    Text(
                      "RATE THIS OFFICER",
                      style: GoogleFonts.gruppo(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                    topMargin(),
                     Text(
                        "Kindly use this section to leave a rating for this officer",
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
                      // textAlignVertical: TextAlignVertical.top,
                      controller: commentsTC,
                      decoration: InputDecoration(
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
        "You are about to give OFFICER " +
            widget.firstName.toUpperCase() +
            " " +
            widget.lastName.toUpperCase() +
            " of " +
            widget.station.toUpperCase() +
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
    officersDetailsRef
        .child(widget.policeUserId)
        .child("totalRatings")
        .set((double.parse(widget.totalRatings) + ratingValue).toString());

    /// Save for total raters
    officersDetailsRef
        .child(widget.policeUserId)
        .child("totalRaters")
        .set((int.parse(widget.totalRaters) + 1).toString());

    /// Add comment to rating
    String ratingId = officersDetailsRef
        .child(widget.policeUserId)
        .child("ratings")
        .push()
        .key;

    officersDetailsRef
        .child(widget.policeUserId)
        .child("ratings")
        .child(ratingId)
        .set({
      "raterName": widget.currentUserFullName,
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
