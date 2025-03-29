import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pain_app/extensions/date_extension.dart';
import 'package:pain_app/i18n/translations.i18n.dart';
import 'package:pain_app/theme/custom_colors.dart';
import 'package:pain_app/theme/theme_helper.dart';
import 'package:pain_app/widgets/widgets.dart';

class DateInputWithDatePicker extends StatefulWidget {
  final String? title;
  final DateTime? minimumDate;
  final DateTime? date;
  final ValueChanged<DateTime> onDateChanged;

  const DateInputWithDatePicker({Key? key, this.title, this.minimumDate, this.date, required this.onDateChanged})
      : super(key: key);

  @override
  State<DateInputWithDatePicker> createState() => _DateInputWithDatePickerState();
}

class _DateInputWithDatePickerState extends State<DateInputWithDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Material(
            type: MaterialType.transparency,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (widget.title != null)
                        Container(
                          height: 56.0,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                          color: CustomColors.colorHeaderBackground,
                          child: Center(
                            child: Text(widget.title!, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      Container(
                        height: 200,
                        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                        color: CupertinoColors.systemBackground.resolveFrom(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: CupertinoDatePicker(
                                  minimumDate: widget.minimumDate,
                                  initialDateTime: widget.date,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() => _selectedDate = newDate);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: CustomColors.colorPrimary),
                          child: Text('buttons.select'.i18n.toUpperCase(), style: const TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (_selectedDate != null) {
                              widget.onDateChanged(_selectedDate!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: IgnorePointer(
        ignoring: true,
        child: InputField(labelText: widget.date?.formatDate(), obscureText: true, onChanged: (String? value) {}),
      ),
    );
  }
}
