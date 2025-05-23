import 'package:flutter/material.dart';
import '../widgets/nav_bars.dart'; // Import MyTopNavigationBar
import '../widgets/nav_item_builder.dart'; // Import buildNavItem

class LogFoodPage extends StatelessWidget {
  final int prevLogFoodIndex;
  final int logFoodIndex;
  final Function(int) onLogFoodSelection;

  const LogFoodPage({
    super.key,
    this.logFoodIndex = -1,
    required this.prevLogFoodIndex,
    required this.onLogFoodSelection,
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Colors.white;
    Color nonSelectedColor = const Color.fromARGB(255, 117, 115, 119);

    // Nav items are built here now using the imported builder
    var navItems = [
      buildNavItem(
          icon: Icons.arrow_back,
          label: "Back",
          colorUsed: const Color.fromARGB(255, 75, 223, 179),
          onTap: () => onLogFoodSelection(-1)),
      buildNavItem(
          icon: Icons.search,
          label: "Search",
          colorUsed: logFoodIndex == 0 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(0)),
      buildNavItem(
          icon: Icons.qr_code_scanner,
          label: "Barcode",
          colorUsed: logFoodIndex == 1 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(1)),
      buildNavItem(
          icon: Icons.camera,
          label: "Photo",
          colorUsed: logFoodIndex == 2 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(2)),
      buildNavItem(
          icon: Icons.history,
          label: "History",
          colorUsed: logFoodIndex == 3 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(3)),
      buildNavItem(
          icon: Icons.star,
          label: "Favorites",
          colorUsed: logFoodIndex == 4 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(4)),
    ];

    var logFoodPagesContent = [ // Specific content for each sub-page
      Container(color: Colors.amber, child: const Center(child: Text("Search Food Content"))),
      Container(color: Colors.blueAccent, child: const Center(child: Text("Scan Barcode Content"))),
      Container(color: const Color.fromARGB(255, 255, 68, 230), child: const Center(child: Text("Take Photo Content"))),
      Container(color: Colors.orangeAccent, child: const Center(child: Text("History Content"))),
      Container(color: Colors.blueGrey, child: const Center(child: Text("Favorites Content"))),
    ];

    Widget contentPage;
    int displayIndex = logFoodIndex == -1 ? prevLogFoodIndex : logFoodIndex;
    if (displayIndex >= 0 && displayIndex < logFoodPagesContent.length) {
      contentPage = logFoodPagesContent[displayIndex];
    } else if (prevLogFoodIndex >= 0 && prevLogFoodIndex < logFoodPagesContent.length) {
      // Fallback to prevLogFoodIndex if current is invalid (e.g. during dismiss of a newly opened page)
      contentPage = logFoodPagesContent[prevLogFoodIndex];
    }
     else {
      contentPage = Center(child: Text("Error: Page not found")); // Fallback
    }


    return Material( // Add Material for background and theming
      child: Stack(children: [
        Container(
          padding: EdgeInsets.only(top: 60), // Adjust if MyTopNavigationBar height changes
          color: Theme.of(context).colorScheme.surface, // Use a theme color
          child: contentPage,
        ),
        MyTopNavigationBar(
          logFoodIndex: logFoodIndex,
          navItems: navItems,
        ),
      ]),
    );
  }
}