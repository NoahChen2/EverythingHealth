// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:everything_health_app/screens/log_food_page.dart';
import 'package:everything_health_app/services/color_services.dart';
import 'package:flutter/material.dart';

Widget EHMenuButton({
  double height = 100,
  double width = 500,
  Widget child = const SizedBox.shrink(),
  Color? color,
  Color? borderColor,
  double borderRadiusValue = 20,
  double borderWidth = 2,
  BorderRadius? borderRadius,
  Border? border,
  VoidCallback? onTap,
  EdgeInsetsGeometry? padding,
  double paddingValue = 5,
  EdgeInsetsGeometry? margin, 
  double marginValue = 10,
  Decoration? decoration,
  
}) {
  color = color ?? ColorTheme["primaryBGAlt"]!;
  borderColor = borderColor ?? ColorTheme["primaryLight"]!.withAlpha(50);
  onTap = onTap ?? (){};
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding ?? EdgeInsets.all(paddingValue),
      margin: margin ?? EdgeInsets.only(top: marginValue * 2, left: marginValue, right: marginValue),
      height: height,
      width: width,
      decoration: decoration ?? 
        BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(borderRadiusValue), // Relative radius
      ),
      foregroundDecoration: BoxDecoration(
          border: border ?? Border.all(color: borderColor, width: borderWidth),
          borderRadius: borderRadius ?? BorderRadius.circular(borderRadiusValue),
      ),
      child: child,
    ),
  );
}

Widget EHFoodItemCard({
  required FoodItem food, 
  required Function saveFoodFunc, 
  required Function addFoodFunc,
  required Function addFoodToHistory, 
  Function? afterSaveFunc, 
  double height = 100, 
  double width = 100,
  double borderRadiusValue = 20,
  Color? textColor,
  Color? bgColor,
  double nutrientFontSize = 12,
  double nameFontSize = 16,
  double iconSize = 20,
  }) {
  afterSaveFunc = afterSaveFunc ?? () {};
  textColor = textColor ?? ColorTheme["textPrimary"];
  bgColor = bgColor ?? ColorTheme["primaryBGAlt"];
  // The root container defines the border and rounded corners for the whole card.
  return EHMenuButton(
    width: width,
    height: height,
    borderRadiusValue: borderRadiusValue,
    onTap: addFoodFunc(food),
    paddingValue: 0,
    marginValue: 0,
    // ClipRRect ensures all children (like the image area) respect the rounded corners.
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
        child: Column(
          // The main layout is a Column with two Expanded sections.
          // This gives each section a clearly defined, fixed height.
          children: [
            // The top section of the card (image, stats)
            Expanded(
              flex: 10, // Give this section 60% of the height
              child: Container(
                width: double.infinity,
                height: height * .4,
                color: food.color,
                child: Row(
                  children: [
                    // Position the stats at the top right
                    Expanded(
                      flex: 6,
                      child: UniversalImage(path: food.image_small_url, fit: BoxFit.contain)
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: height * .4,
                        padding: EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Using AutoSizeText for the stats
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                food.serving_size,
                                maxLines: 1,
                                minFontSize: 1,
                                maxFontSize: nutrientFontSize * 5/3,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: nutrientFontSize, // The starting font size
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                "${food.calories.toStringAsFixed(0)} kcal",
                                maxLines: 1,
                                minFontSize: 1,
                                maxFontSize: nutrientFontSize * 5/3,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: textColor!,
                                  fontSize: nutrientFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // The bottom section of the card (food name)
            Expanded(
              flex: 5, // Give this section 40% of the height
              child: Container(
                width: double.infinity,
                color: bgColor,
                // Center the text vertically and horizontally
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    // Using AutoSizeText for the name. It works here because its parent
                    // Expanded gives it a clear, fixed area to fill.
                    child: AutoSizeText.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                          text: food.servings != 1 ? "(${(food.servings).toStringAsPrecision(2)}) " : "",
                          style: TextStyle(color: textColor.withAlpha(179)),
                          ),
                          TextSpan(
                          text: food.name,
                          style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      minFontSize: 1,
                      maxFontSize: nameFontSize * 60/16,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontSize: nameFontSize, fontWeight: FontWeight.w600,),
                    ),
                  ),
                ),
              ),
            ),
            Divider(color: textColor.withAlpha(38), height: 1),
            Container(height: 5, color: bgColor,),
            Expanded(
              flex: 4,
              child: Container(
                  width: double.infinity,
                  color: bgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () => addFoodToHistory(food),
                            child: Icon(Icons.add, color: textColor, size: iconSize)),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              await saveFoodFunc(food);
                              afterSaveFunc!();
                            },
                            child: Icon(
                                food.isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: textColor, size: iconSize)),
                      )
                    ],
                  )),
            ),
          ],
        ),
    ),
  );
}

Widget EHPopupDisplay({
  Color? color,
  Color? darkenColor,
  Color? borderColor,
  required Widget child,
  required Function() dismiss,
  double height = 600,
  double width = 600,
  double borderRadiusValue = 20,
  BoxBorder? border,
  BorderRadiusGeometry? borderRadius,
  double borderWidth = 2,
  double closeButtonSize = 50,
  required double closeTop,
  required double closeLeft,
  Color? closeBGColor,
  Color? closeIconColor,
})
{
  color = color ?? ColorTheme["primaryBG"];
  darkenColor = darkenColor ?? ColorTheme["darkenMain"];
  borderColor = borderColor ?? ColorTheme["primaryLight"]!.withAlpha(50);
  closeBGColor = closeBGColor ?? ColorTheme["primary"];
  closeIconColor = closeIconColor ?? ColorTheme["textPrimary"];
  return Stack(children: [
    GestureDetector(
            onTap: dismiss,
            child: Container(
              decoration: BoxDecoration(color: ColorTheme["darkenMain"]),
            )),
        Center(
            child: Container(
                height: height,
                width: width,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: borderRadius ?? BorderRadius.circular(borderRadiusValue),
                ),
                foregroundDecoration: BoxDecoration(
                  border: border ?? Border.all(color: borderColor, width: borderWidth),
                  borderRadius: borderRadius ?? BorderRadius.circular(borderRadiusValue),
                ),
                child: child,
            )
        ),
      Positioned(
              top: closeTop,
              left: closeLeft,
              child: GestureDetector(
                onTap: dismiss,
                child: Container(
                  height: closeButtonSize,
                  width: closeButtonSize,
                  decoration: BoxDecoration(
                      color: closeBGColor,
                      borderRadius: BorderRadius.circular(closeButtonSize)),
                  child: Icon(
                    Icons.close,
                    color: closeIconColor,
                  ),
                ),
              )),
  ]);
}