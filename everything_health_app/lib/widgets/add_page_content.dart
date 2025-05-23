import 'dart:math' as math;

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
  return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(height * .05), // Relative margin

      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 70, 101),
          borderRadius: BorderRadius.circular(height * .08), // Relative radius
        ),
        child: Stack(children: [
          Center(
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
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: height / 7, // Relative font size
                      decoration: TextDecoration.none,
                    )),
              ])),
          Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.black.withAlpha(120), // Corrected
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(height * .08),
                onTap: onTap,
              )),
        ]),
      ));
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

      double menuOptionWidth = (pageWidth - 20) / 3;
      double menuOptionHeight = menuOptionWidth * (2 / 3);
      menuOptionHeight = math.min(menuOptionHeight, (defaultOrangeHeight - 120) / 3); 
      menuOptionWidth = menuOptionHeight * 1.5;


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
            child: GestureDetector(
              // To prevent taps on content from dismissing
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                  height: currentOrangeHeight,
                  width: double.infinity,
                  child: Container(
                    color: const Color.fromARGB(255, 255, 153, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text("Log Food",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                icon: Icons.qr_code_scanner,
                                label: "Barcode",
                                colorUsed: Colors.green,
                                onTap: () => onLogFoodSelection(1)),
                            _menuOptionRectangle(
                                height: menuOptionHeight,
                                width: menuOptionWidth,
                                icon: Icons.camera,
                                label: "Photo",
                                colorUsed: const Color.fromARGB(255, 8, 165, 237),
                                onTap: () => onLogFoodSelection(2)),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _menuOptionRectangle(
                                height: menuOptionHeight,
                                width: menuOptionWidth,
                                icon: Icons.history, // Changed Icon
                                label: "History", // Changed Label
                                colorUsed: Colors.deepOrange, // Changed Color
                                onTap: () =>
                                    onLogFoodSelection(3)), // Changed Index
                            _menuOptionRectangle(
                                height: menuOptionHeight,
                                width: menuOptionWidth,
                                icon: Icons.favorite, // Changed Icon
                                label: "Favorites", // Changed Label
                                colorUsed: Colors.yellowAccent, // Changed Color
                                onTap: () =>
                                    onLogFoodSelection(4)), // Changed Index
                          ],
                        ),
                        const Text("Log Excercise",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                          ],
                        )
                      ],
                    ),
                  )),
            ))
      ]);
    });
  }
}
