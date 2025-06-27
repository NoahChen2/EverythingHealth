import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:everything_health_app/main.dart';
import 'package:everything_health_app/models/history_foods.dart';
import 'package:everything_health_app/models/saved_foods.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../log_food_page.dart';

class LibraryFoodPage extends StatefulWidget {
  final Function(FoodItem) addFoodFunc;
  final Future<void> Function(FoodItem) saveFoodFunc;
  const LibraryFoodPage({super.key, required this.addFoodFunc, required this.saveFoodFunc});

  @override
  State<LibraryFoodPage> createState() => _LibraryFoodPageState();
}

class _LibraryFoodPageState extends State<LibraryFoodPage> {
  int selectionOptionsButton = 0; //0:Saved, 1:History, 2:Both
  int sortOptionsButton = -1; // -1:Off
  int filterOptionsButton = -1; // -1:Off
  List<FoodItem> foodList = [];

  // ignore: constant_identifier_names
  static const SORT_OPTIONS = {
    0: "Newest",
    1: "Oldest",
    2: "Calories Asc",
    3: "Calories Desc",
    4: "Protein Asc",
    5: "Protein Desc",
  };

  // ignore: constant_identifier_names
  static const FILTER_OPTIONS = {
    0: "Low Calorie",
    1: "High Calorie",
    2: "High Protein",
    3: "Low Sugar",
  };

  @override
  void initState() {
    super.initState();
    selectionOptionsButton = 0;
    sortOptionsButton = -1;
    filterOptionsButton = -1;
    updateFoodList();
  }

  void _handleOptionButton(String buttonChoice, int value)
  {
    setState(() {
      switch (buttonChoice){
        case "selection":
          if (value == selectionOptionsButton)
          {
            break;
          }else{
            selectionOptionsButton = value;
          }
        case "sort":
          if (SORT_OPTIONS.keys.contains(value))
          {
            sortOptionsButton = value;
          }
          else {
            sortOptionsButton = -1;
          }
        case "filter":
          if (FILTER_OPTIONS.keys.contains(value))
          {
            filterOptionsButton = value;
          }
          else {
            filterOptionsButton = -1;
          }
      }
      updateFoodList();
    });
  }

