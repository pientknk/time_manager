import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';

class NotificationFactory {
  static FlushbarRoute successNotification({
    String title = "TITLE",
    String message = "MESSAGE",
    BuildContext context,
  }){
    return FlushbarRoute(
      flushbar: Flushbar(
        title: title,
        titleText: Text("Testing the title Text",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.yellow[600]
          ),
        ),
        message: message,
        messageText: Text("Testing the message Text",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.green
          ),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red,
        boxShadows: [
          BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0),
        ],
        backgroundGradient: LinearGradient(colors: [
          Colors.blueGrey,
          Colors.black,
        ]),
        isDismissible: false,
        duration: Duration(seconds: 4),
        icon: Icon(
          Icons.check,
          color: Colors.greenAccent,
        ),
        mainButton: FlatButton(
          onPressed: () {},
          child: Text("CLAP",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.blueGrey,
      )
    );
  }
}