import 'package:everything_health_app/main.dart';
import 'package:everything_health_app/models/history_foods.dart';
import 'package:everything_health_app/screens/log_food_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';

class ChooseFoodItem extends StatefulWidget {
  final FoodItem food;
  final Function close;
  final Function (String) goHome;
  final Function (FoodItem) addFoodToSaved;
  final Function (FoodItem) addFoodToHistory;

  const ChooseFoodItem({super.key, required this.food, required this.close, required this.goHome, required this.addFoodToSaved, required this.addFoodToHistory});

  @override
  State<ChooseFoodItem> createState() => _ChooseFoodItemState();
}

class _ChooseFoodItemState extends State<ChooseFoodItem> {
  late TextEditingController _nameTextController;
  bool _enlargeImage = false;
  bool _editing = false;
  List<int> _editSelection = [-1];
  num currScaleFactor = 1;
  late FoodItem currFood;
  bool ifSetCurrFoodVals = false;
  List? _currFoodVals;

  @override
  void initState() {
    super.initState();
    currFood = widget.food;
    _nameTextController = TextEditingController();
  }

  //BEFORE OTHER METHODS AFTER INITSTATE @IMPORTANT
  @override
  void didUpdateWidget(covariant ChooseFoodItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.food != oldWidget.food) {
      setState(() {
        currFood = widget.food;
      });
    }
  }

  void _handleEnlargeImage() {
    setState(() {
      if (widget.food.image_small_url != "" &&
          widget.food.image_small_url != "NO_IMAGE_FOUND") {
        _enlargeImage = !_enlargeImage;
      }
    });
  }

  void _toggleEditAll() {
    setState(() {
      _editing = !_editing;
      if (!_editing) {
        _editSelection = [-1];
      } else {
        _editSelection = [0];
      }
    });
  }

  Function _toggleEditSpecific(int editIndex) {
    return (() {
      setState(() {
        if (_editSelection.contains(0)) {
          _editSelection = [1, 2, 3, 4, 5, 6, 7, 8];
        }
        if (!_editSelection.contains(editIndex)) {
          _editing = true;
          _editSelection.add(editIndex);
          _editSelection.remove(-1);
          return;
        }
        while (_editSelection.contains(editIndex)) {
          _editSelection.remove(editIndex);
          if (_editSelection.isEmpty) {
            _editing = false;
            _editSelection = [-1];
          }
        }
      });
    });
  }

  void _scaleUpFoods(num scale) {
    setState(() {
      for (int i = 2; i < _currFoodVals!.length - 3; i++) {
        _currFoodVals![i] *= scale;
      }
    });
  }

  Future<void> _addFood() async {
    FoodItem tempFood = FoodItem(
      name: _currFoodVals![10], 
      serving_size: _currFoodVals![1],
      grams: _currFoodVals![2],
      calories: _currFoodVals![3],
      carbs: _currFoodVals![4],
      fats: _currFoodVals![5],
      protein: _currFoodVals![6],
      sugar: _currFoodVals![7],
      density: _currFoodVals![8],
      normalized_name: _normalizeText(_currFoodVals![10]),
      densityRequired: _currFoodVals![11],
      time: DateTime.now().toUtc().difference(DateTime.utc(1970, 1, 1)).inSeconds,
    );
    HistoryFood newEntry = HistoryFood.fromJson(tempFood.toJson());
    await isar.writeTxn(() async {
      // Take your 'newEntry' paper and put it in the 'historyFoods' binder
      await isar.historyFoods.put(newEntry); 
    });
    widget.close();
    Function func = widget.goHome("Food Added");
    func();
  }

  Future<void> _saveFood() async {
    FoodItem tempFood = FoodItem(
      name: _currFoodVals![10], 
      serving_size: _currFoodVals![1],
      grams: _currFoodVals![2],
      calories: _currFoodVals![3],
      carbs: _currFoodVals![4],
      fats: _currFoodVals![5],
      protein: _currFoodVals![6],
      sugar: _currFoodVals![7],
      density: _currFoodVals![8],
      normalized_name: _normalizeText(_currFoodVals![10]),
      densityRequired: _currFoodVals![11],
    );
    HistoryFood newEntry = HistoryFood.fromJson(tempFood.toJson());
    await isar.writeTxn(() async {
      // Take your 'newEntry' paper and put it in the 'historyFoods' binder
      await isar.historyFoods.put(newEntry); 
    });
  }

  void _handleNameChange(String str) {
    setState(() {
      _currFoodVals![10] = str;
    });
  }
  
  static String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), '');
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pageHeight = screenSize.height;
    final double pageWidth = screenSize.width;

    if (!ifSetCurrFoodVals ||
        (_currFoodVals![1] == "DEFAULT_SERVING_SIZE" &&
            _currFoodVals![2] == -1) ||
        (currFood.normalized_name != _currFoodVals![9])) {
      _currFoodVals = [
        "",
        currFood.serving_size,
        currFood.grams,
        currFood.calories,
        currFood.carbs,
        currFood.fats,
        currFood.protein,
        currFood.sugar,
        currFood.density,
        currFood.normalized_name,
        currFood.name,
        currFood.densityRequired,
      ];
      ifSetCurrFoodVals = true;
    }

    if (widget.food.name == "DEFAULT_NAME" && widget.food.grams == -1) {
      return Container(height: 0);
    } else {
      Widget enlargedPic = Container();
      if (_enlargeImage) {
        enlargedPic = Stack(children: [
          GestureDetector(
              onTap: () => _handleEnlargeImage(),
              child: Container(
                decoration:
                    BoxDecoration(color: const Color.fromARGB(150, 0, 0, 0)),
              )),
          Center(
            child: IgnorePointer(
              ignoring: true,
              child: SizedBox(
                height: pageHeight * .75,
                width: pageWidth,
                child: Image.network(currFood.img_url, fit: BoxFit.contain,
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
            ),
          ),
          Positioned(
              top: pageHeight * .8 * .10 - 50 / 2,
              left: pageWidth * .8 * .10 - 50 / 2,
              child: GestureDetector(
                  onTap: _handleEnlargeImage,
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(155, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white)))),
        ]);
      }
      if (!_editing){_nameTextController.text = _currFoodVals![10];}
      return Stack(children: [
        GestureDetector(
            onTap: () {
              setState(() => _editSelection = [-1]); 
              widget.close();},
            child: Container(
              decoration:
                  BoxDecoration(color: const Color.fromARGB(150, 0, 0, 0)),
            )),
        Stack(children: [
          Center(
            child: Container(
                height: pageHeight * .8,
                width: pageWidth * .8,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(pageWidth * .05)),
                child: Column(
                  children: [
                    Stack(children: [
                      Container(
                          height: 125,
                          width: pageWidth * .8,
                          decoration: BoxDecoration(color: currFood.color)),
                      Row(children: [
                        GestureDetector(
                            onTap: () => _handleEnlargeImage(),
                            child: Container(
                              height: 150,
                              width: pageWidth * .3,
                              decoration: BoxDecoration(
                                  color: currFood.color,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(25))),
                              clipBehavior: Clip.antiAlias,
                              child: Center(
                                child: Image.network(currFood.image_small_url,
                                    fit: BoxFit.cover, loadingBuilder:
                                        (BuildContext context, Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image is fully loaded
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      // Optionally use loadingProgress to show download percentage
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }, errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                  // You can return any widget here, e.g., an icon or placeholder text
                                  return Container();
                                }),
                              ),
                            )),
                        SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              Container(
                                  height: 25,
                                  width: pageWidth * .5,
                                  color: Colors.amber,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: pageWidth * .1),
                                        GestureDetector(
                                          onTap: () => _toggleEditAll(),
                                          child: _editing
                                              ? Icon(Icons.check)
                                              : Icon(Icons.edit),
                                        ),
                                        GestureDetector(
                                          onTap: _saveFood,
                                          child: Icon(Icons.bookmark),
                                        ),
                                        GestureDetector(
											onTap: () => _addFood(),
											child: Icon(Icons.add),
										),
                                      ])),
                              Container(
                                  height: 100,
                                  width: pageWidth * .5,
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: _editing ? 
                                    TextField(
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      controller: _nameTextController,
                                      onChanged: _handleNameChange,
                                      style: TextStyle(overflow: TextOverflow.ellipsis),
                                    )
                                    : AutoSizeText(
                                      _currFoodVals![10],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                              Text(currFood.code.toString()),
                            ],
                          ),
                        ),
                      ])
                    ]),
                    //Temp info displayer
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          ModifiableFoodItemData(
                              lbl: "Serving Size",
                              qty: _currFoodVals![1],
                              amt: null,
                              uts: null,
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          _currFoodVals![11]
                              ? ModifiableFoodItemData(
                                  lbl: "Density",
                                  qty: null,
                                  amt: _currFoodVals![8],
                                  uts: "g/ml",
                                  editValue: _editSelection,
                                  editSpecific: _toggleEditSpecific,
                                  currFood: currFood,
                                  currFoodVals: _currFoodVals!,
                                  scaleFunc: _scaleUpFoods)
                              : SizedBox.shrink(),
                          ModifiableFoodItemData(
                              lbl: "Calories",
                              qty: null,
                              amt: _currFoodVals![3],
                              uts: 'kcal',
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Carbohydrates",
                              qty: null,
                              amt: _currFoodVals![4],
                              uts: 'g',
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Fats",
                              qty: null,
                              amt: _currFoodVals![5],
                              uts: 'g',
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Protein",
                              qty: null,
                              amt: _currFoodVals![6],
                              uts: 'g',
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Sugar",
                              qty: null,
                              amt: _currFoodVals![7],
                              uts: 'g',
                              editValue: _editSelection,
                              editSpecific: _toggleEditSpecific,
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
							SizedBox(height: 150),
                        ]),
                      ),
                    )
                  ],
                )),
          ),
          enlargedPic,
          Positioned(
			top: pageHeight * .9 - 75,
			left: pageWidth * .5 - 150/2,
            child: GestureDetector(
				onTap: _editing ? () => _toggleEditAll() : () => _addFood(),
				child: Container(
					height: 75,
					width: 150,
					decoration: BoxDecoration(
						color: Colors.orange,
						borderRadius: BorderRadius.vertical(top: Radius.circular(5))
					),
					child: _editing ? Center(child: Text("Save"),) : Center(child: Text("Add"),)
				),
			),
          ),
          Positioned(
              top: pageHeight * .95 - 30 / 2,
              left: pageWidth * .5 - 30 / 2,
              child: GestureDetector(
                onTap: () {
                  setState(() { 
                    _enlargeImage = false;
                    _editSelection = [-1];});
                  widget.close();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30)),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ))
        ])
      ]);
    }
  }
}