  Future<void> updateFoodList() async {
    // 1. Fetch saved foods ONCE, upfront. This list acts as our "source of truth"
    // for what is saved, and we'll use it for efficient in-memory lookups.
    final allSavedFoods = await isar.savedFoods.where().findAll();
    final List<FoodItem> savedFoodItems = allSavedFoods.map((food) => FoodItem.fromJson(food.toJson())).toList();

    // 2. Build the initial list based on the user's selection.
    List<FoodItem> initialList = [];
    if (selectionOptionsButton == 0 || selectionOptionsButton == 2) {
      initialList.addAll(savedFoodItems);
    }
    if (selectionOptionsButton == 1 || selectionOptionsButton == 2) {
      final historyFoods = await isar.historyFoods.where().findAll();
      initialList.addAll(historyFoods.map((food) => FoodItem.fromJson(food.toJson())));
    }

    // 3. Use a Map for high-efficiency deduplication and merging.
    final Map<String, FoodItem> uniqueFoodsMap = {};

    for (final food in initialList) {
      // Create a unique key based on the food's core properties.
      final key =
          '${food.name}|${food.serving_size}|${food.grams}|${food.calories}|${food.carbs}|${food.fats}|${food.protein}|${food.sugar}|${food.servings}';

      if (uniqueFoodsMap.containsKey(key)) {
        // DUPLICATE FOUND: Merge the data into the existing entry.
        final existingFood = uniqueFoodsMap[key]!;
        existingFood.time = max(existingFood.time, food.time);
        if (food.isSaved) {
          existingFood.isSaved = true;
        }
      } else {
        if (!food.isSaved)
        {
          try {
            // Use the efficient, in-memory list we fetched at the start.
            final matchingSavedFood = savedFoodItems.firstWhere((saved) =>
                saved.name == food.name &&
                saved.serving_size == food.serving_size &&
                saved.grams == food.grams &&
                saved.calories == food.calories &&
                saved.carbs == food.carbs &&
                saved.fats == food.fats &&
                saved.protein == food.protein &&
                saved.sugar == food.sugar &&
                saved.servings == food.servings
            );

            // If a match is found, update the isSaved status.
            food.isSaved = true;
            food.id = matchingSavedFood.id;
          } catch (e) {
            // No match found in savedFoods, which is fine. Do nothing.
          }
        }
        uniqueFoodsMap[key] = food;
      }
    }

    // 4. The final list is simply the values from our map.
    List<FoodItem> tempFoodList = uniqueFoodsMap.values.toList();

    switch (sortOptionsButton) {
        case -1:
          tempFoodList.sort((a, b) => (b.time).compareTo(a.time));
        case 0: // Newest
          tempFoodList.sort((a, b) => (b.time).compareTo(a.time));
        case 1: // Oldest
          tempFoodList.sort((a, b) => (a.time).compareTo(b.time));
        case 2: // Calories Asc
          tempFoodList.sort((a, b) => a.calories.compareTo(b.calories));
        case 3: // Calories Desc
          tempFoodList.sort((a, b) => b.calories.compareTo(a.calories));
        case 4: // Protein Asc
          tempFoodList.sort((a, b) => a.protein.compareTo(b.protein));
        case 5: // Protein Desc
          tempFoodList.sort((a, b) => b.protein.compareTo(a.protein));
    }

    // Step 3: Apply filtering
    if (filterOptionsButton != -1) {
      switch (filterOptionsButton) {
        case 0: // Low Calorie
          tempFoodList = tempFoodList.where((food) => food.calories < 150 && food.grams != 0 && food.calories/food.grams <= 2 && food.calories/food.grams >= 0).toList();
        case 1: // High Calorie
          tempFoodList = tempFoodList.where((food) => food.calories > 250 && food.grams != 0 && food.calories/food.grams >= 3 && food.calories/food.grams >= 0).toList();
        case 2: // High Protein
          tempFoodList = tempFoodList.where((food) => food.protein > 5 && food.grams != 0 && food.protein/food.calories >= 0.075 && food.protein/food.calories >= 0).toList();
        case 3: // Low Sugar
          tempFoodList = tempFoodList.where((food) => food.sugar < 5 && food.grams != 0 && food.sugar/food.grams <= .05 && food.sugar/food.grams >= 0).toList();
      }
    }

    // Step 4: Update the state
    setState(() {
      foodList = tempFoodList;
    });

  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top: 60),
      color: Color.fromARGB(255, 0, 36, 72),
      child: Stack(
        children: [
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(right: 10, left: 10,top: 80,), // Add some padding around the grid
                    itemCount: foodList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // This creates 2 columns
                      crossAxisSpacing: 20, // Horizontal space between cards
                      mainAxisSpacing: 20, // Vertical space between cards
                      childAspectRatio: 100 / 100, // Aspect ratio of each card (width / height)
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return foodItemCard(foodList[index]);
                  },
                              ),
                ),
              ],
            ),
            ClipPath(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: const Color.fromARGB(75, 255, 255, 255),width: 10)),
                    color: Color.fromARGB(94, 0, 36, 72),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () => _handleOptionButton("selection", 0),
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(5)),
                                        color: selectionOptionsButton == 0 ? const Color.fromARGB(75, 255, 255, 255) : const Color.fromARGB(75, 0, 0, 0),
                                      ),
                                      child: AutoSizeText("Saved", minFontSize: 6, maxFontSize: 10, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () => _handleOptionButton("selection", 1),
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(),
                                        color: selectionOptionsButton == 1 ? const Color.fromARGB(75, 255, 255, 255) : const Color.fromARGB(75, 0, 0, 0),
                                      ),
                                      child: AutoSizeText("History", minFontSize: 6, maxFontSize: 10, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () => _handleOptionButton("selection", 2),
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
                                        color: selectionOptionsButton == 2 ? const Color.fromARGB(75, 255, 255, 255) : const Color.fromARGB(75, 0, 0, 0),
                                      ),
                                      child: AutoSizeText("Both", minFontSize: 6, maxFontSize: 10, maxLines: 2, style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ],),
                      ),
                      
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: GestureDetector(
                                onTap: () => _handleOptionButton("sort", sortOptionsButton + 1),
                                child: Container(
                                  height: 45,
                                  width: 70,
                                  padding: EdgeInsets.only(left: sortOptionsButton != -1 ? 10 : 0, right: 0, top: 5, bottom: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(5), topRight: Radius.circular(5)),
                                    color: sortOptionsButton == -1 ? const Color.fromARGB(75, 0, 0, 0): const Color.fromARGB(75, 255, 255, 255),
                                  ),
                                  child: Stack(
                                    children: [
                                      SizedBox.expand(
                                        child: Column(
                                          crossAxisAlignment: sortOptionsButton != -1 ? CrossAxisAlignment.start: CrossAxisAlignment.center, 
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AutoSizeText(
                                                  "Sort", minFontSize: 8, maxFontSize: 10, maxLines: 1, style: TextStyle(color: Colors.white), overflow: TextOverflow.clip, textAlign: sortOptionsButton != -1 ? TextAlign.left : TextAlign.center
                                                ),
                                            SizedBox(height: 3),
                                            AutoSizeText(
                                              sortOptionsButton != -1 ? SORT_OPTIONS[sortOptionsButton]! : "", minFontSize: 4, maxFontSize: 8, maxLines: 2, style: TextStyle(color: const Color.fromARGB(255, 191, 191, 191), fontSize: 8)),
                                          ],
                                        ),
                                      ),
                                      sortOptionsButton != -1 ? 
                                      Positioned(
                                        top: 0,
                                        right: 3,
                                        child: GestureDetector(
                                          onTap: () => _handleOptionButton("sort", -1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color.fromARGB(255, 0, 23, 47)),
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              color: const Color.fromARGB(115, 255, 255, 255),
                                            ),
                                            child: Icon(Icons.clear, color: Color.fromARGB(255, 0, 23, 47), size: 15)),
                                        ),
                                      ) : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              fit: FlexFit.loose,
                              child: GestureDetector(
                                  onTap: () => _handleOptionButton("filter", filterOptionsButton + 1),
                                  child: Container(
                                    height: 45,
                                    width: 70,
                                    margin: EdgeInsets.only(right: 5),
                                    padding: EdgeInsets.only(left: filterOptionsButton != -1 ? 10: 0, top: 5,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft:Radius.circular(5), topRight: Radius.circular(5)),
                                      color: filterOptionsButton == -1 ? const Color.fromARGB(75, 0, 0, 0): const Color.fromARGB(75, 255, 255, 255),
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox.expand(
                                          child: Column(
                                            crossAxisAlignment: filterOptionsButton != -1 ? CrossAxisAlignment.start: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AutoSizeText(
                                                "Filter", minFontSize: 8, maxFontSize: 10, maxLines: 1, style: TextStyle(color: Colors.white), overflow: TextOverflow.clip, textAlign: filterOptionsButton != -1 ? TextAlign.left : TextAlign.center
                                              ),
                                              SizedBox(height: 3),
                                              AutoSizeText(filterOptionsButton != -1 ? FILTER_OPTIONS[filterOptionsButton]! : "", minFontSize: 4, maxFontSize: 8, maxLines: 2, style: TextStyle(color: const Color.fromARGB(255, 191, 191, 191)), textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        filterOptionsButton != -1 ? 
                                        Positioned(
                                          top: 0,
                                          right: 3,
                                          child: GestureDetector(
                                            onTap: () => _handleOptionButton("filter", -1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Color.fromARGB(255, 0, 23, 47)),
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                color: const Color.fromARGB(115, 255, 255, 255),
                                              ),
                                              child: Icon(Icons.clear, color: Color.fromARGB(255, 0, 23, 47), size: 15)),
                                          ),
                                        ) : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          //content
        ],
      )
    );
  }
}

