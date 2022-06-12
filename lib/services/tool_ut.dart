//import 'dart:developer';
import 'package:flutter/material.dart';
import 'log_ut.dart';

//static class, cannot use _Fun
class ToolUt {
  //show msg box
  static void msg(BuildContext? context, String info, [Function? onOk]) {
    if (context == null){
      LogUt.error(info);
      return;
    }

    // set up the button
    var okBtn = TextButton(
      child: const Text('OK'),
      onPressed: (){
        if (onOk == null){
          Navigator.pop(context);
        } else {
          onOk();
        } 
    });

    // set up the AlertDialog
    var dialog = AlertDialog(
      //title: Text('My title'),
      content: Text(info),
      actions: [
        okBtn,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  //show msg box
  static void ans(BuildContext? context, String info, [Function? onYes]) {
    if (context == null) return;
    
    // set up the button
    var okBtn = TextButton(
      child: const Text('Yes'),
      onPressed: () {
        closeForm(context);
        if (onYes != null) onYes();
      },
    );
    var cancelBtn = TextButton(
      child: const Text('No'),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    var alert = AlertDialog(
      content: Text(info),
      actions: [
        okBtn,
        cancelBtn,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //open waiting msg
  static void openWait(BuildContext? context) {
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 150,
            height: 70,
            padding: const EdgeInsets.all(10),
            child: const ListTile(
              horizontalTitleGap: 20,
              leading: CircularProgressIndicator(),
              title: Text('Working...'),
            ),
          ),
        );
      },
    );
  }

  //close waiting msg
  static void closeWait(BuildContext? context) {
    if (context == null) return;
    closeForm(context);
  }

  //close a popup dialog
  static void closeForm(BuildContext? context) {
    if (context == null) return;
    Navigator.pop(context, true);
  }

  //open a main form
  static void openForm(BuildContext? context, Widget form, [bool replace = false]) {
    if (context == null) return;
    if (replace){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => form),
      );
    } else {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => form),
      );
    }
  }
  
  /*
  static void openModal(BuildContext context, Widget form, [bool replace = false]) {
    if (context == null) return;
    if (replace){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => form),
      );
    } else {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => form),
      );
    }
  }
  */
  
} //class
