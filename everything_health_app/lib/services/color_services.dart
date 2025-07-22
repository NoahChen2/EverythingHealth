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
    "secondaryBGAlt": const Color.fromARGB(255, 49, 110, 98),
    "tertiary": const Color.fromARGB(255, 255, 64, 129),
    "tertiaryBG": const Color.fromARGB(255, 132, 79, 97),
    "tertiaryBGAlt": const Color.fromARGB(255, 147, 101, 116),
    "darkenMain": const Color.fromARGB(150, 0, 0, 0),
    "darkenSecondary": const Color.fromARGB(85, 0, 0, 0),
    "grey": const Color.fromARGB(255, 97, 97, 97),
    "coloredGrey": const Color.fromARGB(255, 119, 122, 134),
    "veryLightGrey": const Color.fromARGB(255, 224, 224, 224),
    "lightGrey": const Color.fromARGB(255, 158, 158, 158),
    "darkGrey": const Color.fromARGB(255, 66, 66, 66),
    "transparent": const Color.fromARGB(0,0,0,0),
    "white": const Color.fromARGB(255, 255, 255, 255),
    "black": const Color.fromARGB(255, 0, 0, 0),
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
    "secondaryBGAlt": const Color.fromARGB(255, 193, 209, 206),
    "tertiary": const Color.fromARGB(255, 217, 59, 111),
    "tertiaryBG": const Color.fromARGB(255, 189, 157, 168),
    "tertiaryBGAlt": const Color.fromARGB(255, 219, 199, 206),
    "darkenMain": const Color.fromARGB(150, 0, 0, 0),
    "darkenSecondary": const Color.fromARGB(85, 0, 0, 0),
    "grey": const Color.fromARGB(255, 97, 97, 97),
    "coloredGrey": const Color.fromARGB(255, 119, 122, 134),
    "veryLightGrey": const Color.fromARGB(255, 224, 224, 224),
    "lightGrey": const Color.fromARGB(255, 158, 158, 158),
    "darkGrey": const Color.fromARGB(255, 66, 66, 66),
    "transparent": const Color.fromARGB(0,0,0,0),
    "white": const Color.fromARGB(255, 255, 255, 255),
    "black": const Color.fromARGB(255, 0, 0, 0),
  };
  
  static ColorScheme createColorSchemeFromMap(Map<String, Color> colorMap) {
    // Determine brightness based on the background color's luminance
    final Brightness brightness =
        (colorMap["primaryBG"] ?? Colors.white).computeLuminance() < 0.5
            ? Brightness.dark
            : Brightness.light;

    return ColorScheme(
      brightness: brightness,

      // Map your custom keys to the standard ColorScheme properties
      primary: colorMap["primary"] ?? Colors.blue,
      onPrimary: colorMap["textPrimary"] ?? Colors.white,

      secondary: colorMap["secondary"] ?? Colors.teal,
      onSecondary: colorMap["textSecondary"] ?? Colors.black,

      tertiary: colorMap["tertiary"] ?? Colors.pink,
      onTertiary: colorMap["textSecondary"] ?? Colors.black,

      surface: colorMap["primaryBGAlt"] ?? Colors.grey[700]!,
      onSurface: colorMap["textPrimary"] ?? Colors.white,

      // Provide sensible defaults for colors not in your map
      error: Colors.red[700]!,
      onError: Colors.white,
    );
  }
  static Map<String, Color> colorTheme(){
    return darkColors;
  }
}