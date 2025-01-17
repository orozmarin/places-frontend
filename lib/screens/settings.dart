import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Settings", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: const Center(
        child: CustomText("Your settings"),
      ),
    );
  }
}