class ModifiableFoodItemData extends StatefulWidget {
  final String lbl;
  final String? qty;
  final num? amt;
  final String? uts;
  final List<int> editValue;
  final Function(int editIndex)
      editSpecific; // Clarified signature for editSpecific
  final FoodItem currFood;
  final List currFoodVals;
  final Function(num scale) scaleFunc;

  const ModifiableFoodItemData({
    super.key,
    required this.lbl,
    this.qty,
    this.amt,
    this.uts,
    required this.editValue,
    required this.editSpecific,
    required this.currFood,
    required this.currFoodVals,
    required this.scaleFunc,
  });

  @override
  State<ModifiableFoodItemData> createState() => _ModifiableFoodItemDataState();
}

class _ModifiableFoodItemDataState extends State<ModifiableFoodItemData> {
  static const List<String> _attributes = [
    "",
    "Serving Size",
    "Grams",
    "Calories",
    "Carbohydrates",
    "Fats",
    "Protein",
    "Sugar",
    "Density",
  ];
  static const List<String> _attributesName = [
    "",
    "serving_size",
    "grams",
    "calories",
    "carbs",
    "fats",
    "protein",
    "sugar",
    "density"
  ];
  static const weightUnitsPerGram = {
    'g': 1.0,
    'kg': 1000.0,
    'oz': 28.3495,
    'lb': 453.592,
    'mg': .001,
  };

