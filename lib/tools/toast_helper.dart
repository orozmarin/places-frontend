import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gastrorate/theme/my_colors.dart';

ToastHelperMobile toastHelperMobile = ToastHelperMobile();

class ToastHelperMobile {
  void showToastSuccess(String message, {int? timeDisplayed}) {
    _showToast(message, MyColors.colorGreen, timeDisplayed: timeDisplayed);
  }

  void showToastError(String message, {int? timeDisplayed}) {
    _showToast(message, MyColors.colorRed, timeDisplayed: timeDisplayed);
  }

  void showToastInfo(String message, {int? timeDisplayed}) {
    _showToast(message, MyColors.colorGrey, timeDisplayed: timeDisplayed);
  }

  void _showToast(String message, Color backgroundColor, {int? timeDisplayed}) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: timeDisplayed ?? 1,
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
