// ignore_for_file: non_constant_identifier_names, unused_import


import 'dart:math';


import 'package:everything_health_app/main.dart';
import 'package:everything_health_app/models/saved_foods.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'dart:async';
import '../log_food_page.dart';
import 'package:http/http.dart' as http;

Widget _buildFoodListItem(FoodItem food, onTap, onSave) {
  String subtitle = food.serving_size == "quantity not specified"
      ? ("${food.grams.toStringAsPrecision(4)} grams, ${food.calories.toStringAsPrecision(4)} kcal")
      : "${food.serving_size}, ${food.calories.toStringAsPrecision(4)} kcal";

  return Container(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey.shade700, width: 0.5)), // Darker border
      color: const Color.fromARGB(255, 1, 19, 37), // Darker background
    ),
    child: ListTile(
      title: Text(
        food.name,
        style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w500, // Slightly less bold
            overflow: TextOverflow.ellipsis),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 13,
            color: const Color.fromARGB(194, 255, 255, 255), // Lighter subtitle
            overflow: TextOverflow.ellipsis),
      ),
      trailing: IconButton( // Changed to IconButton for better tap feedback
        icon: Icon(food.isSaved ? Icons.bookmark : Icons.bookmark_outline, color: Colors.white),
        onPressed: onSave,
      ),
      onTap: onTap,
    ),
  );
}

class SearchFoodPage extends StatefulWidget {
  final Function(FoodItem) addFoodFunc;
  final Future<void> Function(FoodItem) saveFoodFunc;
  const SearchFoodPage({super.key, required this.addFoodFunc, required this.saveFoodFunc});

  @override
  State<SearchFoodPage> createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController(); // <-- ADD THIS
  
  // Stores all food data as raw maps for efficient searching
  List<Map<String, dynamic>> _allFoodDataMaps = []; 
  // Stores only the FoodItem objects that need to be displayed
  List<FoodItem> _displayedFoods = []; 

  bool _isLoading = true;
  String _loadError = '';
  
  Timer? _debounce;
  
