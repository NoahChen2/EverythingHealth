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
  final Future<void> Function(FoodItem) addFoodToHistory;
  const LibraryFoodPage(
      {super.key,
      required this.addFoodFunc,
      required this.saveFoodFunc,
      required this.addFoodToHistory});

  @override
  State<LibraryFoodPage> createState() => _LibraryFoodPageState();
}

class _LibraryFoodPageState extends State<LibraryFoodPage> {
  int selectionOptionsButton = 0; //0:Saved, 1:History, 2:Both
  int sortOptionsButton = -1; // -1:Off
  int filterOptionsButton = -1; // -1:Off
  List<FoodItem> foodList = [];
  bool _isOptionSelecting = false;

  // ignore: constant_identifier_names
  static const SORT_OPTIONS = {
    0: "Newest",
    1: "Oldest",
    2: "Calories Asc",
    3: "Calories Desc",
    4: "Protein Desc",
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

  void _handleOptionButton(String buttonChoice, int value) {
    setState(() {
      switch (buttonChoice) {
        case "selection":
          if (value == selectionOptionsButton) {
            break;
          } else {
            selectionOptionsButton = value;
          }
        case "sort":
          if (SORT_OPTIONS.keys.contains(value)) {
            sortOptionsButton = value;
          } else {
            sortOptionsButton = -1;
          }
        case "filter":
          if (FILTER_OPTIONS.keys.contains(value)) {
            filterOptionsButton = value;
          } else {
            filterOptionsButton = -1;
          }
      }
      updateFoodList();
    });
  }

  void _toggleOptionSelecting()
  {
    setState(() => _isOptionSelecting = !_isOptionSelecting);
  }

  Future<void> updateFoodList() async {
    // 1. Fetch saved foods ONCE, upfront. This list acts as our "source of truth"
    // for what is saved, and we'll use it for efficient in-memory lookups.
    final allSavedFoods = await isar.savedFoods.where().findAll();
    final List<FoodItem> savedFoodItems =
        allSavedFoods.map((food) => FoodItem.fromJson(food.toJson())).toList();

    // 2. Build the initial list based on the user's selection.
    List<FoodItem> initialList = [];
    if (selectionOptionsButton == 0 || selectionOptionsButton == 2) {
      initialList.addAll(savedFoodItems);
    }
    if (selectionOptionsButton == 1 || selectionOptionsButton == 2) {
      final historyFoods = await isar.historyFoods.where().findAll();
      initialList
          .addAll(historyFoods.map((food) => FoodItem.fromJson(food.toJson())));
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
          existingFood.id = food.id;
        }
      } else {
        if (!food.isSaved) {
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
                saved.servings == food.servings);

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
      case 4: // Protein Desc
        tempFoodList.sort((a, b) => b.protein.compareTo(a.protein));
    }

    // Step 3: Apply filtering
    if (filterOptionsButton != -1) {
      switch (filterOptionsButton) {
        case 0: // Low Calorie
          tempFoodList = tempFoodList
              .where((food) =>
                  food.calories < 150 &&
                  food.grams != 0 &&
                  food.calories / food.grams <= 2 &&
                  food.calories / food.grams >= 0)
              .toList();
        case 1: // High Calorie
          tempFoodList = tempFoodList
              .where((food) =>
                  food.calories > 250 &&
                  food.grams != 0 &&
                  food.calories / food.grams >= 3 &&
                  food.calories / food.grams >= 0)
              .toList();
        case 2: // High Protein
          tempFoodList = tempFoodList
              .where((food) =>
                  food.protein > 5 &&
                  food.grams != 0 &&
                  food.protein / food.calories >= 0.075 &&
                  food.protein / food.calories >= 0)
              .toList();
        case 3: // Low Sugar
          tempFoodList = tempFoodList
              .where((food) =>
                  food.sugar < 5 &&
                  food.grams != 0 &&
                  food.sugar / food.grams <= .05 &&
                  food.sugar / food.grams >= 0)
              .toList();
      }
    }

    // Step 4: Update the state
    setState(() {
      foodList = tempFoodList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(top: 60),
            color: Color.fromARGB(255, 0, 36, 72),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 80,
                        ), // Add some padding around the grid
                        itemCount: foodList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // This creates 2 columns
                          crossAxisSpacing: 20, // Horizontal space between cards
                          mainAxisSpacing: 20, // Vertical space between cards
                          childAspectRatio: 100 /
                              100, // Aspect ratio of each card (width / height)
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return foodItemCard(
                              foodList[index],
                              widget.saveFoodFunc,
                              widget.addFoodFunc,
                              widget.addFoodToHistory,
                              updateFoodList);
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
                        border: Border(
                            bottom: BorderSide(
                                color: const Color.fromARGB(75, 255, 255, 255),
                                width: 10)),
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
                                    onTap: () =>
                                        _handleOptionButton("selection", 0),
                                    child: Container(
                                        height: 30,
                                        width: 60,
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5)),
                                          color: selectionOptionsButton == 0
                                              ? const Color.fromARGB(
                                                  75, 255, 255, 255)
                                              : const Color.fromARGB(75, 0, 0, 0),
                                        ),
                                        child: AutoSizeText("Saved",
                                            minFontSize: 6,
                                            maxFontSize: 10,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                            textAlign: TextAlign.center)),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _handleOptionButton("selection", 1),
                                    child: Container(
                                        height: 30,
                                        width: 60,
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(),
                                          color: selectionOptionsButton == 1
                                              ? const Color.fromARGB(
                                                  75, 255, 255, 255)
                                              : const Color.fromARGB(75, 0, 0, 0),
                                        ),
                                        child: AutoSizeText("History",
                                            minFontSize: 6,
                                            maxFontSize: 10,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                            textAlign: TextAlign.center)),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _handleOptionButton("selection", 2),
                                    child: Container(
                                        height: 30,
                                        width: 60,
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5)),
                                          color: selectionOptionsButton == 2
                                              ? const Color.fromARGB(
                                                  75, 255, 255, 255)
                                              : const Color.fromARGB(75, 0, 0, 0),
                                        ),
                                        child: AutoSizeText("Both",
                                            minFontSize: 6,
                                            maxFontSize: 10,
                                            maxLines: 2,
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () => _toggleOptionSelecting(),
                                    child: Container(
                                      height: 30,
                                      width: 40,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 5,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                        color: sortOptionsButton == -1 && filterOptionsButton == -1
                                            ? const Color.fromARGB(75, 0, 0, 0)
                                            : const Color.fromARGB(
                                                75, 255, 255, 255),
                                      ),
                                      child: Icon(Icons.sort, color: Colors.white, size: 20)
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
            )),
        _isOptionSelecting ? 
          OptionsSelectMenu(
                handleOptionButton: _handleOptionButton,
                sortOptionsButton: sortOptionsButton,
                filterOptionsButton: filterOptionsButton,
                toggleOptionSelecting: _toggleOptionSelecting,
              )
          : SizedBox.shrink(),
      ],
    );
  }
}