  static const volumeUnitsPerMl = {
    'mL': 1.0,
    'L': 1000.0,
    'fl oz': 30.0,
    'cup': 236.588,
    'tbsp': 14.787,
    'tsp': 4.92892,
    'pt': 473.176,
    'qt': 947.353,
    'cL': 10,
  };

  static const unitNormalization = {
    'g': ['g', 'grams', 'gm', 'г', 'gram', 'gms'],
    'mL': ['ml', 'milliliter', 'milliliters'],
    'kg': ['kg', 'killogram', 'killograms'],
    'L': ['l', 'liters', 'liter'],
    'fl oz': ['fl', 'floz', 'fluid', 'fluid oz', 'fluid ounce'],
    'oz': ['oz', 'ounce', 'ounces'],
    'cup': ['cup', 'cups', 'c'],
    'tbsp': ['tbsp', 'tablespoon', 'tbsps', 'tablespoons'],
    'tsp': ['tsp', 'teaspoon', 'tsps', 'teaspoons'],
    'lb': ['pounds', 'pound', 'lb', 'lbs'],
    'pt': ['pt', 'pint', 'pints', 'pts'],
    'qt': ['qt', 'quart', 'quarts,' 'qts'],
    'mg': ['mg', 'milligrams', 'millgram', 'mgs'],
    'cL': ['cl'],
  };

