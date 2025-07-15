
import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Map<String, Color> ColorTheme = ColorServices.colorTheme();

class ColorServices {
  static final Map<String, Color> darkColors = {
    "primary": const Color.fromARGB(255, 0, 128, 255),
    "primaryLight": const Color.fromARGB(255, 129, 192, 255),
    "primaryBG": const Color.fromARGB(255, 14, 42, 69),
    "primaryBGAlt": const Color.fromARGB(255, 41, 71, 100),
    "primaryBGDark": const Color.fromARGB(255, 6, 23, 39),
    "textPrimary": const Color.fromARGB(255, 255, 255, 255),
    "textSecondary": const Color.fromARGB(255, 0, 0, 0),
    "secondary": const Color.fromARGB(255, 65, 224, 192),
    "secondaryBG": const Color.fromARGB(255, 26, 87, 75),
    "tertiary": const Color.fromARGB(255, 255, 64, 129),
    "tertiaryBG": const Color.fromARGB(255, 132, 79, 97),
    "darkenMain": const Color.fromARGB(150, 0, 0, 0),
    "darkenSecondary": const Color.fromARGB(85, 0, 0, 0),
    "grey": const Color.fromARGB(255, 97, 97, 97),
    "coloredGrey": const Color.fromARGB(255, 119, 122, 134),
    "veryLightGrey": const Color.fromARGB(255, 224, 224, 224),
    "lightGrey": const Color.fromARGB(255, 158, 158, 158),
    "darkGrey": const Color.fromARGB(255, 66, 66, 66),
  };

  static final Map<String, Color> lightColors = {
    "primary": const Color.fromARGB(255, 102, 179, 255),
    "primaryLight": const Color.fromARGB(255, 160, 207, 255),
    "primaryBG": const Color.fromARGB(255, 202, 215, 229),
    "primaryBGAlt": const Color.fromARGB(255, 240, 248, 255),
    "primaryBGDark": const Color.fromARGB(255, 149, 168, 189),
    "textPrimary": const Color.fromARGB(255, 0, 0, 0),
    "textSecondary": const Color.fromARGB(255, 255, 255, 255),
    "secondary": const Color.fromARGB(255, 39, 141, 121),
    "secondaryBG": const Color.fromARGB(255, 149, 177, 171),
    "tertiary": const Color.fromARGB(255, 217, 59, 111),
    "tertiaryBG": const Color.fromARGB(255, 189, 157, 168),
    "darkenMain": const Color.fromARGB(150, 0, 0, 0),
    "darkenSecondary": const Color.fromARGB(85, 0, 0, 0),
    "grey": const Color.fromARGB(255, 97, 97, 97),
    "coloredGrey": const Color.fromARGB(255, 119, 122, 134),
    "veryLightGrey": const Color.fromARGB(255, 224, 224, 224),
    "lightGrey": const Color.fromARGB(255, 158, 158, 158),
    "darkGrey": const Color.fromARGB(255, 66, 66, 66),
  };

  static Map<String, Color> colorTheme(){
    return darkColors;
  }
}