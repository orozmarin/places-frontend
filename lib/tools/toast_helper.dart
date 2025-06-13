import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

ToastHelperMobile toastHelperMobile = ToastHelperMobile();

class ToastHelperMobile {
  void showToastSuccess(String message) {
    _showToast(message, Colors.green);
  }

  void showToastError(String message) {
    _showToast(message, Colors.red);
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<bool?> showAlertDialogOkCancel(
      BuildContext context, String title, String message) {
    return _showDialog(context, title, message, "OK", "Cancel");
  }

  Future<bool?> showAlertDialogYesNo(
      BuildContext context, String title, String message) {
    return _showDialog(context, title, message, "Yes", "No");
  }

  Future<bool?> _showDialog(
      BuildContext context, String title, String message, String affirmative, String negative) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(negative),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(affirmative),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
