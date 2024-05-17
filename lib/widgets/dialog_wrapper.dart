import 'package:flutter/material.dart';

class DialogWrapperWidget extends StatefulWidget {
  final List<Widget>? children;
  final double? maxWidth;
  final double? padding;

  @override
  _ConfirmationDialog createState() => _ConfirmationDialog();

  DialogWrapperWidget({this.children, this.maxWidth, this.padding});
}

class _ConfirmationDialog extends State<DialogWrapperWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(widget.padding ?? 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 800),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(widget.padding ?? 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[...widget.children!],
            ),
          ),
        ),
      ),
    );
  }
}
