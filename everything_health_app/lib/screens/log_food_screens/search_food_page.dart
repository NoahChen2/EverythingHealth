// ignore_for_file: non_constant_identifier_names

// ignore: unused_import
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import '../log_food_page.dart';
import 'package:http/http.dart' as http;

Widget _buildFoodListItem(FoodItem food, onTap) {
  String subtitle = food.serving_size == "quantity not specified" ? ("${food.grams.toStringAsPrecision(4)} grams, ${food.calories.toStringAsPrecision(4)} kcal") : "${food.serving_size}, ${food.calories.toStringAsPrecision(4)} kcal";
  
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
        icon: const Icon(Icons.bookmark_add_outlined, color: Color.fromARGB(255, 0, 255, 64)),
        onPressed: () {
          print("Adding ${food.name}");
        },
      ),
      onTap: onTap
    ),
  );
}

class SearchFoodPage extends StatefulWidget {
  final Function addingFoodFunc;
  const SearchFoodPage({super.key, required this.addingFoodFunc});

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
      if (mounted) _loadError = "Failed to load food data. Ensure 'local_food_db.json' exists and is in pubspec.yaml.";
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

  void _updateDisplayedFoods(String query) {
    if (!mounted) return;
    final List<String> searchTerms = query.split(' ').where((term) => term.isNotEmpty).toList();
  
    List<FoodItem> newDisplayedFoods;
    setState(() {
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
        
        List<FoodItem> matchedFoods = _allFoodDataMaps
            .where((foodMap) {
              final String name = foodMap['normalized_name'] as String? ?? '';
              return searchTerms.every((term) => name.contains(term));
            })
            .map((jsonMap) => FoodItem.fromJson(jsonMap))
            .toList();
        matchedFoods.sort((a, b) {
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
        newDisplayedFoods = matchedFoods;
      }
      setState(() {
        _displayedFoods = newDisplayedFoods;
      });
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
  
  double _toGrams(String str) {
    //WILL BREAK IF YOU ADD UNIT THAT ENDS IN 'x' FOR MULTI-WORD UNITS
    String units = str.replaceAll(RegExp(r'[\d.,/]+'), ' ').replaceAll(RegExp(r'[\s]+'), ' ').trim().toLowerCase();
    List<String> mathStuff = str.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.,\sx*]'), ' ').replaceAll(RegExp(r'[x*]+'), ' x ').replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase().split(" ");
    String doublePart = str.replaceAll(RegExp(r'[^\d.,\s]+'), ' ').trim();
    doublePart = doublePart.split(" ")[0];
    doublePart = doublePart.replaceAll(',', '.');
    String unitsCalc = units.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z*]'), '').contains(RegExp(r'[x*]')) ? units.split(" ").length > 1 ? units.split(" ")[1].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), ''): 'x' : units.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '');
    if (doublePart.isEmpty || str.substring(0,1).replaceAll(RegExp(r'[\d.]'), 'NUMBER') != 'NUMBER'){
      return -9999999999;
    }
    double amt = double.parse(doublePart);
    try {
      if (double.parse(mathStuff[0]) > 0 && double.parse(mathStuff[2]) > 0 && (mathStuff[1] == 'x' || mathStuff[1] == '*')){
        amt = double.parse(mathStuff[0]) *  double.parse(mathStuff[2]);
      }
    // ignore: empty_catches
    }catch(e){
    }
    if (unitsCalc == 'g' || unitsCalc == 'ml' || unitsCalc == 'grams' || unitsCalc == 
    'gm' || unitsCalc == 'milliliter' || unitsCalc == 'milliliters' || unitsCalc == 'г' || unitsCalc == 'gram' || unitsCalc == 'gms')
    {
      return amt;
    }
    else if (unitsCalc == 'l' || unitsCalc == 'kg' || unitsCalc == 'liters' || unitsCalc == 'liter' || unitsCalc == 'killogram' || unitsCalc == 'killograms')
    {
      return amt * 1000;
    }
    else if (unitsCalc == 'fl' || unitsCalc == 'floz'  || unitsCalc == 'fluid')
    {
      return amt * 30;
    }
    else if (unitsCalc == 'oz' || unitsCalc == 'ounce' || unitsCalc == 'ounces')
    {
      return amt * 28.3495;
    }
    else if (unitsCalc == 'cup' || unitsCalc == 'cups')
    {
      return amt * 236.588; // Assuming 1 cup = 236.588 ml
    }
    else if (unitsCalc == 'tbsp' || unitsCalc == 'tablespoon' || unitsCalc == 'tbsps' || unitsCalc == 'tablespoons')
    {
      return amt * 14.787; // Assuming 1 tbsp = 14.787 ml
    }
    else if (unitsCalc == 'tsp' || unitsCalc == 'teaspoon' || unitsCalc == 'tsps' || unitsCalc == 'teaspoons')
    {
      return amt * 4.92892; // Assuming 1 tsp = 4.92892 ml
    }
    else if (unitsCalc == 'pound' || unitsCalc == 'lbs' || unitsCalc == 'lb')
    {
      return amt * 453.592; // Assuming 1 pound = 453.592 grams
    }
    else if (unitsCalc == 'pt' || unitsCalc == 'pint' || unitsCalc == 'pints' || unitsCalc == 'pts')
    {
      return amt * 473.176; // Assuming 1 pint = 473.176 ml
    }
    else if (unitsCalc == 'quart' || unitsCalc == 'qt' || unitsCalc == 'quarts'  || unitsCalc == 'qts')
    {
      return amt * 946.353; // Assuming 1 quart = 946.353 ml
    }
    else if (unitsCalc == 'mg' || unitsCalc == 'milligrams' || unitsCalc == 'milligram' || unitsCalc == 'mgs')
    {
      return amt / 1000; // Convert mg to grams
    }
    else if (unitsCalc == 'cl')
    {
      return amt * 10;
    }
    else
    {
      //print("$units|$doublePart|$unitsCalc");
      return -9999999999;
    }
  }

  Future<void> _apiFoodSearch(String text) async {
    setState((){_isLoading = true;});
    final uri = Uri.parse('https://search.openfoodfacts.org/search?q=$text&page_size=500&fields=nutriments,quantity,product_name,product_name_en,image_small_url,image_url');
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
      
      List<FoodItem> searchedFoods = products.map((product) {
        try {
        //print("${product['product_name']} / ${product['product_name_en']} / ${product['quantity']}");
        double grams;
        if (product['quantity'] == null){
          grams = 100;
        }
        else{
          grams = _toGrams(product['quantity']);
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
                  );
        return currFoodItem;
        } catch(e) {
          print("Error parsing api response: $e");
          return FoodItem(name: "_NO_NAME_", serving_size:"_NO_SERVING_SIZE", grams: -1, calories: -1, carbs: -1, fats: -1, protein: -1, sugar: -1, normalized_name: "NO_NORMALIZED_NAME");
        }
      }).toList();
      
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
                        return _buildFoodListItem(food, widget.addingFoodFunc(food)); 
                      },
                    ),
                  ),
              ],
            )
      );
  }
}
