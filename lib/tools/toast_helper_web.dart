import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/dialog_wrapper.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/modal_header.dart';
import 'package:gastrorate/widgets/toast_message.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

ToastHelperWeb toastHelperWeb = ToastHelperWeb();

class ToastHelperWeb {
  void showToastSuccess(String msg) {
    _showToast(msg, false);
  }

  void showToastError(String msg) {
    _showToast(msg, true);
  }

  void _showToast(String msg, bool error) {
    FToast fToast = FToast();

    Widget toast = CustomToast(
      message: msg,
      error: error,
      onClose: () {
        fToast.removeCustomToast();
      },
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 5),
        positionedToastBuilder: (BuildContext context, Widget child) {
          return Positioned(
            child: child,
            top: 20.0,
            right: 20.0,
          );
        });
  }

  Future<bool?> showAlertDialogOkCancel(String title, String mainText, String questin, BuildContext context) async {
    return _showDialog(context, title, mainText, questin, "OK", "Cancel");
  }

  Future<bool?> showAlertDialogYesNo(String title, String mainText, String questin, BuildContext context) async {
    return _showDialog(context, title, mainText, questin, "Yes", "No");
  }

  Future<bool?> _showDialog(
      BuildContext context, String title, String mainText, String questin, String affirmative, String negative) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogWrapperWidget(maxWidth: 450, children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ModalHeader(title: mainText),
              const VerticalSpacer(20),
              Text(questin, style: Theme.of(context).textTheme.bodyLarge),
              const VerticalSpacer(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ButtonComponent.outlinedButtonSmall(
                      text: negative,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                  const HorizontalSpacer(16),
                  Expanded(
                    child: ButtonComponent.smallButton(
                      text: affirmative,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ]);
      },
    );
  }
}
