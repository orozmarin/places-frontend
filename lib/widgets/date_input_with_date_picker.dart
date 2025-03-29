import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/extensions/date_extension.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/input_field.dart';

class DateInputWithDatePicker extends StatefulWidget {
  final String? title;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? date;
  final double? width;
  final ValueChanged<DateTime> onDateChanged;

  const DateInputWithDatePicker({
    Key? key,
    this.title,
    this.minimumDate,
    this.date,
    this.maximumDate,
    this.width,
    required this.onDateChanged,
  }) : super(key: key);

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

  void _showDatePicker(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Makes it more compact
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: MyColors.mainBackgroundColor,
                      child: Text(widget.title!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                      minimumDate: widget.minimumDate,
                      maximumDate: widget.maximumDate,
                      initialDateTime: widget.date,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime newDate) => setState(() => _selectedDate = newDate),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (_selectedDate != null) {
                          widget.onDateChanged(_selectedDate!);
                        }
                      },
                      child: const Text('Select', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showDatePicker(context),
      child: IgnorePointer(
        child: InputField(
          width: widget.width,
          labelText: widget.date?.formatDate(),
          obscureText: true,
          onChanged: (_) {},
        ),
      ),
    );
  }
}
