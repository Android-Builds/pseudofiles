import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme lightScheme = ColorScheme.fromSeed(seedColor: Colors.green);
final ColorScheme darkScheme =
    ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark);

// final Color accentColor = Colors.blue.shade200;
final Color accentColor = Colors.blue.shade200;

final lightThemeExp = ThemeData(
  colorSchemeSeed: Colors.green,
  brightness: Brightness.light,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.light().textTheme,
  ),
);
final darkThemeExp = ThemeData(
  colorSchemeSeed: Colors.green,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.dark().textTheme,
  ),
);

ThemeData lightTheme = ThemeData.light().copyWith(
  androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.light().textTheme,
  ),
  backgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Colors.white,
    iconTheme: iconTheme,
    titleTextStyle: const TextStyle(color: Colors.black),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: fontStyle,
    labelStyle: fontStyle.copyWith(color: Colors.black),
    labelColor: accentColor,
    unselectedLabelColor: Colors.black,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: accentColor,
        width: 2.0,
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  backgroundColor: Colors.grey.shade900,
  applyElevationOverlayColor: true,
  cardColor: Colors.grey[900],
  visualDensity: VisualDensity.adaptivePlatformDensity,
  canvasColor: Colors.black,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.dark().textTheme,
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) => accentColor),
    checkColor: MaterialStateProperty.resolveWith((states) => Colors.black),
  ),
  radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) => accentColor)),
  iconTheme: const IconThemeData(color: Colors.white),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith((states) => accentColor),
  )),
  scaffoldBackgroundColor: Colors.black,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[900],
  ),
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Colors.black,
    iconTheme: iconTheme,
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: fontStyle,
    labelStyle: fontStyle,
    labelColor: accentColor,
    unselectedLabelColor: Colors.white,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: accentColor,
        width: 2.0,
      ),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade900),
  dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[900],
    actionTextColor: accentColor,
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
);

TextStyle fontStyle = GoogleFonts.montserrat();

IconThemeData iconTheme = IconThemeData(color: accentColor);
