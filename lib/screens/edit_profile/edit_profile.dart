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

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
    required this.user,
    required this.updateUser,
    required this.isLoading,
  });

  final User user;
  final Function(UpdateUserRequest request) updateUser;
  final bool isLoading;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;

  late Sex _selectedSex;
  DateTime? _dateOfBirth;

  final DateTime _earliestDate = DateTime.now().subtract(const Duration(days: 36500));
  final DateTime _latestDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user.lastName ?? '');
    _usernameController = TextEditingController(text: widget.user.username ?? '');
    _selectedSex = widget.user.sex ?? Sex.UNDEFINED;
    _dateOfBirth = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
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

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.updateUser(
        UpdateUserRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          username: _usernameController.text.trim(),
          sex: _selectedSex,
          dateOfBirth: _dateOfBirth,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Edit Profile",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  onChanged: (value) => _firstNameController.text = value ?? '',
                ),
                const VerticalSpacer(16),
                InputField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  onChanged: (value) => _lastNameController.text = value ?? '',
                ),
                const VerticalSpacer(16),
                InputField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Letters, numbers, underscores only',
                  validatorFunction: _usernameValidator,
                  onChanged: (value) => _usernameController.text = value ?? '',
                ),
                const VerticalSpacer(16),
                Row(
                  children: [
                    DateInputWithDatePicker(
                      title: 'Date of Birth',
                      minimumDate: _earliestDate,
                      maximumDate: _latestDate,
                      date: _dateOfBirth,
                      width: 160,
                      onDateChanged: (newDate) => setState(() => _dateOfBirth = newDate),
                      validatorFunction: (_) => null,
                    ),
                    const Spacer(),
                    DropdownButton<Sex>(
                      value: _selectedSex,
                      onChanged: (Sex? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedSex = newValue);
                        }
                      },
                      items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
                        return DropdownMenuItem<Sex>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const VerticalSpacer(32),
                ButtonComponent.smallButton(
                  text: 'Save',
                  isLoading: widget.isLoading,
                  isDisabled: widget.isLoading,
                  onPressed: _onSave,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
