// ignore_for_file: non_constant_identifier_names
import 'package:everything_health_app/main.dart';
import 'package:everything_health_app/models/saved_foods.dart';
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
  final Function(String) goHome;

  const LogFoodPage({
    super.key,
    this.logFoodIndex = -1,
    required this.prevLogFoodIndex,
    required this.onLogFoodSelection,
    required this.goHome,
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

  bool _checkSavedFood(FoodItem food) {
    return food.isSaved;
  }

  Future<void> _addFoodToSaved(FoodItem food)
  async {
    bool tempSaved = _checkSavedFood(food);
    if (tempSaved){
      food.isSaved = false;
      await isar.writeTxn(() async {
        await isar.savedFoods.delete(food.id);
      });
    }
    else{
      print('Saving... ${food.name}');
      food.isSaved = true;
      SavedFood newEntry = SavedFood.fromJson(food.toJson());
      
      await isar.writeTxn(() async {
        // Take your 'newEntry' paper and put it in the 'historyFoods' binder
        int newID = await isar.savedFoods.put(newEntry);
        setState(() {food.id = newID;});
      });
    }
  }

  void _addFoodToHistory(FoodItem food)
  {
    print(food);
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
          icon: Icons.camera,
          label: "Scan",
          colorUsed: widget.logFoodIndex == 2 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(2)),
      buildNavItem(
          icon: Icons.app_registration_rounded,
          label: "Manual",
          colorUsed: widget.logFoodIndex == 3 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(3)),
      buildNavItem(
          icon: Icons.bookmark,
          label: "Saved",
          colorUsed: widget.logFoodIndex == 4 ? selectedColor : nonSelectedColor,
          onTap: () => widget.onLogFoodSelection(4)),
    ];

    var logFoodPagesContent = [ // Specific content for each sub-page
      SearchFoodPage(addFoodFunc: _addingFoodFunc, saveFoodFunc: _addFoodToSaved),
      Container(color: Colors.blueAccent, child: const Center(child: Text("Scan Barcode Content"))),
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
        ChooseFoodItem(food: _addingFood, close: _closeAddFood, goHome: widget.goHome, addFoodToSaved: _addFoodToSaved, addFoodToHistory: _addFoodToHistory)
      ]),
    );
  }
}

class FoodItem {
  static Random random = Random();
  String name;
  String serving_size;
  num grams; // Can be int or double
  num calories;
  num carbs;
  num fats;
  num protein;
  num sugar;
  String normalized_name; // Added normalized_name for consistency
  num code;
  dynamic id;
  Color color;
  String image_small_url;
  String img_url;
  num density;
  bool densityRequired;
  num time;
  num servings;
  bool isSaved;

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
    this.densityRequired = false,
    this.density = 1,
    this.code = -1,
    this.id = -1,
    Color? color,
    this.image_small_url = "",
    this.img_url = "",
    this.time = 0,
    this.servings = 1,
    this.isSaved = false,
  }) : color = color ?? HSLColor.fromAHSL(1.0, random.nextInt(360).toDouble(), .38, .50).toColor(); // Provide a default color if none is given
  
  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'name':
        name = value;
      case 'serving_size':
        serving_size = value;
      case 'grams':
        grams = value;
      case 'calories':
        calories = value;
      case 'carbs':
        carbs = value;
      case 'fats':
        fats = value;
      case 'protein':
        protein = value;
      case 'sugar':
        sugar = value;
      case 'normalized_name':
        normalized_name = value;
      case 'densityRequired':
        densityRequired = value;
      case 'density':
        density = value;
      case 'code':
        code = value;
      case 'id':
        id = value;
      case 'color':
        color = value;
      case 'image_small_url':
        image_small_url = value;
      case 'img_url':
        img_url = value;
      case 'time':
        time = value;
      case 'servings':
        servings = value;
      case 'isSaved':
        isSaved = value;
      default:
        throw ArgumentError('Unknown attribute: $key');
    }
  }
  
  dynamic operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      case 'serving_size':
        return serving_size;
      case 'grams':
        return grams;
      case 'calories':
        return calories;
      case 'carbs':
        return carbs;
      case 'fats':
        return fats;
      case 'protein':
        return protein;
      case 'sugar':
        return sugar;
      case 'normalized_name':
        return normalized_name;
      case 'densityRequired':
        return densityRequired;
      case 'density':
        return density;
      case 'code':
        return code;
      case 'id':
        return id;
      case 'color':
        return color;
      case 'image_small_url':
        return image_small_url;
      case 'img_url':
        return img_url;
      case 'time':
        return time;
      case 'servings':
        return servings;
      case 'isSaved':
        return isSaved;
      default:
        throw ArgumentError('Unknown attribute: $key');
    }
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
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
      densityRequired: json['densityRequired'] ?? false,
      density: json['density'] = 1,
      code: json['code'] ?? -1,
      color: json['color'] != null ? Color(json['color']) : HSLColor.fromAHSL(1.0, random.nextInt(360).toDouble(), .38, .50).toColor(),
      id: json['id'] ?? -1,
      image_small_url: json['image_small_url'] ?? json['image_url'] ?? "NO_IMAGE_FOUND",
      img_url: json['image_url'] ?? json['image_small_url'] ?? "NO_IMAGE_FOUND",
      time: json['time'] ?? 0,
      servings: json['servings'] ?? 1,
    );
  }

  @override
  String toString(){
    return "Food Name: $name\nServing Size: $serving_size\nGrams: $grams\nCalories: $calories\nCarbs: $carbs\nFats: $fats\nProtein: $protein\nSugar: $sugar\nCode: $code\nID: $id";
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'serving_size': serving_size,
      'grams': grams,
      'calories': calories,
      'carbs': carbs,
      'fats': fats,
      'protein': protein,
      'sugar': sugar,
      'normalized_name': normalized_name,
      'densityRequired': densityRequired,
      'density': density,
      'code': code,
      'id': id,
      'color': color.toARGB32(), 
      'image_small_url': image_small_url,
      'img_url': img_url,
      'time': time,
      'servings': servings,
    };
  }
}
