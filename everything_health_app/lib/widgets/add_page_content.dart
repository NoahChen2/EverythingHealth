import 'dart:math' as math;

import 'package:everything_health_app/services/color_services.dart';
import 'package:everything_health_app/widgets/eh_widgets.dart';
import 'package:flutter/material.dart';

// Moved _menuOptionRectangle here (can be kept private if only used by AddPage)
Widget _menuOptionRectangle({
  required IconData icon,
  required String label,
  required Color colorUsed,
  required double height,
  required double width,
  required VoidCallback onTap,
}) {
  return EHMenuButton(
    onTap: onTap,
    height: height * .95,
    width: width * .95,
    margin: EdgeInsets.only(left: height * .05,right: height * .05, bottom: height * .2, top: height * .1),
    paddingValue: 0,
    borderRadiusValue: height * .08,
    child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Icon(icon,
                    color: colorUsed, size: height * .5), // Relative icon size
                SizedBox(height: height * .05), // Relative spacing
                Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorTheme["textPrimary"],
                      fontSize: height / 7, // Relative font size
                      decoration: TextDecoration.none,
                    )),
              ])),
  );

}

class AddPage extends StatelessWidget {
  final Widget backgroundPage;
  final VoidCallback onDismissRequest;
  final Function(int) onLogFoodSelection;
  final double currentVisualUpwardOverdragPixels;

  const AddPage({
    super.key,
    required this.backgroundPage,
    required this.onDismissRequest,
    required this.currentVisualUpwardOverdragPixels,
    required this.onLogFoodSelection,
  });

  @override
  
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double pageHeight = constraints.maxHeight;
      double pageWidth = constraints.maxWidth;
      double defaultOrangeHeight = pageHeight * 0.5;
      double upwardExpansion = currentVisualUpwardOverdragPixels;
      double currentOrangeHeight = (defaultOrangeHeight + upwardExpansion)
          .clamp(0.0, pageHeight * 0.75); // Max 75% effective height

      double menuOptionWidth = (pageWidth - 20) / 4;
      double menuOptionHeight = menuOptionWidth * (2 / 3);
      menuOptionHeight = math.min(menuOptionHeight, (defaultOrangeHeight - 80) / 3);


      return Stack(children: [
        // This GestureDetector can cover the area behind the Align widget
        // if needed for dismiss. Or rely on the dimmed background's GestureDetector.
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismissRequest, // Dismiss if tapping outside content
            child: Container(color: Colors.transparent), // Make it hittable
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,            
            child: SizedBox(
              height: currentOrangeHeight,
              child: GestureDetector(
                // To prevent taps on content from dismissing
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      color: ColorTheme["primaryBG"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("Log Food",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: ColorTheme["textPrimary"],
                                overflow: TextOverflow.clip,
                                decoration: TextDecoration.none,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.search,
                                  label: "Food",
                                  colorUsed: Colors.purple,
                                  onTap: () => onLogFoodSelection(0)),
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.camera,
                                  label: "Scan",
                                  colorUsed: Colors.green,
                                  onTap: () => onLogFoodSelection(1)),
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.app_registration_rounded,
                                  label: "Manual",
                                  colorUsed: const Color.fromARGB(255, 8, 165, 237),
                                  onTap: () => onLogFoodSelection(2)),
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.shelves, // Changed Icon
                                  label: "Library", // Changed Label
                                  colorUsed: Colors.deepOrange, // Changed Color
                                  onTap: () =>
                                      onLogFoodSelection(3)), // Changed Index
                            ]
                          ),
                          const SizedBox(height: 5),
                          Text("Log Excercise",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.clip,
                                fontSize: 20,
                                color: ColorTheme["textPrimary"],
                                decoration: TextDecoration.none,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.man,
                                  label: "Cardio",
                                  colorUsed: Colors.blue,
                                  onTap: () => onLogFoodSelection(4)),
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.fitness_center,
                                  label: "Strength",
                                  colorUsed: Colors.red,
                                  onTap: () => onLogFoodSelection(5)),
                              _menuOptionRectangle(
                                  height: menuOptionHeight,
                                  width: menuOptionWidth,
                                  icon: Icons.edit_document,
                                  label: "Custom",
                                  colorUsed: Colors.green,
                                  onTap: () => onLogFoodSelection(6)),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ))
      ]);
    });
  }
}
