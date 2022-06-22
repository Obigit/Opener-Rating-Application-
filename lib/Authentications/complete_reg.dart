import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../HomePage/home_page.dart';
import '../constants.dart';

class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({Key? key}) : super(key: key);

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersDetailsRef =
      FirebaseDatabase().reference().child("Users_Details");

  bool districtVisibility = false;
  String selectedState = "Select State", selectedDistrict = "Choose District";

  var selectedDistrictList = ["Choose District"];

  TextEditingController firstNameTC = TextEditingController(),
      lastNameTC = TextEditingController(),
      userNameTC = TextEditingController(),
      nationIdTC = TextEditingController(),
      addressTC = TextEditingController(),
      postCodeTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          shrinkWrap: true,
          children: [
             Text(
              "Please Complete your Profile Registration here",
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            topMargin(),
            const Divider(
              color: Colors.grey,
            ),
            topMargin(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 190.0,
                    child: TextFormField(
                      controller: firstNameTC,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        labelStyle:  GoogleFonts.quicksand(
                          color: kPrimaryLightColor,
                        ),
                        fillColor: kPrimaryLightColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: kPrimaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    )),
               Container(
                 margin: EdgeInsets.only(right: 5, left: 5),
               ),
               Expanded( child:  SizedBox(
                    width: 190.0,
                    child: TextFormField(
                      controller: lastNameTC,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        labelStyle:  GoogleFonts.quicksand(
                          color: kPrimaryLightColor,
                        ),
                        fillColor: kPrimaryLightColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
              controller: userNameTC,
              decoration: InputDecoration(
                hintText: "Username",
                labelText: "Choose a username here",
                labelStyle:  GoogleFonts.quicksand(
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
              controller: nationIdTC,
              //keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "National ID",
                labelStyle:  GoogleFonts.quicksand(
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
              controller: addressTC,
              decoration: InputDecoration(
                hintText: "Address",
                labelStyle:  GoogleFonts.quicksand(
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
              controller: postCodeTC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Postcode",
                labelStyle:  GoogleFonts.quicksand(
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
            //     labelStyle: const TextStyle(
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
                  hint:  Text("Select State",
                  style: GoogleFonts.quicksand(),
                  ),
                  items: allStates.map((String valueItem) {
                    return DropdownMenuItem<String>(
                      child: Center(
                        child: Text(valueItem, textAlign: TextAlign.center, style: GoogleFonts.quicksand(),),
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
                      hint:  Text("Choose District",
                      style: GoogleFonts.quicksand(),
                      ),
                      items: selectedDistrictList.map((String valueItem) {
                        return DropdownMenuItem<String>(
                          child: Center(
                            child: Text(valueItem, textAlign: TextAlign.center, style: GoogleFonts.quicksand(),),
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
                  if (firstNameTC.text.isEmpty ||
                      lastNameTC.text.isEmpty ||
                      userNameTC.text.isEmpty ||
                      nationIdTC.text.isEmpty ||
                      addressTC.text.isEmpty ||
                      postCodeTC.text.isEmpty) {
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
                    usersDetailsRef.child(firebaseAuth.currentUser!.uid).set({
                      "userId": firebaseAuth.currentUser?.uid,
                      "firstName": firstNameTC.text,
                      "lastName": lastNameTC.text,
                      "userName": userNameTC.text,
                      "nationalId": nationIdTC.text,
                      "address": addressTC.text,
                      "postCode": postCodeTC.text,
                      "state": selectedState,
                      "district": selectedDistrict
                    }).then((value) {
                      Loader.hide();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));

                      showNormalToastBottom("Registration Successful");
                    });
                  }
                },
                child: Text("Proceed",
                style: GoogleFonts.quicksand(),
                ),
                color: kPrimaryColor,
                textColor: Colors.white,
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ],
        ),
      ),
    ));
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