Widget foodItemCard(FoodItem food, Function saveFoodFunc, Function addFoodFunc,
    Function addFoodToHistory, Function updateFoodList) {
  // The root container defines the border and rounded corners for the whole card.
  return Container(
    width: 100,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 65, 224, 192)),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color:
          const Color.fromARGB(255, 0, 23, 47), // A fallback background color
    ),
    // ClipRRect ensures all children (like the image area) respect the rounded corners.
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: GestureDetector(
        onTap: addFoodFunc(food),
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
                      flex: 6,
                      child: UniversalImage(path: food.image_small_url, fit: BoxFit.contain)
                    ),
                    Expanded(
                      flex: 4,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12, // The starting font size
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 2.0)
                                  ],
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 2.0)
                                  ],
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
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                ),
              ),
            ),
            Divider(color: const Color.fromARGB(38, 255, 255, 255), height: 1),
            Container(height: 5, color: const Color.fromARGB(141, 0, 0, 0),),
            Expanded(
              flex: 4,
              child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(141, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () => addFoodToHistory(food),
                            child: Icon(Icons.add, color: Colors.white, size: 20)),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              await saveFoodFunc(food);
                              updateFoodList();
                            },
                            child: Icon(
                                food.isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: Colors.white, size: 20)),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}


class OptionsSelectMenu extends StatefulWidget {
  final Function(String, int) handleOptionButton;
  final num sortOptionsButton;
  final num filterOptionsButton;
  final VoidCallback toggleOptionSelecting;

  const OptionsSelectMenu({
    super.key,
    required this.handleOptionButton,
    required this.sortOptionsButton,
    required this.filterOptionsButton,
    required this.toggleOptionSelecting,
  });

  @override
  State<OptionsSelectMenu> createState() => _OptionsSelectMenuState();
}

