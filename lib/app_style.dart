import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBackground = Colors.white;
  static const Color lightText = Color(0xFF7E7E7E);
  static const Color lightSelect = Colors.black;
  static const Color lightIcon = Color(0xFF7E7E7E);
  static const Color lightIconButton = Colors.black;
  static const Color lightButtonBackground = Color(0xFFE7E7E7);
  static const Color blueButtonBackground = Color.fromRGBO(2, 136, 209, 1);
  static const Icon lightDarkMode = Icon(
    Icons.dark_mode,
    color: lightIcon,
    size: 25,
  );
  static const AssetImage lightUAM = AssetImage('assets/img/light_uam.png');

  static const Color darkBackground = Color(0xFF141414);
  static const Color darkext = Color(0xFFAFAFAF);
  static const Color darkSelect = Colors.white;
  static const Color darkIcon = Color(0xFF767676);
  static const Color darkIconButton = Colors.white;
  static const Color darkButtonBackground = Color(0xFF1F1F1F);
  static const Icon darkDarkMode = Icon(
    Icons.light_mode,
    color: darkIcon,
    size: 25,
  );
  static const AssetImage darkUAM = AssetImage('assets/img/dark_uam.png');
}
