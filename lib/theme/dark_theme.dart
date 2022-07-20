import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFF28a880),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF2C2C2C),
  cardColor: Color(0xFF121212),
  hintColor: Color(0xFFE7F6F8),
  focusColor: Color(0xFFADC4C8),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
