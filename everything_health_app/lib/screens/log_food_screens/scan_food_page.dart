// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../log_food_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:isar/isar.dart';
import 'package:everything_health_app/models/saved_foods.dart';
import 'package:everything_health_app/models/history_foods.dart';

class ScanFoodPage extends StatefulWidget {
  final Function addFoodFunc;

  const ScanFoodPage({super.key, required this.addFoodFunc});

  @override
  State<ScanFoodPage> createState() => _ScanFoodPageState();
}

class _ScanFoodPageState extends State<ScanFoodPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessingScan = false; // To prevent multiple scans at once
  CameraController?
      _controller; // Make nullable to handle initial uninitialized state
  Future<void>? _initializeControllerFuture; // Make nullable
  String _loadError = '';
  bool _isLoading = false;
  String foundFoodStatus = "none";
  FoodItem? food;
  int elementState = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    elementState = 0;
  }

  Future<void> barcodeDetected(capture) async {
    if (!_isProcessingScan && capture.barcodes.isNotEmpty) {
      setState(() {
        _isProcessingScan = true; // Prevents multiple rapid scans
        _isLoading = true;
        elementState = 0;
      });

      final String barcodeValue =
          capture.barcodes.first.rawValue ?? "Could not read barcode";
      final savedFood = await isar.savedFoods
          .filter()
          .codeEqualTo(int.parse(barcodeValue))
          .findFirst();
      FoodItem? foundFood;
      if (savedFood != null) {
        foundFood = FoodItem.fromJson(savedFood.toJson());
        foundFoodStatus = "Food found in Saved Foods";
      } else {
        final historyFood = await isar.historyFoods
            .filter()
            .codeEqualTo(int.parse(barcodeValue))
            .findFirst();
        if (historyFood != null) {
          foundFood = FoodItem.fromJson(historyFood.toJson());
          foundFoodStatus = "Food found in History Foods";
        } else {
          //search api
          final uri = Uri.parse(
              'https://openfoodfacts.org/api/v3/product/$barcodeValue?&fields=nutriments,quantity,product_name,product_name_en,image_small_url,image_url,code');
          final response = await http.get(uri);
          String responseBody = '';
          if (response.statusCode == 200) {
            responseBody = response.body;
          } else {
            setState(() {
              _loadError =
                  "Failed to load food data from API. Status code: ${response.statusCode}";
              _isLoading = false;
            });
            return;
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
            
          final Map<String, dynamic> decodedData = json.decode(responseBody);
          final dynamic product = decodedData['product'] ?? [];
          if (decodedData['status'] != 'success') {
            foundFood = FoodItem(
              name: "​New Food ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}",
              serving_size: "100 g",
              grams: 100,
              calories: 0,
              carbs: 0,
              fats: 0,
              protein: 0,
              sugar: 0,
              density: 0,
              densityRequired: false,
              normalized_name: _normalizeText("​New Food ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}"),
              servings: 1,
              code: int.parse(barcodeValue),
            );
            foundFoodStatus = "Food not found";
          }
          else{
            
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
            try {
              //print("${product['product_name']} / ${product['product_name_en']} / ${product['quantity']}");
              double grams;
              bool densityRequired = true;
              if (product['quantity'] == null) {
                grams = 100;
              } else {
                List gramsOutput = _toGrams(product['quantity']);
                grams = gramsOutput[0];
                densityRequired = gramsOutput[2];
              }
              double g100Mult = grams / 100;

              String serving_size =
                  product['quantity'] ?? '100g Assumed Serving Size';
              if (g100Mult <= 0 && product['quantity'] != null) {
                serving_size =
                    '100g Assumed—unable to parse: ${product["quantity"]}';
                g100Mult = 1;
                grams = 100;
              }
              String name = product['product_name'] ??
                  product['product_name_en'] ??
                  '_NO_NAME_';
              num calories = -1;
              if (product['nutriments']?['energy-kcal_100g'] != null) {
                calories = product['nutriments']?['energy-kcal_100g'] * g100Mult;
              } else if (product['nutriments']?['energy-kj_100g'] != null) {
                calories =
                    product['nutriments']?['energy-kj_100g'] * g100Mult / 4.184;
              }
              num carbs = -1;
              if (product['nutriments']?['carbohydrates_100g'] != null) {
                carbs = product['nutriments']?['carbohydrates_100g'] * g100Mult;
              }
              num fats = -1;
              if (product['nutriments']?['fat_100g'] != null) {
                fats = product['nutriments']?['fat_100g'] * g100Mult;
              }
              num proteins = -1;
              if (product['nutriments']?['proteins_100g'] != null) {
                proteins = product['nutriments']?['proteins_100g'] * g100Mult;
              }
              num sugars = -1;
              if (product['nutriments']?['sugars_100g'] != null) {
                sugars = product['nutriments']?['sugars_100g'] * g100Mult;
              }
              String image_small_url = "";
              if (product['image_small_url'] != null) {
                image_small_url = product['image_small_url'];
              }
              String img_url = image_small_url;
              if (product['image_url'] != null) {
                img_url = product['image_url'];
              }
              if (image_small_url == "") {
                image_small_url = img_url;
              }
              num code = -1;
              if (product['code'] != null) {
                code = num.parse(product['code']);
              }
              num servings = 1;
              if (product['servings'] != null) {
                servings = num.parse(product['servings']);
              }
              
              foundFood = FoodItem(
                  name: name,
                  serving_size: serving_size,
                  grams: grams,
                  calories: calories,
                  carbs: carbs,
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
                  servings: servings,
              );
              foundFoodStatus = "Food found in web database";
            } catch (e) {
              print("Error parsing api response: $e");
            } 
          }
          _isLoading = false;
        }
      }
      setState(() {
        foundFoodStatus = foundFoodStatus;
        food = foundFood;
        _isLoading = false;
        _isProcessingScan = false;
      });
      _scannerController.stop();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (cameras.isEmpty) {
        // Handle case where no cameras are found
        print('No cameras found on this device.');
        setState(() {
          // You might want to show an error message instead of loading indicator
        });
        return;
      }
      final obsCamera = cameras.firstWhere(
        (camera) => camera.name.contains('OBS'),
        // If not found, fall back to the first available camera
        orElse: () => cameras.first,
      );
      // Initialize the controller with the first available camera
      _controller = CameraController(
        obsCamera, // Use the first available camera
        ResolutionPreset.medium,
        enableAudio:
            true, // Typically needed for video recording, good practice
      );

      _initializeControllerFuture =
          _controller!.initialize(); // Initialize the controller

      // Ensure the UI updates when initialization is complete
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
      // Handle error (e.g., show an error message to the user)
      setState(() {
        _controller = null; // Mark controller as not initialized on error
        _initializeControllerFuture = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose(); // Use null-safe call
    _scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size;
  final double pageHeight = screenSize.height;
  final double pageWidth = screenSize.width;

    if (elementState == 0) {
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 60),
              width: double.infinity,
              color: const Color.fromARGB(255, 0, 36, 72),
              child: Stack(
                children: [
                  Column(children: [
                    GestureDetector(
                      onTap: () => setState(() => elementState = 1),
                      child: Container(
                          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                          height: 100,
                          width: 500,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color.fromARGB(255, 65, 224, 192)),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Text("Scan Barcode",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                        overflow: TextOverflow.clip)),
                                SizedBox(width: 20),
                                Icon(Icons.barcode_reader, color: Colors.white),
                              ])),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => elementState = 2),
                      child: Container(
                          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                          height: 100,
                          width: 500,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color.fromARGB(255, 65, 224, 192)),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Text("Analyze Picture",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                        overflow: TextOverflow.clip)),
                                SizedBox(width: 20),
                                Icon(Icons.camera_alt, color: Colors.white),
                              ])),
                    ),
                  ]),
                ],
              )),
            foundFoodStatus != "none" ? 
                  Stack(
                    children:[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            foundFoodStatus = "none";
                          });
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(color: const Color.fromARGB(150, 0, 0, 0)),
                        )),
                      Center(
                          child: Container(
                              height: pageHeight * .7,
                              width: pageWidth * .9,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 36, 72),
                                borderRadius: BorderRadius.circular(pageWidth * .05)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _isLoading ? 
                                  Text(_loadError, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center,): 
                                  Text(foundFoodStatus, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center, overflow: TextOverflow.clip,),
                                  !food!.name.startsWith("​New Food") ? 
                                    Container(
                                      width: 300,
                                      height: 300,
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
                                          onTap: widget.addFoodFunc(food),
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
                                                  color: food!.color,
                                                  child: Row(
                                                    children: [
                                                      // Position the stats at the top right
                                                      Expanded(
                                                        flex: 6,
                                                        child: Image.network(food!.img_url, fit: BoxFit.contain,
                                                            loadingBuilder: (BuildContext context, Widget child,
                                                                ImageChunkEvent? loadingProgress) {
                                                          if (loadingProgress == null) {
                                                            return child; // Image is fully loaded
                                                          }
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              // Optionally use loadingProgress to show download percentage
                                                              value: loadingProgress.expectedTotalBytes != null
                                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                                      loadingProgress.expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        }, errorBuilder: (BuildContext context, Object exception,
                                                                StackTrace? stackTrace) {
                                                          // You can return any widget here, e.g., an icon or placeholder text
                                                          return Container();
                                                        }),
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
                                                                  food!.serving_size,
                                                                  maxLines: 1,
                                                                  minFontSize: 1,
                                                                  maxFontSize: 20,
                                                                  textAlign: TextAlign.right,
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10, // The starting font size
                                                                    shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 2.0)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: AutoSizeText(
                                                                  "${food!.calories.toStringAsFixed(0)} kcal",
                                                                  maxLines: 1,
                                                                  minFontSize: 1,
                                                                  maxFontSize: 20,
                                                                  textAlign: TextAlign.right,
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
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
                                                        food!.name,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    :
                                    GestureDetector(
                                        onTap: widget.addFoodFunc(food),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                                          height: 100,
                                          width: 300,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color.fromARGB(255, 65, 224, 192)),
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                          child: 
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text("Create New Food", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), overflow: TextOverflow.clip)),
                                                SizedBox(width: 20),
                                                Icon(Icons.add, color: Colors.white),
                                              ])
                                        ),
                                      ),
                                    !["Food found in Saved Foods", "Food found in History Foods"].contains(foundFoodStatus) ? SizedBox.shrink() : 
                                      GestureDetector(
                                          onTap: () => print("Searching api (add later)"),
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                                              height: 100,
                                              width: pageWidth * .75,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Color.fromARGB(255, 65, 224, 192)),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: 
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: Text("Search Web Database Instead", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), overflow: TextOverflow.clip)),
                                                    SizedBox(width: 20),
                                                    Icon(Icons.add, color: Colors.white),
                                                  ])
                                            ),
                                          ),
                                        ),
                                ],
                              )
                          )
                        ),
                      Positioned(
                        top: pageHeight * .95 - 50 / 2,
                        left: pageWidth * .5 - 50 / 2,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              foundFoodStatus = "none";
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 88, 175),
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ))
                    ],
                  ) : SizedBox.shrink(),
        ],
      );
    } else if (elementState == 1) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 36, 72),
        body: Container(
          margin: EdgeInsets.only(top: 60),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double pageWidth = constraints.maxWidth;
              double pageHeight = constraints.maxHeight;
              double cropSize = min(pageWidth, pageHeight);
              return Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: cropSize,
                      height: cropSize,
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: cropSize,
                              height: cropSize *
                                  (cropSize == pageWidth
                                      ? _controller!.value.aspectRatio
                                      : 1 / _controller!.value.aspectRatio),
                              child: MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) => barcodeDetected(capture),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.link, color: Colors.white, size: 50)
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.topCenter,
                    child: Text("Scan Barcode", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center, overflow: TextOverflow.clip),
                  ),
                  Positioned(
                      top: 5,
                      left: 5,
                      child: GestureDetector(
                          onTap: () => setState(() => elementState = 0),
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(155, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.white)))),
                ],
              );
            },
          ),
        ),

        /* Container(
            margin: EdgeInsets.only(top: 60),
            child: 
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) => barcodeDetected(capture),
              ) 
        )*/
      );
    } else {
      return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 0, 36, 72), // Match your color
        body: Container(
          margin: EdgeInsets.only(top: 60),
          child: _controller == null || _initializeControllerFuture == null
              ? Stack(children: [
                  Center(child: CircularProgressIndicator()),
                  Positioned(
                      top: 5,
                      left: 5,
                      child: GestureDetector(
                          onTap: () => setState(() => elementState = 0),
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(155, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.white)))),
                ])
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double pageWidth = constraints.maxWidth;
                    double pageHeight = constraints.maxHeight;
                    double cropSize = min(pageWidth, pageHeight);
                    return Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: cropSize,
                            height: cropSize,
                            child: ClipRect(
                              child: OverflowBox(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    width: cropSize,
                                    height: cropSize *
                                        (cropSize == pageWidth
                                            ? _controller!.value.aspectRatio
                                            : 1 /
                                                _controller!.value.aspectRatio),
                                    child: CameraPreview(
                                        _controller!), // this is my CameraPreview
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(Icons.square_outlined, color: Colors.white, size: cropSize * .8)
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.topCenter,
                          child: Text("Analyze Food Picture", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center, overflow: TextOverflow.clip),
                        ),
                  
                        Positioned(
                            top: 5,
                            left: 5,
                            child: GestureDetector(
                                onTap: () => setState(() => elementState = 0),
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(155, 0, 0, 0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Colors.white)))),
                      ],
                    );
                  },
                ),
        ),
      );
    }
  }
}
