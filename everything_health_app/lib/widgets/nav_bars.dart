import 'package:everything_health_app/services/color_services.dart';
import 'package:flutter/material.dart';
import 'nav_item_builder.dart'; // Import the new nav item builder


class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigatorSelection;
  final Function() addButtonSelector;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavigatorSelection,
    required this.addButtonSelector,
  });

  @override
  Widget build(BuildContext context) {
    double barHeight = 90;
    Color barColor = ColorTheme["primaryBG"]!;
    Color plusColor = ColorTheme["tertiary"]!;
    Color addColor = ColorTheme["textPrimary"]!.withAlpha(200);
    Color nonSelectedColor = ColorTheme["coloredGrey"]!;
    Color selectedColor = ColorTheme["textPrimary"]!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent, // Use transparent for Material
        child: SizedBox(
          width: double.infinity,
          height: barHeight * 1.5,
          child: LayoutBuilder(builder: (context, constraints) {
            double circleDiameter = constraints.maxWidth / 5;
            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(0, barHeight * .5),
                  child: Container(
                    height: barHeight,
                    color: barColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildNavItem( // Use the imported builder
                          icon: Icons.home,
                          label: "Dashboard",
                          colorUsed: currentIndex == 0 ? selectedColor : nonSelectedColor,
                          onTap: () => onNavigatorSelection(0),
                        ),
                        buildNavItem(
                          icon: Icons.calendar_month,
                          label: "Calendar",
                          colorUsed: currentIndex == 1 ? selectedColor : nonSelectedColor,
                          onTap: () => onNavigatorSelection(1),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                        buildNavItem(
                          icon: Icons.playlist_play_rounded,
                          label: "Plan",
                          colorUsed: currentIndex == 2 ? selectedColor : nonSelectedColor,
                          onTap: () => onNavigatorSelection(2),
                        ),
                        buildNavItem(
                          icon: Icons.settings,
                          label: "Settings",
                          colorUsed: currentIndex == 3 ? selectedColor : nonSelectedColor,
                          onTap: () => onNavigatorSelection(3),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: circleDiameter,
                    width: circleDiameter,
                    child: InkWell(
                      onTap: addButtonSelector,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Icon(
                            Icons.circle,
                            color: plusColor,
                            size: circleDiameter,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: addColor,
                              size: circleDiameter * 0.75,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class MyTopNavigationBar extends StatelessWidget {
  final int logFoodIndex;
  final List<Widget> navItems; // navItems are already built Widgets passed in

  const MyTopNavigationBar({
    super.key,
    required this.logFoodIndex,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    Color barColor = ColorTheme["primaryBG"]!;
    return Column(
      children: [
        Container(height: 29, color: barColor,),
        Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Container(
                color: barColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: navItems,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}