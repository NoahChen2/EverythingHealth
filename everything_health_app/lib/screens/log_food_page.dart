// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import '../widgets/nav_bars.dart'; // Import MyTopNavigationBar
import '../widgets/nav_item_builder.dart'; // Import buildNavItem
import 'log_food_screens/search_food_page.dart'; // Import SearchFoodPage
import '../widgets/choose_item.dart';
import 'dart:math';

class LogFoodPage extends StatefulWidget {
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
  State<LogFoodPage> createState() => _LogFoodPageState();
}

class _LogFoodPageState extends State<LogFoodPage> {
  static FoodItem defaultFood = FoodItem(name: "DEFAULT_NAME", serving_size: "DEFAULT_SERVING_SIZE", grams: -1, calories: -1, carbs: -1, fats: -1, protein: -1, sugar: -1, normalized_name: "NORMAL_DEFAULT_NAME");
  FoodItem _addingFood = defaultFood;
  
  Function _addingFoodFunc(FoodItem food){
    return () {
      setState((){
        _addingFood = food;
      });
    };
  }

  void _closeAddFood()
  {
    setState((){
      _addingFood = defaultFood;
    });
  }

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
          onTap: () => widget.onLogFoodSelection(-1)),
      buildNavItem(
          icon: Icons.search,
          label: "Search",
          colorUsed: widget.logFoodIndex == 0 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(0)),
      buildNavItem(
          icon: Icons.qr_code_scanner,
          label: "Barcode",
          colorUsed: widget.logFoodIndex == 1 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(1)),
      buildNavItem(
          icon: Icons.camera,
          label: "Photo",
          colorUsed: widget.logFoodIndex == 2 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(2)),
      buildNavItem(
          icon: Icons.history,
          label: "History",
          colorUsed: widget.logFoodIndex == 3 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(3)),
      buildNavItem(
          icon: Icons.bookmark,
          label: "Saved",
          colorUsed: widget.logFoodIndex == 4 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(4)),
    ];

    var logFoodPagesContent = [ // Specific content for each sub-page
      SearchFoodPage(addingFoodFunc: _addingFoodFunc),
      Container(color: Colors.blueAccent, child: const Center(child: Text("Scan Barcode Content"))),
      Container(color: const Color.fromARGB(255, 255, 68, 230), child: const Center(child: Text("Take Photo Content"))),
      Container(color: Colors.orangeAccent, child: const Center(child: Text("History Content"))),
      Container(color: Colors.blueGrey, child: const Center(child: Text("Favorites Content"))),
    ];

    Widget contentPage;
    int displayIndex = widget.logFoodIndex == -1 ? widget.prevLogFoodIndex : widget.logFoodIndex;
    if (displayIndex >= 0 && displayIndex < logFoodPagesContent.length) {
      contentPage = logFoodPagesContent[displayIndex];
    } else if (widget.prevLogFoodIndex >= 0 && widget.prevLogFoodIndex < logFoodPagesContent.length) {
      // Fallback to prevLogFoodIndex if current is invalid (e.g. during dismiss of a newly opened page)
      contentPage = logFoodPagesContent[widget.prevLogFoodIndex];
    }
     else {
      contentPage = Center(child: Text("Error: Page not found")); // Fallback
    }


    return Material( // Add Material for background and theming
      child: Stack(children: [
        Container(
          color: Theme.of(context).colorScheme.surface, // Use a theme color
          child: contentPage,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
          ),
          child: MyTopNavigationBar(
            logFoodIndex: widget.logFoodIndex,
            navItems: navItems,
          ),
        ),
        ChooseFoodItem(food: _addingFood, close: _closeAddFood)
      ]),
    );
  }
}

class FoodItem {
  final String name;
  final String serving_size;
  final num grams; // Can be int or double
  final num calories;
  final num carbs;
  final num fats;
  final num protein;
  final num sugar;
  final String normalized_name; // Added normalized_name for consistency
  final String container_size;
  final num code;
  final num id;
  final Color color;
  final String image_small_url;
  final String img_url;

  FoodItem({
    required this.name,
    required this.serving_size,
    required this.grams,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.protein,
    required this.sugar,
    required this.normalized_name,
    this.container_size = "",
    this.code = -1,
    this.id = -1,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    this.image_small_url = "",
    this.img_url = "",
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    num id = Random().nextInt(1000000);
    while(id != id){
      id = Random().nextInt(1000000);
    }
    return FoodItem(
      name: json['name'] ?? 'Unknown Food',
      serving_size: json['serving_size'] ?? 'N/A',
      grams: json['grams'] ?? 0,
      calories: json['calories'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fats: json['fats'] ?? 0,
      protein: json['protein'] ?? 0,
      sugar: json['sugar'] ?? 0,
      normalized_name: json['normalized_name'] ?? json['name'] ?? 'Unknown Food',
      code: json['code'] ?? -1,
      id: id,
      image_small_url: json['image_small_url'] ?? json['image_url'] ?? "NO_IMAGE_FOUND",
      img_url: json['image_url'] ?? json['image_small_url'] ?? "NO_IMAGE_FOUND",
    );
  }
}
