import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ColorScheme lightScheme(Color color) => ColorScheme.fromSeed(seedColor: color);
ColorScheme darkScheme(Color color) =>
    ColorScheme.fromSeed(seedColor: color, brightness: Brightness.dark);

final Color accentColor = Colors.blue.shade200;
// Color accentColor = lightScheme.secondary;

lightThemeExp(Color color) => ThemeData(
      //colorScheme: lightScheme,
      colorSchemeSeed: color,
      //colorScheme: lightScheme(color),
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      brightness: Brightness.light,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.light().textTheme,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: lightScheme(color).background,
        elevation: 0.0,
        //iconTheme: iconTheme,
        foregroundColor: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
            (states) => lightScheme(color).primary),
        checkColor: MaterialStateProperty.resolveWith(
            (states) => lightScheme(color).background),
      ),
    );

darkThemeExp(Color color) => ThemeData(
      colorSchemeSeed: color,
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.dark().textTheme,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: darkScheme(color).background,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkScheme(color).secondary),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
            (states) => darkScheme(color).primary),
        checkColor: MaterialStateProperty.resolveWith(
            (states) => darkScheme(color).background),
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
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0.0,
    color: Colors.white,
    iconTheme: iconTheme,
    foregroundColor: Colors.black,
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
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
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
