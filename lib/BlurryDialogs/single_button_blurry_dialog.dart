import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SingleBtnBlurryDialog extends StatelessWidget {

  String title;
  String content;
  VoidCallback continueCallBack;

  SingleBtnBlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = GoogleFonts.quicksand (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:

        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(19.0))),
          title: new Text(title,style: textStyle,),
          content: new Text(content, style: textStyle,),
          actions: <Widget>[
            // new FlatButton(
            //   child: new Text(""),
            //   onPressed: () {
            //
            //   },
            // ),
            new FlatButton(
              child: Text("Okay, Thanks!"),
              onPressed: () {
                continueCallBack();
              },
            ),
          ],
        )


    );
  }
}