import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/extensions/date_extension.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
    required this.user,
    required this.updateUser,
    required this.uploadProfileImage,
    required this.isLoading,
    required this.isUploadingImage,
  });

  final User user;
  final Function(UpdateUserRequest request) updateUser;
  final Function(File imageFile) uploadProfileImage;
  final bool isLoading;
  final bool isUploadingImage;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _dobController;

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
    _dobController = TextEditingController(text: widget.user.dateOfBirth?.formatDate() ?? '');
    _selectedSex = widget.user.sex ?? Sex.UNDEFINED;
    _dateOfBirth = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username cannot be empty';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Letters, numbers and underscores only';
    }
    return null;
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.updateUser(UpdateUserRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        sex: _selectedSex,
        dateOfBirth: _dateOfBirth,
      ));
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) widget.uploadProfileImage(File(picked.path));
  }

  String _buildImageUrl(String path) {
    if (path.startsWith('http')) return path;
    final uri = Uri.tryParse(dotenv.env['API_BASE_URI'] ?? '');
    if (uri == null) return path;
    return '${uri.scheme}://${uri.host}:${uri.port}$path';
  }

  String _sexLabel(Sex sex) {
    switch (sex) {
      case Sex.MALE:
        return 'Male';
      case Sex.FEMALE:
        return 'Female';
      case Sex.UNDEFINED:
        return 'Prefer not to say';
    }
  }

  Future<void> _showDatePicker() async {
    DateTime tempDate = _dateOfBirth ?? DateTime(2000);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VerticalSpacer(12),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const VerticalSpacer(16),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const VerticalSpacer(8),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      minimumDate: _earliestDate,
                      maximumDate: _latestDate,
                      initialDateTime: _dateOfBirth ?? DateTime(2000),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (d) => tempDate = d,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _dateOfBirth = tempDate;
                            _dobController.text = tempDate.formatDate();
                          });
                        },
                        child: const Text('Select', style: TextStyle(fontSize: 15)),
                      ),
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

  // ── Decoration helpers ───────────────────────────────────────────────────

  static final _enabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
  );
  static final _focusedBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.5),
  );
  static final _disabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
  );
  static final _errorBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400, width: 1),
  );

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: enabled ? Colors.grey.shade500 : Colors.grey.shade400,
        fontSize: 14,
      ),
      floatingLabelStyle: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey.shade400,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      suffixIcon: suffix,
      border: _enabledBorder,
      enabledBorder: _enabledBorder,
      focusedBorder: _focusedBorder,
      disabledBorder: _disabledBorder,
      errorBorder: _errorBorder,
      focusedErrorBorder: _errorBorder,
      filled: false,
      isDense: false,
      contentPadding: const EdgeInsets.only(bottom: 10, top: 6),
      errorStyle: const TextStyle(fontSize: 11),
    );
  }

  // ── Photo ────────────────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    final imageUrl = widget.user.profileImageUrl;
    final fullUrl = imageUrl != null ? _buildImageUrl(imageUrl) : null;
    final initials = widget.user.getUserInitials();

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                image: fullUrl != null
                    ? DecorationImage(fit: BoxFit.cover, image: NetworkImage(fullUrl))
                    : null,
              ),
              child: fullUrl == null
                  ? Center(
                      child: initials.isNotEmpty
                          ? Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.person, size: 48, color: Colors.grey.shade500),
                    )
                  : null,
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: widget.isUploadingImage ? null : _pickAndUploadImage,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: widget.isUploadingImage
                      ? const Padding(
                          padding: EdgeInsets.all(6),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.edit, color: Colors.white, size: 15),
                ),
              ),
            ),
          ],
        ),
        const VerticalSpacer(10),
        Text(
          'Change photo',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: const CustomText('Edit Profile', style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        showDefaultActions: false,
        actions: [
          TextButton(
            onPressed: widget.isLoading ? null : _onSave,
            child: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
          const HorizontalSpacer(4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpacer(32),
                Center(child: _buildPhotoSection()),
                const VerticalSpacer(36),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _fieldDecoration(label: 'First Name', icon: Icons.person_outline),
                ),
                const VerticalSpacer(20),

                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _fieldDecoration(label: 'Last Name', icon: Icons.person_outline),
                ),
                const VerticalSpacer(20),

                // Username
                TextFormField(
                  controller: _usernameController,
                  validator: _usernameValidator,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _fieldDecoration(label: 'Username', icon: Icons.alternate_email),
                ),
                const VerticalSpacer(20),

                // Email (read-only)
                TextFormField(
                  initialValue: widget.user.email,
                  enabled: false,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                  decoration: _fieldDecoration(
                    label: 'Email',
                    icon: Icons.mail_outline,
                    enabled: false,
                    suffix: Icon(Icons.lock_outline, size: 15, color: Colors.grey.shade300),
                  ),
                ),
                const VerticalSpacer(20),

                // Tag (read-only)
                TextFormField(
                  initialValue: widget.user.tag != null ? '@${widget.user.tag}' : '',
                  enabled: false,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                  decoration: _fieldDecoration(
                    label: 'Tag',
                    icon: Icons.label_outline,
                    enabled: false,
                    suffix: Icon(Icons.lock_outline, size: 15, color: Colors.grey.shade300),
                  ),
                ),
                const VerticalSpacer(20),

                // Date of Birth
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _showDatePicker,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _fieldDecoration(
                    label: 'Date of Birth',
                    icon: Icons.calendar_today_outlined,
                    suffix: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
                  ),
                ),
                const VerticalSpacer(20),

                // Gender
                DropdownButtonFormField<Sex>(
                  value: _selectedSex,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  icon: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
                  decoration: _fieldDecoration(label: 'Gender', icon: Icons.wc_outlined),
                  items: Sex.values
                      .map((v) => DropdownMenuItem(value: v, child: Text(_sexLabel(v))))
                      .toList(),
                  onChanged: (v) { if (v != null) setState(() => _selectedSex = v); },
                ),

                const VerticalSpacer(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