Widget foodItemCard(FoodItem food) {
  // The root container defines the border and rounded corners for the whole card.
  return Container(
    width: 100,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 65, 224, 192)),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: const Color.fromARGB(255, 0, 23, 47), // A fallback background color
    ),
    // ClipRRect ensures all children (like the image area) respect the rounded corners.
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Column(
        // The main layout is a Column with two Expanded sections.
        // This gives each section a clearly defined, fixed height.
        children: [
          // The top section of the card (image, stats)
          Expanded(
            flex: 10, // Give this section 60% of the height
            child: Container(
              width: double.infinity,
              height: 40,
              color: food.color,
              child: Row(
                children: [
                  // Position the stats at the top right
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
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
                                maxFontSize: 20,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10, // The starting font size
                                  shadows: [Shadow(color: Colors.black, blurRadius: 2.0)],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                "${food.calories.toStringAsFixed(0)} kcal",
                                maxLines: 1,
                                minFontSize: 1,
                                maxFontSize: 20,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 2.0)],
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
            flex: 4, // Give this section 40% of the height
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(141, 0, 0, 0),
              // Center the text vertically and horizontally
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  // Using AutoSizeText for the name. It works here because its parent
                  // Expanded gives it a clear, fixed area to fill.
                  child: AutoSizeText(
                    food.name,
                    minFontSize: 1,
                    maxFontSize: 40,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(141, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => print("ADD"),
                      child: Icon(Icons.add, color: Colors.white)),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => print(food.isSaved),
                      child: Icon(food.isSaved ? Icons.bookmark : Icons.bookmark_outline, color: Colors.white)),
                  )
              ],)
            ),
          ),
        ],
      ),
    ),
  );
}