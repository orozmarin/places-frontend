import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/date_input_with_date_picker.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({
    super.key,
    required this.user,
    required this.onComplete,
    required this.isLoading,
  });

  final User user;
  final Function(UpdateUserRequest request) onComplete;
  final bool isLoading;

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  Sex _selectedSex = Sex.UNDEFINED;

  final DateTime _earliestDate = DateTime.now().subtract(const Duration(days: 36500));
  final DateTime _latestDate = DateTime.now();
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Complete Your Profile",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
        showDefaultActions: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      if (widget.user.profileImageUrl != null)
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(widget.user.profileImageUrl!),
                        )
                      else
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: MyColors.primaryColor,
                          child: Text(
                            widget.user.getUserInitials(),
                            style: const TextStyle(fontSize: 32, color: Colors.white),
                          ),
                        ),
                      const VerticalSpacer(12),
                      CustomText(
                        widget.user.getFullName(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const VerticalSpacer(4),
                      CustomText(
                        widget.user.email ?? "",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const VerticalSpacer(32),
                const CustomText(
                  "Choose a username",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const VerticalSpacer(8),
                InputField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Letters, numbers, underscores only',
                  validatorFunction: _usernameValidator,
                  onChanged: (String? value) {
                    _usernameController.text = value ?? "";
                  },
                ),
                const VerticalSpacer(24),
                const CustomText(
                  "Date of birth",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const VerticalSpacer(8),
                DateInputWithDatePicker(
                  title: 'Select date of birth',
                  maximumDate: _latestDate,
                  minimumDate: _earliestDate,
                  date: _dateOfBirth,
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _dateOfBirth = newDate;
                    });
                  },
                  validatorFunction: (_) => _dateOfBirth == null ? 'Please select a date' : null,
                ),
                const VerticalSpacer(24),
                const CustomText(
                  "Sex",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const VerticalSpacer(8),
                DropdownButtonFormField<Sex>(
                  value: _selectedSex,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: MyColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: MyColors.borderColor),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (Sex? newValue) {
                    setState(() {
                      _selectedSex = newValue ?? Sex.UNDEFINED;
                    });
                  },
                  items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                    return DropdownMenuItem<Sex>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const VerticalSpacer(40),
                ButtonComponent.smallButton(
                  isLoading: widget.isLoading,
                  onPressed: widget.isLoading ? null : _handleComplete,
                  text: "Complete",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleComplete() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_dateOfBirth == null) return;
      widget.onComplete(
        UpdateUserRequest(
          username: _usernameController.text.trim(),
          sex: _selectedSex,
          dateOfBirth: _dateOfBirth,
        ),
      );
    }
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers and underscores allowed';
    }
    return null;
  }
}