  @override
  void initState() {
    super.initState();
    _loadAndPrepareInitialData();
    _searchController.addListener(_onSearchChangedWithDebounce);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChangedWithDebounce);
    _searchController.dispose();
    _listScrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAndPrepareInitialData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _loadError = '';
    });
    
    try {
      // 1. Load the raw JSON string
      _updateDisplayedFoods("");
      final String response = await rootBundle.loadString('assets/cleaned_normal_local_food_db.json');
      // 2. Parse into a list of maps
      final List<dynamic> decodedData = json.decode(response);
      _allFoodDataMaps = List<Map<String, dynamic>>.from(decodedData);
      
      // 3. Prepare initial display (first N items converted to FoodItem objects)
      _updateDisplayedFoods(""); // Empty query will show initial items

    } catch (e) {
      print("Error loading or parsing food data: $e");
      if (mounted) _loadError = "Failed to load food data. Ensure 'cleaned_normal_local_food_db.json' exists and is in pubspec.yaml. $e";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChangedWithDebounce() {
  if (_debounce?.isActive ?? false) {
    _debounce!.cancel();
  }
    final String currentQuery = _searchController.text;
    final String normalizedQuery = _normalizeText(currentQuery);
    Duration dbTime = Duration(milliseconds: 300); 
    if (normalizedQuery.isNotEmpty && normalizedQuery.length <= 2) {
      dbTime = Duration(milliseconds: 1000);
    }
    
    _debounce = Timer(dbTime, () {
      if (mounted) {
        _updateDisplayedFoods(normalizedQuery);
      }
    });
  }

  String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    // Remove common punctuation. This regex removes most symbols except letters, numbers, and whitespace.
    // You can customize it to be more or less aggressive.
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), ''); 
    // Replace multiple whitespace characters with a single space and trim.
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }

  Future<void> _updateDisplayedFoods(String query) async {
    if (!mounted) return;
    final List<String> searchTerms = query.split(' ').where((term) => term.isNotEmpty).toList();
  
    List<FoodItem> newDisplayedFoods = [];
    
      if (query.isEmpty) {
        // Show initial set from the raw maps, convert only these to FoodItem
        newDisplayedFoods = [];
        /** = _allFoodDataMaps
            .take(_initialDisplayCount)
            .map((jsonMap) => FoodItem.fromJson(jsonMap))
            .toList();**/

        // This sorting logic goes inside _updateDisplayedFoods method,
        // after `matchedFoods` list is populated.
        
      } else {
        // Filter raw maps, then convert only matches to FoodItem objects
        List<Map<String, dynamic>> matchedJsonMaps = _allFoodDataMaps
            .where((foodMap) {
              final String name = foodMap['normalized_name'] as String? ?? '';
              return searchTerms.every((term) => name.contains(term));
            }).toList();
        for (var jsonMap in matchedJsonMaps) {
          try {
            final String normalizedName = jsonMap['normalized_name'] ?? '';
            final String serving_size = jsonMap['serving_size'] ?? '';
            final double grams = jsonMap['grams'] ?? 0;
            final double calories = jsonMap['calories'] ?? 0;
            final double carbs = jsonMap['carbs'] ?? 0;
            final double fats = jsonMap['fats'] ?? 0;
            final double protein = jsonMap['protein'] ?? 0;
            final double sugar = jsonMap['sugar'] ?? 0;
            final double servings = jsonMap['servings'] ?? 1.0;
            
            // 3. Perform the Isar search for each item, just like in _apiFoodSearch
            final existingFood = await isar.savedFoods
                .filter()
                .normalized_nameEqualTo(normalizedName)
                .serving_sizeEqualTo(serving_size)
                .gramsEqualTo(grams)
                .caloriesEqualTo(calories)
                .carbsEqualTo(carbs)
                .fatsEqualTo(fats)
                .proteinEqualTo(protein)
                .sugarEqualTo(sugar)
                .servingsEqualTo(servings)
                .findFirst();

            if (existingFood != null) {
              // If a saved version exists, convert it to a FoodItem and add it to our list
              newDisplayedFoods.add(FoodItem.fromJson(existingFood.toJson()));
            } else {
              // Otherwise, use the data from the local JSON file
              newDisplayedFoods.add(FoodItem.fromJson(jsonMap));
            }
          } catch (e) {
            print("Error processing local search item: $e");
          }
        }
        
        newDisplayedFoods.sort((a, b) {
          String nameA = a.normalized_name;
          String nameB = b.normalized_name;

          for (int i = 0; i < searchTerms.length; i++) {
            int indexA = nameA.indexOf(searchTerms[i]);
            int indexB = nameB.indexOf(searchTerms[i]);

            // 1. Primary Sort: Earlier index of the query in the name
            if (indexA != indexB) {
              // If one doesn't contain it (shouldn't happen due to prior filter, but good for safety)
              if (indexA == -1) return 1;
              if (indexB == -1) return -1;
              return indexA.compareTo(indexB); // Lower index means query is earlier, so it comes first
            }
          }

          // 2. Secondary Sort: Shorter name length
          if (a.name.length != b.name.length) {
            return a.name.length.compareTo(b.name.length); // Shorter name comes first
          }

          // 3. Optional Tertiary Sort (e.g., alphabetical as a tie-breaker)
          return nameA.compareTo(nameB);
        });
      }
      setState(() {
        _displayedFoods = newDisplayedFoods;
      });
    if (_listScrollController.hasClients && _displayedFoods.isNotEmpty) {
      // Using WidgetsBinding.instance.addPostFrameCallback ensures that the scroll
      // happens after the ListView has had a chance to rebuild with the new items.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_listScrollController.hasClients) { // Check again as context might have changed
          _listScrollController.animateTo(
            0.0, // Scroll to the top (offset 0)
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeOut, // Animation curve
          );
          // Or, for an immediate jump without animation:
          // _listScrollController.jumpTo(0.0);
        }
      });
    } else if (_listScrollController.hasClients && _displayedFoods.isEmpty) {
      // If the list becomes empty, ensure it's scrolled to the top (e.g. if search yields no results)
      _listScrollController.jumpTo(0.0);
    }
  }
  
  List _toGrams(String str) {
    //WILL BREAK IF YOU ADD UNIT THAT ENDS IN 'x' FOR MULTI-WORD UNITS
    String units = str.replaceAll(RegExp(r'[\d.,/]+'), ' ').replaceAll(RegExp(r'[\s]+'), ' ').trim().toLowerCase();
    List<String> mathStuff = str.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.,/\sx*]'), ' ').replaceAll(r'/',r' / ').replaceAll(RegExp(r'[x*]+'), ' x ').replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase().split(" ");
    String doublePart = str.replaceAll(RegExp(r'[^\d.,\s]+'), ' ').trim();
    doublePart = doublePart.split(" ")[0];
    doublePart = doublePart.replaceAll(',', '.');
    String unitsCalc = units.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z*]'), '').contains(RegExp(r'[x*]')) ? units.split(" ").length > 1 ? units.split(" ")[1].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), ''): 'x' : units.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '');
    if (doublePart.isEmpty || str.substring(0,1).replaceAll(RegExp(r'[\d.]'), 'NUMBER') != 'NUMBER'){
      return [-9999999999, "NO_UNITS"];
    }
    double amt = double.parse(doublePart);
    try {
      if (double.parse(mathStuff[0]) > 0 && double.parse(mathStuff[2]) > 0 && (mathStuff[1] == 'x' || mathStuff[1] == '*')){
        amt = double.parse(mathStuff[0]) *  double.parse(mathStuff[2]);
      }
    // ignore: empty_catches
    }catch(e){}
    try {
      if (double.parse(mathStuff[0]) > 0 && double.parse(mathStuff[2]) > 0 && (mathStuff[1] == '/')){
        amt = double.parse(mathStuff[0]) / double.parse(mathStuff[2]);
      }
    // ignore: empty_catches
    }catch(e){}
    if (unitsCalc == 'g' || unitsCalc == 'grams' || unitsCalc == 
    'gm' ||  unitsCalc == 'г' || unitsCalc == 'gram' || unitsCalc == 'gms')
    {
      return [amt, unitsCalc, false];
    }
    else if (unitsCalc == 'ml' || unitsCalc == 'milliliter' || unitsCalc == 'milliliters'){
      return [amt, unitsCalc, true];
    }
    else if (unitsCalc == 'kg' || unitsCalc == 'killogram' || unitsCalc == 'killograms')
    {
      return [amt * 1000, unitsCalc, false];
    }
    else if (unitsCalc == 'l' || unitsCalc == 'liters' || unitsCalc == 'liter')
    {
      return [amt * 1000, unitsCalc, true];
    }
    else if (unitsCalc == 'fl' || unitsCalc == 'floz'  || unitsCalc == 'fluid')
    {
      return [amt * 30, unitsCalc, true];
    }
    else if (unitsCalc == 'oz' || unitsCalc == 'ounce' || unitsCalc == 'ounces')
    {
      return [amt * 28.3495, unitsCalc, false];
    }
    else if (unitsCalc == 'cup' || unitsCalc == 'cups' || unitsCalc == 'c')
    {
      return [amt * 236.588, unitsCalc, true]; // Assuming 1 cup = 236.588 ml
    }
    else if (unitsCalc == 'tbsp' || unitsCalc == 'tablespoon' || unitsCalc == 'tbsps' || unitsCalc == 'tablespoons')
    {
      return [amt * 14.787, unitsCalc, true]; // Assuming 1 tbsp = 14.787 ml
    }
    else if (unitsCalc == 'tsp' || unitsCalc == 'teaspoon' || unitsCalc == 'tsps' || unitsCalc == 'teaspoons')
    {
      return [amt * 4.92892, unitsCalc, true]; // Assuming 1 tsp = 4.92892 ml
    }
    else if (unitsCalc == 'pounds' || unitsCalc == 'pound' || unitsCalc == 'lbs' || unitsCalc == 'lb')
    {
      return [amt * 453.592, unitsCalc, false]; // Assuming 1 pound = 453.592 grams
    }
    else if (unitsCalc == 'pt' || unitsCalc == 'pint' || unitsCalc == 'pints' || unitsCalc == 'pts')
    {
      return [amt * 473.176, unitsCalc, true]; // Assuming 1 pint = 473.176 ml
    }
    else if (unitsCalc == 'quart' || unitsCalc == 'qt' || unitsCalc == 'quarts'  || unitsCalc == 'qts')
    {
      return [amt * 946.353, unitsCalc, true]; // Assuming 1 quart = 946.353 ml
    }
    else if (unitsCalc == 'mg' || unitsCalc == 'milligrams' || unitsCalc == 'milligram' || unitsCalc == 'mgs')
    {
      return [amt / 1000, unitsCalc, false]; // Convert mg to grams
    }
    else if (unitsCalc == 'cl')
    {
      return [amt * 10, unitsCalc, true];
    }
    else if (unitsCalc == 'gal' || unitsCalc == 'gals' || unitsCalc == 'gallon' || unitsCalc == 'gallons')
    {
      return [amt * 3785.42, unitsCalc, true];
    }
    else
    {
      //print("$units|$doublePart|$unitsCalc");
      return [-9999999999, "NO_UNITS", true];
    }
  }

  Future<void> _apiFoodSearch(String text) async {
    setState((){_isLoading = true;});
    final uri = Uri.parse('https://search.openfoodfacts.org/search?q=$text&page_size=500&fields=nutriments,quantity,product_name,product_name_en,image_small_url,image_url,code');
    final response = await http.get(uri);
    String responseBody = '';
    if (response.statusCode == 200) {
      responseBody = response.body;
    } else{
      setState(() {
        _loadError = "Failed to load food data from API. Status code: ${response.statusCode}";
        _isLoading = false;
      });
      return;
    }
      final Map<String, dynamic> decodedData = json.decode(responseBody);
      final List<dynamic> products = decodedData['hits'] ?? [];
      List<FoodItem> searchedFoods = [];
      
      for (var product in products) {
        try {
        //print("${product['product_name']} / ${product['product_name_en']} / ${product['quantity']}");
        double grams;
        bool densityRequired = true;
        if (product['quantity'] == null){
          grams = 100;
        }
        else{
          List gramsOutput = _toGrams(product['quantity']);
          grams = gramsOutput[0];
          densityRequired = gramsOutput[2];
        }
        double g100Mult = grams/100;

        String serving_size = product['quantity'] ?? '100g Assumed Serving Size';
        if (g100Mult <= 0 && product['quantity'] != null)
        {
          serving_size = '100g Assumed—unable to parse: ${product["quantity"]}';
          g100Mult = 1;
          grams = 100;
        }
        String name = product['product_name'] ?? product['product_name_en'] ?? '_NO_NAME_';
        num calories = -1;
        if (product['nutriments']?['energy-kcal_100g'] != null)
        {
          calories = product['nutriments']?['energy-kcal_100g'] * g100Mult;
        }else if(product['nutriments']?['energy-kj_100g'] != null)
        {
          calories = product['nutriments']?['energy-kj_100g'] * g100Mult / 4.184;
        }
        num carbs = -1;
        if (product['nutriments']?['carbohydrates_100g'] != null)
        {
          carbs = product['nutriments']?['carbohydrates_100g'] * g100Mult;
        }
        num fats = -1;
        if (product['nutriments']?['fat_100g'] != null)
        {
          fats = product['nutriments']?['fat_100g'] * g100Mult;
        }
        num proteins = -1;
        if (product['nutriments']?['proteins_100g'] != null)
        {
          proteins = product['nutriments']?['proteins_100g'] * g100Mult;
        }
        num sugars = -1;
        if (product['nutriments']?['sugars_100g'] != null)
        {
          sugars = product['nutriments']?['sugars_100g'] * g100Mult;
        }
        String image_small_url = "";
        if (product['image_small_url'] != null)
        {
          image_small_url = product['image_small_url'];
        }
        String img_url = image_small_url;
        if (product['image_url'] != null)
        {
          img_url = product['image_url'];
        }
        if (image_small_url == ""){
          image_small_url = img_url;
        }
        num code = -1;
        if (product['code'] != null)
        {
          code = num.parse(product['code']);
        }
        num servings = 1;
        if (product['servings'] != null)
        {
          servings = num.parse(product['servings']);
        }
        final existingFood = await isar.savedFoods
                .filter()
                .normalized_nameEqualTo(_normalizeText(name))
                .serving_sizeEqualTo(serving_size)
                .gramsEqualTo(grams)
                .caloriesEqualTo(calories.toDouble())
                .carbsEqualTo(carbs.toDouble())
                .fatsEqualTo(fats.toDouble())
                .proteinEqualTo(proteins.toDouble())
                .sugarEqualTo(sugars.toDouble())
                .servingsEqualTo(servings.toDouble())
                .findFirst();
        if (existingFood != null){
          searchedFoods.add(FoodItem.fromJson(existingFood.toJson()));
        }
        else{
          FoodItem currFoodItem = FoodItem(
                  name: name,
                  serving_size: serving_size,
                  grams: grams,
                  calories: calories,
                  carbs:  carbs,
                  fats: fats,
                  protein: proteins,
                  sugar: sugars,
                  normalized_name: _normalizeText(name),
                  image_small_url: image_small_url,
                  img_url: img_url,
                  code: code,
                  //Assumed 1ml to 1g
                  density: 1.0,
                  densityRequired: densityRequired,
                  );
          searchedFoods.add(currFoodItem);
        }
        } catch(e) {
          print("Error parsing api response: $e");
        }
      }
      
      List<FoodItem> searchedFoodsAllElements = [];
      List<FoodItem> firstHalfFoods = [];
      List<FoodItem> secondHalfFoods = [];
      for (int i = 0; i < searchedFoods.length; i++)
      {
        if (searchedFoods[i].grams != -1 && searchedFoods[i].calories != -1 && searchedFoods[i].carbs != -1 && searchedFoods[i].fats != -1 && searchedFoods[i].protein != -1 && searchedFoods[i].sugar != -1)
        {
          if (searchedFoods[i].serving_size != "100g Assumed Serving Size")
          {
            firstHalfFoods.add((searchedFoods[i]));
          }else {
            secondHalfFoods.add((searchedFoods[i]));
          }
        }
      }
      searchedFoodsAllElements = firstHalfFoods + secondHalfFoods;
      setState(() {
        _displayedFoods = searchedFoodsAllElements;
        _isLoading = false;
      });
  }
  void _onApiSearch()
  {
    _apiFoodSearch(_searchController.text);
  }

 
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 60),
        color: const Color.fromARGB(255, 0, 36, 72),
        child: 
          Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search foods...",
                      hintStyle: TextStyle(color: Colors.white.withAlpha(180)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withAlpha(25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                                // _onSearchChanged will be called by the listener
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                _searchController.text.isNotEmpty ? GestureDetector(child: Container(
                    height: 80,
                    width: double.infinity,
                    color: Colors. white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Search Entire Database"),
                    )
                  ),
                  onTap: () {
                    _onApiSearch();
                  }
                ) : Container(height: 0),
                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_loadError.isNotEmpty)
                  Expanded(child: Center(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_loadError, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center,),
                  )))
                else if (_displayedFoods.isEmpty && _searchController.text.isNotEmpty)
                  const Expanded(child: Center(child: Text("No foods found.", style: TextStyle(color: Colors.white, fontSize: 16))))
                else if (_displayedFoods.isEmpty && _searchController.text.isEmpty)
                  const Expanded(child: Center(child: Text("Start typing to search for foods.", style: TextStyle(color: Colors.white70, fontSize: 16))))
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _listScrollController,
                      itemCount: _displayedFoods.length,
                      itemBuilder: (BuildContext context, int index) {
                        final food = _displayedFoods[index]; // food is already a FoodItem
                        return _buildFoodListItem(
                          food,
                          widget.addFoodFunc(food),
                          () {widget.saveFoodFunc(food); setState((){});},
                        ); 
                      },
                    ),
                  ),
              ],
            )
      );
  }
}
