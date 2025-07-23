import 'package:everything_health_app/services/color_services.dart';
import 'package:everything_health_app/widgets/nav_bars.dart';
import 'package:everything_health_app/widgets/nav_item_builder.dart';
import 'package:flutter/material.dart';

class LogExcercisePage extends StatefulWidget {
  final int logExcerciseIndex;
  final int prevLogExcerciseIndex;
  final Function(String) goHome;
  final Function(int) onLogExcerciseSelection;

  const LogExcercisePage({
    required this.logExcerciseIndex,
    required this.prevLogExcerciseIndex,
    required this.goHome,
    required this.onLogExcerciseSelection,
  });

  @override
  State<LogExcercisePage> createState() => _LogExcercisePageState();
}

class _LogExcercisePageState extends State<LogExcercisePage> {

  @override
  Widget build(BuildContext context)
  {
    Color selectedColor = ColorTheme["textPrimary"]!;
    Color nonSelectedColor = ColorTheme["coloredGrey"]!;

    List<Widget> navItems = [
        buildNavItem(
            icon: Icons.arrow_back,
            label: "Back",
            colorUsed: ColorTheme["secondary"]!,
            onTap: () => widget.onLogExcerciseSelection(-1)),
        buildNavItem(
            icon: Icons.man,
            label: "Cardio",
            colorUsed: widget.logExcerciseIndex == 4 ? selectedColor : nonSelectedColor,
            onTap: () => widget.onLogExcerciseSelection(4)),
        buildNavItem(
            icon: Icons.fitness_center,
            label: "Strength",
            colorUsed: widget.logExcerciseIndex == 5 ? selectedColor : nonSelectedColor,
            onTap: () => widget.onLogExcerciseSelection(5)),
        buildNavItem(
            icon: Icons.edit_document,
            label: "Custom",
            colorUsed: widget.logExcerciseIndex == 6 ? selectedColor : nonSelectedColor,
            onTap: () => widget.onLogExcerciseSelection(6)),
    ];
      
    List<Widget> logExcercisePagesContent = [
      Container(margin: EdgeInsets.only(top: 90), color: Colors.deepPurple, child: Center(child: Text("CARDIO", style: TextStyle(color: Colors.white)))),
      Container(margin: EdgeInsets.only(top: 90), color: const Color.fromARGB(255, 18, 76, 32), child: Center(child: Text("Strength", style: TextStyle(color: Colors.white)))),
      Container(margin: EdgeInsets.only(top: 90), color: const Color.fromARGB(255, 87, 15, 15), child: Center(child: Text("Custom", style: TextStyle(color: Colors.white)))),
    ];
    Widget contentPage = logExcercisePagesContent[widget.logExcerciseIndex-4];

    return Material( // Add Material for background and theming
        child: Stack(children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: ColorTheme["veryLightGrey"]!, width: 1.0)),
            ),
            child: MyTopNavigationBar(
              logFoodIndex: widget.logExcerciseIndex,
              navItems: navItems,
            ),
          ),
          contentPage,
        ]),
      );
  }
}
