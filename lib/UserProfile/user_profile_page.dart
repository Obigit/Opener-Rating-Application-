import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BlurryDialogs/single_button_blurry_dialog.dart';
import '../HomePage/home_page.dart';
import '../constants.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  String firstNameFromFirebase,
      lastNameFromFirebase,
      avatarFromFirebase,
      userNameFromFirebase,
      nationalIdFromFirebase,
      addressFromFirebase,
      postCodeFromFirebase,
      districtFromFirebase,
      stateFromFirebase;

  UserProfilePage(
      this.firstNameFromFirebase,
      this.lastNameFromFirebase,
      this.avatarFromFirebase,
      this.userNameFromFirebase,
      this.nationalIdFromFirebase,
      this.addressFromFirebase,
      this.postCodeFromFirebase,
      this.districtFromFirebase,
      this.stateFromFirebase);

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
      FirebaseDatabase().reference().child("Users_Details");

  bool districtVisibility = false,
      uploadingProgress = false,
      userAvatar = true,
      profilePicAvailable = true;

  late String selectedState = "Select State",
      selectedDistrict = "Choose District",
      userAvatarUrl = widget.avatarFromFirebase,
      firstName = widget.firstNameFromFirebase,
      lastName = widget.lastNameFromFirebase,
      userName = widget.userNameFromFirebase,
      nationalId = widget.nationalIdFromFirebase,
      address = widget.addressFromFirebase,
      postCode = widget.postCodeFromFirebase,
      currentDistrict = widget.districtFromFirebase,
      currentState = widget.stateFromFirebase;

  var selectedDistrictList = ["Choose District"];

  // TextEditingController firstNameTC = TextEditingController(),
  //     lastNameTC = TextEditingController(),
  //     userNameTC = TextEditingController(),
  //     nationIdTC = TextEditingController(),
  //     addressTC = TextEditingController(),
  //     postCodeTC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: GoogleFonts.quicksand(),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(15),
            child: ListView(
              shrinkWrap: true,
              children: [
                topMargin(),
                const Divider(
                  color: Colors.grey,
                ),
                topMargin(),
                GestureDetector(
                    onTap: () {
                      _checkInternetConnectivityForAvatar();
                    },
                    child: Column(
                      children: [
                        Visibility(
                          visible: uploadingProgress,
                          child: const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: userAvatar,
                          child: userAvatarUrl != ""
                              ? CircleAvatar(
                                  backgroundColor: Color(0xFFCBB6E9),
                                  radius: 80,
                                  backgroundImage: NetworkImage(userAvatarUrl),
                                )
                              : Image.asset(
                                  "images/ic_default_avatar.png",
                                  width: 50,
                                  height: 50,
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            "Please upload your profile picture above",
                            style: GoogleFonts.quicksand(),
                          ),
                        )
                      ],
                    )),

                topMargin(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 180.0,
                        child: TextFormField(
                          style: GoogleFonts.quicksand(),
                          onChanged: (text) {
                            setState(() {
                              firstName = text;
                            });
                          },
                          initialValue: widget.firstNameFromFirebase,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            labelStyle: GoogleFonts.quicksand(
                              color: kPrimaryLightColor,
                            ),
                            fillColor: kPrimaryLightColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                    ),
                    Expanded(
                        child: SizedBox(
                            width: 190.0,
                            child: TextFormField(
                              style: GoogleFonts.quicksand(),
                              initialValue: widget.lastNameFromFirebase,
                              onChanged: (text) {
                                setState(() {
                                  lastName = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Last Name",
                                labelStyle: GoogleFonts.quicksand(
                                  color: kPrimaryLightColor,
                                ),
                                fillColor: kPrimaryLightColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ))),
                  ],
                ),
                topMargin(),
                TextFormField(
                  style: GoogleFonts.quicksand(),
                  initialValue: widget.userNameFromFirebase,
                  onChanged: (text) {
                    setState(() {
                      userName = text;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
                    labelText: "Choose a username here",
                    labelStyle: GoogleFonts.quicksand(
                      color: kPrimaryLightColor,
                    ),
                    fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                topMargin(),
                TextFormField(
                  style: GoogleFonts.quicksand(),
                  initialValue: widget.nationalIdFromFirebase,
                  onChanged: (text) {
                    setState(() {
                      nationalId = text;
                    });
                  },
                  //keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "National ID",
                    labelStyle: GoogleFonts.quicksand(
                      color: kPrimaryLightColor,
                    ),
                    fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                topMargin(),
                TextFormField(
                  style: GoogleFonts.quicksand(),
                  initialValue: widget.addressFromFirebase,
                  onChanged: (text) {
                    setState(() {
                      address = text;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Address",
                    labelStyle: GoogleFonts.quicksand(
                      color: kPrimaryLightColor,
                    ),
                    fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                topMargin(),
                TextFormField(
                  style: GoogleFonts.quicksand(),
                  initialValue: widget.postCodeFromFirebase,
                  onChanged: (text) {
                    setState(() {
                      postCode = text;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Postcode",
                    labelStyle: GoogleFonts.quicksand(
                      color: kPrimaryLightColor,
                    ),
                    fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                // topMargin(),
                // TextFormField(
                //   decoration: InputDecoration(
                //     hintText: "Address",
                //     labelText: "Enter your full residential address here",
                //     labelStyle: const GoogleFonts.quicksand(
                //       color: kPrimaryLightColor,
                //     ),
                //     fillColor: kPrimaryLightColor,
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     contentPadding:
                //         EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide:
                //           const BorderSide(color: kPrimaryColor, width: 2.0),
                //       borderRadius: BorderRadius.circular(25.0),
                //     ),
                //   ),
                // ),
                topMargin(),
                Center(
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedState,
                      hint: Text(
                        "Select State",
                        style: GoogleFonts.quicksand(),
                      ),
                      items: allStates.map((String valueItem) {
                        return DropdownMenuItem<String>(
                          child: Center(
                            child: Text(
                              valueItem,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(),
                            ),
                          ),
                          value: valueItem,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setSelectedState(val);
                      }),
                ),
                topMargin(),
                Visibility(
                    visible: districtVisibility,
                    child: Center(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedDistrict,
                          hint: Text(
                            "Choose District",
                            style: GoogleFonts.quicksand(),
                          ),
                          items: selectedDistrictList.map((String valueItem) {
                            return DropdownMenuItem<String>(
                              child: Center(
                                child: Text(valueItem,
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center),
                              ),
                              value: valueItem,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedDistrict = val!;
                            });
                          }),
                    )),

                topMargin(),

                Container(
                  width: double.infinity,
                  height: 55,
                  child: RaisedButton(
                    onPressed: () {
                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          userName.isEmpty ||
                          nationalId.isEmpty ||
                          address.isEmpty ||
                          postCode.isEmpty) {
                        showErrorToast("One or more fields are empty");
                      } else if (selectedState == "Select State") {
                        showErrorToast("Select a state to continue");
                      } else if (selectedDistrict == "Choose District") {
                        showErrorToast("Choose your district to continue");
                      } else {
                        Loader.show(context,
                            progressIndicator: const LinearProgressIndicator(
                              color: kPrimaryColor,
                            ));

                        usersDetailsRef
                            .child(firebaseAuth.currentUser!.uid)
                            .set({
                          "userId": firebaseAuth.currentUser?.uid,
                          "firstName": firstName,
                          "lastName": lastName,
                          "userName": userName,
                          "nationalId": nationalId,
                          "address": address,
                          "postCode": postCode,
                          "state": selectedState != "Select State"
                              ? selectedState
                              : selectedState,
                          "district": selectedDistrict != "Choose District"
                              ? selectedDistrict
                              : selectedDistrict
                        }).then((value) {
                          Loader.hide();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));

                          showNormalToastBottom("Profile Successfully Updated");
                        });
                      }
                    },
                    child: Text(
                      "Update Profile",
                      style: GoogleFonts.quicksand(),
                    ),
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _checkInternetConnectivityForAvatar() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      noInternetConnectionDialog(context);
    } else {
      performFirebaseStorageLogicForAvatar();
    }
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

  void performFirebaseStorageLogicForAvatar() async {
    //  User? user = FirebaseAuth.instance.currentUser;

    // String? currentUserEmail = user!.email;

    FirebaseStorage _storage = FirebaseStorage.instance;

    //Get the file from the image picker and store it
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    Reference reference = _storage
        .ref()
        .child("users_avatars/" + FirebaseAuth.instance.currentUser!.uid + "/");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(File(image!.path));

    setState(() {
      uploadingProgress = true;
      userAvatar = false;
    });

    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();

    setState(() {
      userAvatarUrl = url;

      usersDetailsRef
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("avatar")
          .set(userAvatarUrl)
          .whenComplete(() => {});

      uploadingProgress = false;
      userAvatar = true;
      profilePicAvailable = true;
    });
  }

  showErrorToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey);
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

  void setSelectedState(String? val) {
    setState(() {
      selectedDistrict = "Choose District";
      selectedState = val!;

      if (selectedState != "Select State") {
        districtVisibility = true;
        switch (selectedState) {
          case "Federal Capital Territory (Abuja)":
            selectedDistrictList = abuja;
            break;
          case "Abia State":
            selectedDistrictList = abia;
            break;
          case "Adamawa State":
            selectedDistrictList = adamawa;
            break;
          case "Akwa Ibom State":
            selectedDistrictList = akwaIbom;
            break;
          case "Anambra State":
            selectedDistrictList = anambra;
            break;
          case "Bauchi State":
            selectedDistrictList = bauchi;
            break;
          case "Bayelsa State":
            selectedDistrictList = bayelsa;
            break;
          case "Benue State":
            selectedDistrictList = benue;
            break;
          case "Borno State":
            selectedDistrictList = borno;
            break;
          case "Cross River State":
            selectedDistrictList = crossRiver;
            break;
          case "Delta State":
            selectedDistrictList = delta;
            break;
          case "Ebonyi State":
            selectedDistrictList = ebonyi;
            break;
          case "Edo State":
            selectedDistrictList = edo;
            break;
          case "Ekiti State":
            selectedDistrictList = ekiti;
            break;
          case "Enugu State":
            selectedDistrictList = enugu;
            break;
          case "Gombe State":
            selectedDistrictList = gombe;
            break;
          case "Imo State":
            selectedDistrictList = imo;
            break;
          case "Jigawa State":
            selectedDistrictList = jigawa;
            break;
          case "Kaduna State":
            selectedDistrictList = kaduna;
            break;
          case "kano State":
            selectedDistrictList = kano;
            break;
          case "katsina State":
            selectedDistrictList = katsina;
            break;
          case "Kebbi State":
            selectedDistrictList = kebbi;
            break;
          case "Kogi State":
            selectedDistrictList = kogi;
            break;
          case "Kwara State":
            selectedDistrictList = kwara;
            break;
          case "Lagos State":
            selectedDistrictList = lagos;
            break;
          case "Nasarawa State":
            selectedDistrictList = nasarawa;
            break;
          case "Niger State":
            selectedDistrictList = niger;
            break;
          case "Ogun State":
            selectedDistrictList = ogun;
            break;
          case "Ondo State":
            selectedDistrictList = ondo;
            break;
          case "Osun State":
            selectedDistrictList = osun;
            break;
          case "Oyo State":
            selectedDistrictList = oyo;
            break;
          case "Plateau State":
            selectedDistrictList = plateau;
            break;
          case "Rivers State":
            selectedDistrictList = rivers;
            break;
          case "Sokoto State":
            selectedDistrictList = sokoto;
            break;
          case "Taraba State":
            selectedDistrictList = taraba;
            break;
          case "Yobe State":
            selectedDistrictList = yobe;
            break;
          case "Zamfara State":
            selectedDistrictList = zamfara;
            break;
        }
      } else {
        districtVisibility = false;
      }
    });
  }

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }
}