  late TextEditingController _textController;
  late List _currFoodVals;
  bool _isCurrentlyEditing = false;
  num? startingAmount;
  num? amount;
  String? startingUnits;
  String? units;
  int? currEditIndex;
  num? currZeroScale;
  num densityScale = 1.0;
  String? attributeID;
  bool? scaleOtherUnits;
  Function? _scaleUpFoods;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    startingAmount = widget.amt;
    amount = widget.amt; // Initialize current amount with starting amount
    startingUnits = widget.uts;
    units = widget.uts; // Initialize current units
    currZeroScale = amount;
    densityScale = widget.currFood.density;
    scaleOtherUnits = widget.lbl == "Serving Size";
    _currFoodVals = widget.currFoodVals;
    _scaleUpFoods = widget.scaleFunc;
    _updateEditingStateAndText();
  }

  @override
  void didUpdateWidget(ModifiableFoodItemData oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool propsChanged = widget.editValue != oldWidget.editValue ||
        widget.lbl != oldWidget.lbl ||
        widget.amt != oldWidget.amt ||
        widget.qty != oldWidget.qty ||
        widget.uts != oldWidget.uts;
    if (propsChanged) {
      // If the base amount from the parent widget changes, update startingAmount
      if (widget.amt != oldWidget.amt) {
        // If not currently editing, or if the definitive amount changed, update current amount
        if (!_isCurrentlyEditing || widget.amt != oldWidget.amt) {
          amount = widget.amt;
        }
      }
      if (widget.uts != oldWidget.uts) {
        // Update units if they change
        units = widget.uts;
      }
      _updateEditingStateAndText();
    }
  }

  // Helper to get the initial value for the TextField based on the label
  String _getInitialValueForEditor() {
    // Use the current 'amount' state, which is synchronized with the slider
    return amount?.toStringAsFixed(1) ??
        ""; // Format to one decimal for consistency
  }

  void _updateEditingStateAndText() {
    int currEditIndex = _attributes.indexOf(widget.lbl);
    bool shouldBeEditing = widget.editValue.contains(currEditIndex) ||
        (widget.editValue.isNotEmpty && widget.editValue[0] == 0);

    if (_isCurrentlyEditing != shouldBeEditing) {
      setState(() {
        _isCurrentlyEditing = shouldBeEditing;
      });
    }

    if (shouldBeEditing) {
      final initialText = _getInitialValueForEditor();
      if (_textController.text != initialText) {
        _textController.text = initialText;
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length),
        );
      }
    }
  }

  void _resetToDefaultValue() {
    Function func = widget.editSpecific(currEditIndex!);
    setState(() {
      func();
      if (units != startingUnits) {
        _changeUnits(normalizeUnit(startingUnits!));
        units = startingUnits;
        _currFoodVals[currEditIndex!] = "$amount $units";
      }

      if (attributeID == "serving_size") {
        if (scaleOtherUnits == true) _scaleUpFoods!(startingAmount! / amount!);
        _currFoodVals[currEditIndex!] = "$startingAmount $units";
      } else if (attributeID == "calories") {
        if (units == "kJ") {
          _currFoodVals[currEditIndex!] = startingAmount! / 4.184;
        }
      } else {
        _currFoodVals[currEditIndex!] = startingAmount;
      }
      amount = startingAmount;
      _isCurrentlyEditing = false;
      _textController.text = (_currFoodVals[11] &&
                  attributeID != "serving_size" &&
                  attributeID != "density"
              ? startingAmount! * _currFoodVals[8]
              : startingAmount!)
          .toStringAsFixed(1);
      currZeroScale = startingAmount;
    });
  }

  void _handleTextboxChange(String str) {
    str = str.replaceAll(',', '.');
    _isCurrentlyEditing = true;
    setState(() {
      try {
        num newValue = double.parse(str);
        if (attributeID == "serving_size") {
          if (scaleOtherUnits == true) _scaleUpFoods!(newValue / amount!);
          _currFoodVals[currEditIndex!] = "$newValue $units";
        } else if (attributeID == "calories") {
          if (units == "kJ") {
            _currFoodVals[currEditIndex!] = newValue / 4.184;
          }
        } else {
          _currFoodVals[currEditIndex!] = newValue;
        }
        if (attributeID == "density") {
          _scaleUpFoods!(1.0);
        }
        amount = newValue;
      } catch (e) {
        if (str == "") {
          return;
        }
        amount = startingAmount;
        _textController.text = (_currFoodVals[11] &&
                    attributeID != "serving_size" &&
                    attributeID != "density"
                ? startingAmount! * _currFoodVals[8]
                : startingAmount!)
            .toStringAsFixed(1);
      }
    });
  }

  void _setZeroScale() {
    setState(() {
      if (amount != null) {
        amount! > 0 ? currZeroScale = amount : null;
      }
    });
  }
  String normalizeUnit (String value){
      String normalizedUnit = value
              .split(" ")[0]
              .trim()
              .replaceAll(RegExp(r'[^гa-zA-Z*]'), '')
              .contains(RegExp(r'[x*]'))
          ? value.split(" ").length > 1
              ? value.split(" ")[1].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '')
              : 'x'
          : value.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '');
    for (String i in unitNormalization.keys) {
      if (unitNormalization[i]!.contains(normalizedUnit.toLowerCase())) {
        normalizedUnit = i;
        break;
      }
    }
    return normalizedUnit;
  }

  void _changeUnits(String? newValue) {
    if (attributeID == "calories") {
      setState(() {
        if (newValue == "kJ") {
          amount = amount! * 4.184;
          startingAmount = startingAmount! * 4.184;
        } else {
          amount = amount! / 4.184;
          startingAmount = startingAmount! / 4.184;
        }
        units = newValue;
        _setZeroScale();
      });
      return;
    }

    bool oldIsWeightUnit = weightUnitsPerGram[normalizeUnit(units!)] != null;
    bool newIsWeightUnit = weightUnitsPerGram[newValue] != null;
    setState(() {
      if (oldIsWeightUnit != newIsWeightUnit) {
        if (oldIsWeightUnit){
          _currFoodVals[11] = true;
          widget.editSpecific(8);
        }
        else {
          _currFoodVals[11] = false;
        }
      }
      num? oldScale = oldIsWeightUnit
          ? weightUnitsPerGram[normalizeUnit(units!)]
          : volumeUnitsPerMl[normalizeUnit(units!)];
      num? newScale = newIsWeightUnit
          ? weightUnitsPerGram[newValue]
          : volumeUnitsPerMl[newValue];
      num densityFactor = _currFoodVals[11] && oldIsWeightUnit
          ? _currFoodVals[8]
          : 1.0;
      num scaleFactor = newIsWeightUnit ? (1 / newScale!) : (oldScale! / newScale!) * densityFactor;
      startingAmount = newIsWeightUnit ? scaleFactor * _currFoodVals[2] : startingAmount! * scaleFactor;
      amount = newIsWeightUnit ? _currFoodVals[2] * scaleFactor : amount! * scaleFactor;
      units = newValue;
      _currFoodVals[currEditIndex!] = "$amount $units";
      _scaleUpFoods!(1);
      _setZeroScale();
    });
  }

  @override
  void dispose() {
    _textController.dispose(); // Dispose of the controller
    super.dispose();
  }

  List seperateAmtAndUnits(String str) {
    String units = str
        .replaceFirst(RegExp(r'[\d.,/]+'), ' ')
        .replaceAll(RegExp(r'[\s]+'), ' ')
        .trim()
        .toLowerCase();
    String doublePart = str.replaceAll(RegExp(r'[^\d.,\s]+'), ' ').trim();
    List<String> mathStuff = str
        .replaceAll(',', '.')
        .replaceAll(RegExp(r'[^\d.,/\sx*]'), ' ')
        .replaceAll(r'/', r' / ')
        .replaceAll(RegExp(r'[x*]+'), ' x ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase()
        .split(" ");
    doublePart = doublePart.split(" ")[0];
    doublePart = doublePart.replaceAll(',', '.');
    try {
      if (double.parse(mathStuff[0]) > 0 &&
          double.parse(mathStuff[2]) > 0 &&
          (mathStuff[1] == '/')) {
        doublePart = (double.parse(mathStuff[0]) / double.parse(mathStuff[2]))
            .toString();
      }
      // ignore: empty_catches
    } catch (e) {}

    if (doublePart.isEmpty ||
        str.substring(0, 1).replaceAll(RegExp(r'[\d.]'), 'NUMBER') !=
            'NUMBER') {
      return [1, str];
    }
    return [double.parse(doublePart), units];
  }

  @override
  Widget build(BuildContext context) {
    currEditIndex = _attributes.indexOf(widget.lbl);
    attributeID = _attributesName[currEditIndex!];
    bool currEditing = widget.editValue.contains(currEditIndex) ||
        (widget.editValue.isNotEmpty && widget.editValue[0] == 0);
    String label = widget.lbl;
    String? quantity = widget.qty;
    amount = amount == null
        ? widget.amt
        : (amount! * 100000).roundToDouble() / 100000;

    !currEditing ? _setZeroScale() : null;
    if ((amount == null && quantity != null) ||
        (units == null && quantity != null)) {
      List tempList;
      quantity == "quantity not specified" ? 
        tempList = seperateAmtAndUnits("${_currFoodVals[2]}g") : 
        tempList = seperateAmtAndUnits(quantity);
      String normalUnit = normalizeUnit(tempList[1]);
      num? mlScale = volumeUnitsPerMl[normalUnit];
      
      if (!_currFoodVals[11] && mlScale != null)
      {
        _currFoodVals[8] = _currFoodVals[2] / (tempList[0]*mlScale);
        print(_currFoodVals[8]);
      }
      return ModifiableFoodItemData(
          lbl: label,
          qty: null,
          amt: tempList[0],
          uts: tempList[1],
          editValue: widget.editValue,
          editSpecific: widget.editSpecific,
          currFood: widget.currFood,
          currFoodVals: _currFoodVals,
          scaleFunc: widget.scaleFunc);
    }
    !_isCurrentlyEditing
        ? _textController.text = (_currFoodVals[11] &&
                    attributeID != "serving_size" &&
                    attributeID != "density"
                ? amount! * _currFoodVals[8]
                : amount!)
            .toStringAsFixed(1)
        : null;
    String strippedUnits = units!
            .split(" ")[0]
            .trim()
            .replaceAll(RegExp(r'[^гa-zA-Z*]'), '')
            .contains(RegExp(r'[x*]'))
        ? units!.split(" ").length > 1
            ? units!.split(" ")[1].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '')
            : 'x'
        : units!.split(" ")[0].trim().replaceAll(RegExp(r'[^гa-zA-Z]'), '');
    String normalizedUnit = "";
    for (String i in unitNormalization.keys) {
      if (unitNormalization[i]!.contains(strippedUnits.toLowerCase())) {
        normalizedUnit = i;
        break;
      }
    }

    Widget attributeDisplayDefault = Row(spacing: 5, children: [
      Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Text("$label:", overflow: TextOverflow.ellipsis),
      ),
      Spacer(),
      Container(
          width: 150,
          child: Text(
              "${((_currFoodVals[11] && attributeID != "serving_size" && attributeID != "density" ? amount! * _currFoodVals[8] : amount!).toStringAsFixed(1))} ${units!}",
              overflow: TextOverflow.ellipsis)),
      Container(
          child: GestureDetector(
        onTap: widget.editSpecific(currEditIndex!),
        child: Icon(Icons.edit),
      ))
    ]);

    Widget attributeDisplayEdit = Column(
      children: [
        Row(spacing: 5, children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text("$label:", overflow: TextOverflow.ellipsis),
          ),
          Spacer(),
          Container(
            width: 50,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _textController,
              onChanged: _handleTextboxChange,
              style: TextStyle(overflow: TextOverflow.ellipsis),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]*'))
              ],
            ),
          ),
          Container(
            width: 100,
            child: "calories" == attributeID
                ? DropdownButton<String>(
                    value: units,
                    onChanged: (String? newValue) => _changeUnits(newValue),
                    items: ["kcal", "kJ"]
                        .map((unit) => DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                  )
                : normalizedUnit != "" && "serving_size" == attributeID
                    ? DropdownButton<String>(
                        value: normalizedUnit,
                        onChanged: (String? newValue) => _changeUnits(newValue),
                        items: [
                          ...weightUnitsPerGram.keys
                              .map((unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  )),
                          ...volumeUnitsPerMl.keys
                              .map((unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                        ],
                      )
                    : Text(units!),
          ),
          GestureDetector(
            onTap: _resetToDefaultValue,
            child: Icon(Icons.undo),
          ),
          Container(
              child: GestureDetector(
            onTap: widget.editSpecific(currEditIndex!),
            child: Icon(Icons.check),
          ))
        ]),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            // Optional: Customize slider appearance
            activeTrackColor: Colors.blueAccent.shade100,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: Colors.blueAccent,
            overlayColor: Colors.blueAccent.withAlpha(0x29), // Splash color
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            trackHeight: 2.0,
          ),
          child: Slider(
            onChangeEnd: (double num) => setState(() => currZeroScale! < .1
                ? currZeroScale = .1
                : num > currZeroScale! * 1.9
                    ? currZeroScale = currZeroScale! * 2
                    : num < currZeroScale! / 4 && num != 0
                        ? currZeroScale = num
                        : null),
            value: ((amount ?? 0.0).toDouble()).clamp(0.0,
                (currZeroScale! >= 0 ? currZeroScale!.toDouble() * 2.0 : 0.0)),
            min: 0.0,
            max: (currZeroScale == 0 || currZeroScale == null)
                ? 100.0
                : (currZeroScale! < 0 ? 0.0 : currZeroScale!.toDouble() * 2.0),
            divisions: 1000,
            label: (_currFoodVals[11] &&
                        attributeID != "serving_size" &&
                        attributeID != "density"
                    ? amount! * _currFoodVals[8]
                    : amount!)
                .toStringAsFixed(1),
            onChanged: (double newValue) {
              setState(() {
                if (attributeID == "serving_size") {
                  if (scaleOtherUnits == true) {
                    _scaleUpFoods!(newValue / amount!);
                  }
                  _currFoodVals[currEditIndex!] = "$newValue $units";
                } else if (attributeID == "calories") {
                  if (units == "kJ") {
                    _currFoodVals[currEditIndex!] = newValue / 4.184;
                  }
                } else {
                  _currFoodVals[currEditIndex!] = newValue;
                }
                if (attributeID == "density") {
                  _scaleUpFoods!(1.0);
                }
                amount = newValue;
                _textController.text = (_currFoodVals[11] &&
                            attributeID != "serving_size" &&
                            attributeID != "density"
                        ? amount! * _currFoodVals[8]
                        : amount!)
                    .toStringAsFixed(1);
              });
            },
          ),
        ),
        attributeID == "serving_size"
            ? Row(
                children: [
                  Checkbox(
                    value: scaleOtherUnits,
                    onChanged: (bool? value) {
                      setState(() {
                        scaleOtherUnits = value;
                      });
                    },
                  ),
                  Text("Scale other attributes"),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      padding: EdgeInsets.all(10),
      child: currEditing ? attributeDisplayEdit : attributeDisplayDefault,
    );
  }
}
