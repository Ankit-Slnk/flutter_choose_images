import 'dart:ui';

import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(4, 131, 184, .1),
  100: Color.fromRGBO(4, 131, 184, .2),
  200: Color.fromRGBO(4, 131, 184, .3),
  300: Color.fromRGBO(4, 131, 184, .4),
  400: Color.fromRGBO(4, 131, 184, .5),
  500: Color.fromRGBO(4, 131, 184, .6),
  600: Color.fromRGBO(4, 131, 184, .7),
  700: Color.fromRGBO(4, 131, 184, .8),
  800: Color.fromRGBO(4, 131, 184, .9),
  900: Color.fromRGBO(4, 131, 184, 1),
};

class AppColors {
  //name of color used in app
  static Color appColor = MaterialColor(0xFF42C25E, color);
  static Color appColorLight = MaterialColor(0xffE1EFD2, color);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color background = Colors.grey[200];
  static Color googleColor = Color(0xff4285F4);
  static Color appbackgroundcolor = Color(0xffebf0f4);
  static Color blackBackGround = Colors.black87;
  static Color greyText = Colors.grey.shade700;
}
