import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opener/models/ratings_comments.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import '../constants.dart';

class PoliceOfficerReviewPage extends StatefulWidget {
  String policeUserId, officerFirstName;

  PoliceOfficerReviewPage(this.policeUserId, this.officerFirstName);

  @override
  State<StatefulWidget> createState() {
    return PoliceOfficerReviewPageState();
  }
}

class PoliceOfficerReviewPageState extends State<PoliceOfficerReviewPage> {
  FocusNode commentFocusNode = FocusNode();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
          FirebaseDatabase().reference().child("Users_Details"),
      stationsRef = FirebaseDatabase().reference().child("Police_Stations"),
      officersDetailsRef =
          FirebaseDatabase().reference().child("Officers_Details");

  List<RatingsComments> ratingsList = [];
  late RatingsComments ratingsComments;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    usersDetailsRef.keepSynced(true);
    stationsRef.keepSynced(true);
    officersDetailsRef.keepSynced(true);

    /// Fetching Comments LISTS
    fetchRatingsFromFirebase();

    super.initState();
  }

  fetchRatingsFromFirebase() {
    officersDetailsRef
        .child(widget.policeUserId)
        .child("ratings")
        .onValue
        .listen((event) {
      var KEYS = event.snapshot.value.keys;
      var DATA = event.snapshot.value;

      ratingsList.clear();

      for (var individualKey in KEYS) {
        ratingsComments = RatingsComments(
            DATA[individualKey]["raterName"],
            DATA[individualKey]["raterAvatar"],
            DATA[individualKey]["rating"],
            DATA[individualKey]["comments"],
            DATA[individualKey]["anonymous"],
            DATA[individualKey]["date"]);

        ratingsList.insert(0, ratingsComments);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Reviews (Officer " + widget.officerFirstName + ")",
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          // centerTitle: true,
        ),
        body: Container(

            //  margin: EdgeInsets.all(12.0),

            child: fetchComments()));
  }

  Widget fetchComments() {
    return ListView(
      children: [
        //  currentPostUI(),
        Container(
          child: ratingsList.length == 0
              ? Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child:  Center(
                    child: Text(
                      "No available reviews to show at the moment",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ))
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ratingsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CommentsUI(
                      ratingsList[index].raterName,
                      ratingsList[index].raterAvatar,
                      ratingsList[index].rating,
                      ratingsList[index].comments,
                      ratingsList[index].anonymous,
                      ratingsList[index].date,
                    );
                  }),
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget CommentsUI(String raterName, String raterAvatar, String rating,
      String comments, String anonymous, String date) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: IntrinsicHeight(
          child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            //direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              anonymous == "true"
                  ? Image.asset(
                      "images/ic_anonymous.jpeg",
                      width: 60,
                      height: 60,
                    )
                  : CircleAvatar(
                      backgroundColor: Color(0xFFCBB6E9),
                      radius: 30,
                      backgroundImage: NetworkImage(raterAvatar),
                    ),
              Container(
                margin: EdgeInsets.only(left: 9.0),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(top: 25),
                      // ),
                      Text(
                        anonymous == "true" ? "Anonymous" : raterName,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 3.0),
                      ),
                      // Visibility(
                      //     visible:
                      //     isVerifiedFromFirebase == "true" ? true : false,
                      //     child: Image.asset(
                      //       "assets/images/verify_badge.png",
                      //       width: 12.0,
                      //       height: 12.0,
                      //     )),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                      ),
                      Text(
                        //timeStamp,
                        "⦿ " + timeago.format(DateTime.parse(date)),
                        style:
                             GoogleFonts.quicksand(fontSize: 11.0, color: Colors.grey),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 3),
                        child: Text(
                          rating,
                          style:  GoogleFonts.quicksand(
                              color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RatingBarIndicator(
                        rating: double.parse(rating),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 17.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                  ),
                  Text(
                    comments,
                    style: GoogleFonts.quicksand(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                  ),
                  Divider(
                    color: Colors.grey,
                  )
                ],
              )),
            ],
          ),
          // Divider(
          //   color: Colors.grey,
          //   thickness: 0.3,
          // )
        ],
      )),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child:  Text("Posting Comment...", style: GoogleFonts.quicksand(),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// void addMessageToActivity() {
//   String currentDateForPost = dateFormat.format(DateTime.now());
//
//   String activityId =
//       usersDetailsRef.child(authorId).child("activities").push().key;
//
//   /// Add message to activity list
//   usersDetailsRef.child(authorId).child("activities").child(activityId).set({
//     "message": convertToTitleCase(displayName) + " commented on your post",
//     "timeStamp": currentDateForPost + "Z",
//     "userAvatar": currentUserAvatar
//   });
// }

}