class _OptionsSelectMenuState extends State<OptionsSelectMenu>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ScrollController _scrollController;

  final double _minHeightFactor = 0.1;
  final double _dismissThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 0.0,
    );
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController
        .animateTo(0.0, curve: Curves.easeOut)
        .whenComplete(() {
      if (mounted) {
        widget.toggleOptionSelecting();
      }
    });
  }

  /// This function ONLY handles dragging the entire sheet.
  void _handleSheetDrag(double delta) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dragDistance = screenHeight * (1 - _minHeightFactor);
    _animationController.value -= delta / dragDistance;
  }

  /// This is our NEW smart handler that decides what to do with a drag.
  void _handleDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
      _dismiss();
      return;
    }
    if (_animationController.value < _dismissThreshold) {
      _dismiss();
    } else {
      _animationController.animateTo(1.0, curve: Curves.easeOut);
    }
  }

  // ===== THIS IS THE UPDATED METHOD =====
  /// This smart handler now prioritizes dragging the sheet up if it's partially open.
  void _handleDragUpdate(DragUpdateDetails details) {
    final dragDelta = details.delta.dy;

    // If dragging UP
    if (dragDelta < 0) {
      // If the sheet is not fully open, prioritize dragging it up.
      // We use !_animationController.isCompleted which is true if the sheet
      // is anywhere between fully open and fully closed.
      if (!_animationController.isCompleted) {
        _handleSheetDrag(dragDelta);
      } else {
        // If the sheet is already fully open, scroll the list.
        _scrollController.jumpTo(_scrollController.position.pixels - dragDelta);
      }
    }
    // If dragging DOWN
    else if (dragDelta > 0) {
      // If the list is scrolled to the top, drag the sheet.
      if (_scrollController.position.pixels <= 0) {
        _handleSheetDrag(dragDelta);
      } else {
        // Otherwise, scroll the list.
        _scrollController.jumpTo(_scrollController.position.pixels - dragDelta);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final int backgroundAlpha = (145 * _animationController.value).toInt();
        final topPosition = lerpDouble(
          screenHeight,
          screenHeight * _minHeightFactor,
          _animationController.value,
        )!;

        return Stack(
          children: [
            GestureDetector(
              onTap: _dismiss,
              child: Container(
                color: Color.fromARGB(backgroundAlpha, 0, 0, 0),
              ),
            ),
            Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              child: child!,
            ),
          ],
        );
      },
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 36, 72),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Display Foods", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18)),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        decoration: BoxDecoration(color: const Color.fromARGB(117, 0, 0, 0), borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    // Your list content remains exactly the same
                    const Padding(padding: EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 5), child: Text("Sort", style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(151, 255, 255, 255), fontSize: 16))),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", -1), optionButton: widget.sortOptionsButton, targetNum: -1, text: "None"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", 0), optionButton: widget.sortOptionsButton, targetNum: 0, text: "Newest"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", 1), optionButton: widget.sortOptionsButton, targetNum: 1, text: "Oldest"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", 2), optionButton: widget.sortOptionsButton, targetNum: 2, text: "Calories Asc"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", 3), optionButton: widget.sortOptionsButton, targetNum: 3, text: "Calories Desc"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("sort", 4), optionButton: widget.sortOptionsButton, targetNum: 4, text: "Protein Desc"),
                    const Divider(color: Colors.white24, height: 1),
                    Container(padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 5), child: const Text("Filter", style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(151, 255, 255, 255), fontSize: 16))),
                    tappableOptionEntry(func: () => widget.handleOptionButton("filter", -1), optionButton: widget.filterOptionsButton, targetNum: -1, text: "None"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("filter", 0), optionButton: widget.filterOptionsButton, targetNum: 0, text: "Low Calorie"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("filter", 1), optionButton: widget.filterOptionsButton, targetNum: 1, text: "High Calorie"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("filter", 2), optionButton: widget.filterOptionsButton, targetNum: 2, text: "High Protein"),
                    tappableOptionEntry(func: () => widget.handleOptionButton("filter", 3), optionButton: widget.filterOptionsButton, targetNum: 3, text: "Low Sugar"),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tappableOptionEntry({required Function func, required num optionButton, required num targetNum, required String text}) {
    // This widget is unchanged
    return GestureDetector(
      onTap: () {
        func();
        _dismiss();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: optionButton == targetNum ? text == "None" ?  const Color.fromARGB(35, 255, 255, 255) : const Color.fromARGB(77, 255, 255, 255) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12))),
            Icon(Icons.check, color: optionButton == targetNum ? Colors.white : Colors.transparent, size: 20),
          ],
        ),
      ),
    );
  }
}