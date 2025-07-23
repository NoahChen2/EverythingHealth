import 'dart:math';
import 'package:everything_health_app/main.dart';
import 'package:everything_health_app/models/history_foods.dart';
import 'package:everything_health_app/models/saved_foods.dart';
import 'package:everything_health_app/screens/log_food_page.dart';
import 'package:everything_health_app/services/color_services.dart';
import 'package:everything_health_app/services/nutrition_services.dart';
import 'package:everything_health_app/widgets/eh_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ChooseFoodItem extends StatefulWidget {
  final FoodItem food;
  final Function close;
  final Function(String) goHome;

  const ChooseFoodItem({
    super.key,
    required this.food,
    required this.close,
    required this.goHome,
  });

  @override
  State<ChooseFoodItem> createState() => _ChooseFoodItemState();
}

class _ChooseFoodItemState extends State<ChooseFoodItem> {
  late TextEditingController _nameTextController;
  late TextEditingController _codeTextController;
  bool _enlargeImage = false;
  bool _editing = false;
  List<int> _editSelection = [-1];
  num currScaleFactor = 1;
  late FoodItem currFood;
  bool ifSetCurrFoodVals = false;
  List? _currFoodVals;
  bool viewNutritionInfo = false;
  bool _isSaved = false;
  bool _needSaveDecision = false;
  bool _autoSaveApply = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  bool _autoHighlight = false;
  final NutritionService nutritionService = NutritionService();

  @override
  void initState() {
    super.initState();
    currFood = widget.food;
    _nameTextController = TextEditingController();
    _codeTextController = TextEditingController();
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

  void _toggleViewNutritionInfo() {
    setState(() {
      viewNutritionInfo = !viewNutritionInfo;
    });
  }

  Future<void> _handleApplyNew() async {
    _currFoodVals![10] = _currFoodVals![10].replaceAll('​', '');
    setState(() {
      _autoSaveApply = true;
      _isSaved = false;
      currFood.isSaved = false;
    });
    _toggleEditAll();
  }

  Future<void> _handleApplySave() async {
    _currFoodVals![10] = _currFoodVals![10].replaceAll('​', '');

    String tempImgPath =
        await nutritionService.imgRamToDrive(widget.food['img_url']);
    if (tempImgPath != widget.food['img_url']) {
      widget.food['img_url'] = tempImgPath;
      widget.food['image_small_url'] = tempImgPath;
    }
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
      servings: _currFoodVals![12],
      code: _currFoodVals![13],
      isSaved: true,
      time:
          DateTime.now().toUtc().difference(DateTime.utc(1970, 1, 1)).inSeconds,
      img_url: widget.food.img_url,
      image_small_url: widget.food.image_small_url,
      meal: _currFoodVals![14],
    );
    print('Saving... ${tempFood.name}');
    SavedFood newEntry = SavedFood.fromJson(tempFood.toJson());
    newEntry.id = currFood.id;
    await isar.writeTxn(() async {
      await isar.savedFoods.put(newEntry);
    });
    setState(() {
      _autoSaveApply = true;
    });
    _isSaved = true;
    _toggleEditAll();
  }

  void _toggleEditAll() {
    setState(() {
      if (currFood.isSaved && !_editing && !_autoSaveApply) {
        _needSaveDecision = true;
      } else if (currFood.isSaved && _editing || _autoSaveApply) {
        _needSaveDecision = false;
      }
      _editing = !_editing;
      if (!_editing) {
        _editSelection = [-1];
      } else {
        _editSelection = [0];
      }
    });
  }

/* Function _toggleEditSpecific(int editIndex) {
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
} */

  void _scaleUpFoods(num scale) {
    setState(() {
      for (int i = 2; i < 8; i++) {
        _currFoodVals![i] *= scale;
      }
    });
  }

  Future<void> _addFood() async {
    _currFoodVals![10] = _currFoodVals![10].replaceAll('​', '');
    String tempImgPath =
        await nutritionService.imgRamToDrive(widget.food['img_url']);
    if (tempImgPath != widget.food['img_url']) {
      widget.food['img_url'] = tempImgPath;
      widget.food['image_small_url'] = tempImgPath;
    }
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
      time: _currFoodVals![15],
      servings: _currFoodVals![12],
      code: _currFoodVals![13],
      meal: _currFoodVals![14],
      img_url: widget.food.img_url,
      image_small_url: widget.food.image_small_url,
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
    if (_isSaved) {
      setState(() {
        _isSaved = false;
        currFood.isSaved = false;
      });
      await isar.writeTxn(() async {
        await isar.savedFoods.delete(currFood.id);
      });
    } else {
      setState(() => _isSaved = true);
      _currFoodVals![10] = _currFoodVals![10].replaceAll('​', '');
      String tempImgPath =
          await nutritionService.imgRamToDrive(widget.food['img_url']);
      if (tempImgPath != widget.food['img_url']) {
        widget.food['img_url'] = tempImgPath;
        widget.food['image_small_url'] = tempImgPath;
      }
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
        servings: _currFoodVals![12],
        code: _currFoodVals![13],
        isSaved: true,
        time: DateTime.now()
            .toUtc()
            .difference(DateTime.utc(1970, 1, 1))
            .inSeconds,
        img_url: widget.food.img_url,
        image_small_url: widget.food.image_small_url,
        meal: _currFoodVals![14],
      );
      print('Saving... ${tempFood.name}');
      SavedFood newEntry = SavedFood.fromJson(tempFood.toJson());

      await isar.writeTxn(() async {
        // Take your 'newEntry' paper and put it in the 'historyFoods' binder
        int newID = await isar.savedFoods.put(newEntry);
        setState(() {
          currFood.id = newID;
          currFood.isSaved = true;
        });
      });
    }
  }

  void _handleNameChange(String str) {
    setState(() {
      _currFoodVals![10] = str;
    });
  }

  void _handleCodeChange(String str) {
    if (str == "") {
      return;
    }
    setState(() {
      try {
        _currFoodVals![13] = int.parse(str);
      }
      // ignore: empty_catches
      catch (e) {}
    });
  }

  void _highlightIfDefault() {
    if (_titleFocusNode.hasFocus &&
        _nameTextController.text
            .startsWith(RegExp(r'​New Food \d{4}\/\d{2}\/\d{2} \d{2}:\d{2}')) &&
        _autoHighlight) {
      // Use addPostFrameCallback to make sure the selection happens after the frame is built.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameTextController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _nameTextController.text.length,
        );
      });
      setState(() => _autoHighlight = false);
    }
  }

  static String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), '');
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }

  void _resetCode() {
    _codeTextController.text = widget.food.code.toStringAsFixed(0) == "-1"
        ? ""
        : widget.food.code.toStringAsFixed(0);
    _currFoodVals![13] = widget.food.code;
  }

  void _scanCode() {
    print("TODO: SCANNING...");
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _codeTextController.dispose();
    _codeFocusNode.dispose();
    _titleFocusNode.dispose();
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
        currFood.servings,
        currFood.code,
        currFood.meal,
        DateTime.now().toUtc().difference(DateTime.utc(1970, 1, 1)).inSeconds,
      ];
      if (!(_currFoodVals![1] == "DEFAULT_SERVING_SIZE" &&
          _currFoodVals![2] == -1)) {
        _isSaved = currFood.isSaved;
      }
      ifSetCurrFoodVals = true;
      _needSaveDecision = false;
      _autoSaveApply = false;
      if (_currFoodVals![10].startsWith("​New Food")) {
        _currFoodVals![10] = _currFoodVals![10].replaceAll('​', '');
        currFood.name = _currFoodVals![10];
        _nameTextController.text = currFood.name;
        _toggleEditAll();
      }
    }

    if (!_titleFocusNode.hasFocus) {
      _autoHighlight = true;
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
                decoration: BoxDecoration(color: ColorTheme["darkenMain"]),
              )),
          Center(
            child: IgnorePointer(
              ignoring: true,
              child: SizedBox(
                  height: pageHeight * .75,
                  width: pageWidth,
                  child: UniversalImage(
                      path: currFood.img_url, fit: BoxFit.contain)),
            ),
          ),
          EHFloatingButton(
              top: pageHeight * .8 * .10 - 50 / 2,
              left: pageWidth * .8 * .10 - 50 / 2,
              onTap: _handleEnlargeImage,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.arrow_back_ios,
                  color: ColorTheme["textPrimary"]),
              )),
        ]);
      }
      if (!_editing) {
        _nameTextController.text = _currFoodVals![10];
        _codeTextController.text = _currFoodVals![13].toStringAsFixed(0) == "-1"
            ? ""
            : _currFoodVals![13].toStringAsFixed(0);
      }
      return Stack(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _editSelection = [-1];
                _editing = false;
              });
              widget.close();
            },
            child: Container(
              decoration: BoxDecoration(color: ColorTheme["darkenMain"]),
            )),
        EHPopupDisplay(
            dismiss: () {
              setState(() {
                _editSelection = [-1];
                _editing = false;
              });
              widget.close();
            },
            height: pageHeight * .8,
            width: pageWidth * .9,
            closeTop: pageHeight * .95 - 50 / 2,
            closeLeft: pageWidth * .5 - 50 / 2,
            child: 
              Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Stack(children: [
                        Container(
                            height: 125,
                            width: pageWidth * .9,
                            decoration: BoxDecoration(color: currFood.color)),
                        Row(children: [
                          GestureDetector(
                              onTap: () => _handleEnlargeImage(),
                              child: Container(
                                height: 150,
                                width: pageWidth * .4,
                                decoration: BoxDecoration(
                                    color: currFood.color,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(25))),
                                clipBehavior: Clip.antiAlias,
                                child: Center(
                                    child: UniversalImage(
                                        path: currFood.image_small_url,
                                        fit: BoxFit.contain)),
                              )),
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  Container(
                                      height: 25,
                                      width: pageWidth * .5,
                                      color: ColorTheme["secondaryBG"],
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: pageWidth * .1),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _toggleEditAll(),
                                                child: _editing
                                                    ? Icon(Icons.check,
                                                        color: ColorTheme[
                                                            "textPrimary"])
                                                    : Icon(Icons.edit,
                                                        color: ColorTheme[
                                                            "textPrimary"]),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: _saveFood,
                                                child: Icon(
                                                    _isSaved
                                                        ? Icons.bookmark
                                                        : Icons
                                                            .bookmark_outline,
                                                    color: ColorTheme[
                                                        "textPrimary"]),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _addFood(),
                                                child: Icon(Icons.add,
                                                    color: ColorTheme[
                                                        "textPrimary"]),
                                              ),
                                            ),
                                          ])),
                                  SizedBox(
                                      height: 100,
                                      width: pageWidth * .5,
                                      child: Center(
                                        child: _editing
                                            ? Container(
                                                width: pageWidth * .5,
                                                padding: EdgeInsets.all(5),
                                                child: TextField(
                                                  cursorColor:
                                                      ColorTheme["textPrimary"],
                                                  keyboardType:
                                                      TextInputType.text,
                                                  focusNode: _titleFocusNode,
                                                  onTap: _highlightIfDefault,
                                                  showCursor: true,
                                                  maxLines: null,
                                                  controller:
                                                      _nameTextController,
                                                  onChanged: _handleNameChange,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: ColorTheme[
                                                          "textPrimary"]),
                                                ),
                                              )
                                            : GestureDetector(
                                                onDoubleTap: () {
                                                  _toggleEditAll();
                                                  _titleFocusNode
                                                      .requestFocus();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: AutoSizeText(
                                                    _currFoodVals![10],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorTheme[
                                                            "textPrimary"]),
                                                    maxLines: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                      )),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                          spacing: 5,
                                          children: !_editing
                                              ? [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onDoubleTap: () {
                                                        _toggleEditAll();
                                                        _codeFocusNode
                                                            .requestFocus();
                                                      },
                                                      child: Text(
                                                          (_currFoodVals![13] ==
                                                                  -1
                                                              ? "No Barcode Found"
                                                              : _currFoodVals![
                                                                      13]
                                                                  .toString()),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            color: ColorTheme[
                                                                "textPrimary"],
                                                          )),
                                                    ),
                                                  )
                                                ]
                                              : [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 25,
                                                      width: pageWidth * .3,
                                                      child: TextField(
                                                        cursorColor: ColorTheme[
                                                            "textPrimary"],
                                                        focusNode:
                                                            _codeFocusNode,
                                                        textAlign:
                                                            TextAlign.center,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                        ),
                                                        controller:
                                                            _codeTextController,
                                                        onChanged:
                                                            _handleCodeChange,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            color: ColorTheme[
                                                                "textPrimary"]),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[\d]*'))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: _resetCode,
                                                      child: Icon(Icons.undo,
                                                          color: ColorTheme[
                                                              "textPrimary"])),
                                                  GestureDetector(
                                                      onTap: _scanCode,
                                                      child: Icon(
                                                          Icons
                                                              .qr_code_scanner_sharp,
                                                          color: ColorTheme[
                                                              "textPrimary"])),
                                                ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                    //Temp info displayer
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          ModifiableFoodItemData(
                              lbl: "Meal",
                              qty: null,
                              amt: 0,
                              uts: "",
                              editValue: _editSelection,
                              editAll: () => _toggleEditAll(),
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Time",
                              qty: null,
                              amt: 0,
                              uts: "",
                              editValue: _editSelection,
                              editAll: () => _toggleEditAll(),
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          ModifiableFoodItemData(
                              lbl: "Serving Size",
                              qty: _currFoodVals![1],
                              amt: null,
                              uts: null,
                              editValue: _editSelection,
                              editAll: () => _toggleEditAll(),
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
                                  editAll: () => _toggleEditAll(),
                                  currFood: currFood,
                                  currFoodVals: _currFoodVals!,
                                  scaleFunc: _scaleUpFoods)
                              : SizedBox.shrink(),
                          ModifiableFoodItemData(
                              lbl: "Servings",
                              qty: null,
                              amt: _currFoodVals![12],
                              uts: "",
                              editValue: _editSelection,
                              editAll: () => _toggleEditAll(),
                              currFood: currFood,
                              currFoodVals: _currFoodVals!,
                              scaleFunc: _scaleUpFoods),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: viewNutritionInfo
                                    ? ColorTheme["primaryBGDark"]
                                    : ColorTheme["transparent"],
                                border: Border(
                                  top: BorderSide(
                                      color: ColorTheme["textPrimary"]!
                                          .withAlpha(50)),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => _toggleViewNutritionInfo(),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: ColorTheme["transparent"],
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                              "Show Nutrition Information",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12,
                                                  color: ColorTheme[
                                                      "textPrimary"])),
                                        ),
                                        Icon(
                                            viewNutritionInfo
                                                ? Icons.arrow_drop_down
                                                : Icons.arrow_right,
                                            color: ColorTheme["textPrimary"]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          viewNutritionInfo
                              ? Column(children: [
                                  ModifiableFoodItemData(
                                      lbl: "Calories",
                                      qty: null,
                                      amt: _currFoodVals![3],
                                      uts: 'kcal',
                                      editValue: _editSelection,
                                      editAll: () => _toggleEditAll(),
                                      currFood: currFood,
                                      currFoodVals: _currFoodVals!,
                                      scaleFunc: _scaleUpFoods),
                                  ModifiableFoodItemData(
                                      lbl: "Carbohydrates",
                                      qty: null,
                                      amt: _currFoodVals![4],
                                      uts: 'g',
                                      editValue: _editSelection,
                                      editAll: () => _toggleEditAll(),
                                      currFood: currFood,
                                      currFoodVals: _currFoodVals!,
                                      scaleFunc: _scaleUpFoods),
                                  ModifiableFoodItemData(
                                      lbl: "Fats",
                                      qty: null,
                                      amt: _currFoodVals![5],
                                      uts: 'g',
                                      editValue: _editSelection,
                                      editAll: () => _toggleEditAll(),
                                      currFood: currFood,
                                      currFoodVals: _currFoodVals!,
                                      scaleFunc: _scaleUpFoods),
                                  ModifiableFoodItemData(
                                      lbl: "Protein",
                                      qty: null,
                                      amt: _currFoodVals![6],
                                      uts: 'g',
                                      editValue: _editSelection,
                                      editAll: () => _toggleEditAll(),
                                      currFood: currFood,
                                      currFoodVals: _currFoodVals!,
                                      scaleFunc: _scaleUpFoods),
                                  ModifiableFoodItemData(
                                      lbl: "Sugar",
                                      qty: null,
                                      amt: _currFoodVals![7],
                                      uts: 'g',
                                      editValue: _editSelection,
                                      editAll: () => _toggleEditAll(),
                                      currFood: currFood,
                                      currFoodVals: _currFoodVals!,
                                      scaleFunc: _scaleUpFoods),
                                ])
                              : SizedBox.shrink(),
                          GraphFoodItemDataDisplay(
                              currFoodVals: _currFoodVals!),
                          SizedBox(height: 150),
                        ]),
                      ),
                    )
                  ],
                )
        ),
        (_editing && _needSaveDecision && !_autoSaveApply && _isSaved
              ? Stack(children: [
                  EHFloatingButton(
                    top: pageHeight * .9 - 75,
                    left: pageWidth * .5,
                    color: ColorTheme["tertiaryBG"],
                    height: 50,
                    width: 100,
                    onTap: () => _handleApplySave(),
                    borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(15)),
                    child:  Center(
                              child: Text("✓ Apply to Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorTheme["textPrimary"])))),
                  EHFloatingButton(
                    top: pageHeight * .9 - 75,
                    left: pageWidth * .5 - 100,
                    height: 50,
                    width: 100,
                    color: ColorTheme["secondaryBG"],
                    onTap: () => _handleApplyNew(),
                    borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(15)),
                    child: Center(
                              child: Text("+ Apply as New",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorTheme["textPrimary"]))
                    )
                  ),
                ])
              : EHFloatingButton(
                    top: pageHeight * .9 - 75,
                    left: pageWidth * .5 - 100 / 2,
                    onTap: _editing
                      ? (_autoSaveApply && _isSaved
                          ? () => _handleApplySave()
                          : () => _toggleEditAll())
                      : () => _addFood(),
                      height: 50,
                      width: 100,
                      borderRadiusValue: 15,
                      color: _editing
                              ? ColorTheme["secondaryBG"]
                              : ColorTheme["tertiaryBG"],
                      child: _editing
                          ? Center(
                              child: Text(
                                  _autoSaveApply && _isSaved
                                      ? "✓ Apply to Save"
                                      : "✓ Apply",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorTheme["textPrimary"])))
                          : Center(
                              child: Text("+ Add",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorTheme["textPrimary"])),
                            ),
                    )
                ),
        enlargedPic,
        
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
  final Function editAll; // Clarified signature for editSpecific
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
    required this.editAll,
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
    "",
    "",
    "",
    "Servings",
    "",
    "Meal",
    "Time",
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
    "density",
    "",
    "",
    "",
    "servings",
    "",
    "meal",
    "time",
  ];
  static const weightUnitsPerGram = {
    'g': 1.0,
    'kg': 1000.0,
    'oz': 28.3495,
    'lb': 453.592,
    'mg': .001,
    'mcg': .000001
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
    'mcg': ['mcg', 'microgram', 'mcgs', 'micrograms'],
  };

  static const densityPresets = {
    "Cotton Candy": 0.05,
    "Corn Flakes": .20,
    "White Bread": .25,
    "Iceburg Lettuce": .90,
    "Vegetable Oil": .92,
    "Butter": .96,
    "Water": 1.00,
    "Whole Milk": 1.03,
    "Chicken Breast": 1.06,
    "Honey": 1.42,
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
  bool editingField = false;
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _allFocusNode = FocusNode();
  bool justTapped = false;

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
    scaleOtherUnits = widget.lbl == "Serving Size" || widget.lbl == "Servings";
    _currFoodVals = widget.currFoodVals;
    _scaleUpFoods = widget.scaleFunc;
    _allFocusNode.addListener(_onAllFocusChange);
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

  void _onAllFocusChange() {}

  void _showCupertinoPicker(BuildContext context, List<String> items, int initialItem, Function(int) onSelectedItemChanged) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 400,
        color: ColorTheme["primaryBG"],
        child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                onSelectedItemChanged: onSelectedItemChanged,
                children: List<Widget>.generate(items.length, (int index) {
                  return Center(child: Text(items[index], style: TextStyle(color: ColorTheme["textPrimary"])));
                }),
            ),
      )
    );
  }

  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // This margin is to prevent the pop-up from being covered by the keyboard
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Use a standard Cupertino color.
        color: ColorTheme["primaryBG"],
        // Use SafeArea to respect notches and system areas
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
// Helper to get the initial value for the TextField based on the label
  String _getInitialValueForEditor() {
    // Use the current 'amount' state, which is synchronized with the slider
    if (amount == null) return "";
    return (amount! * (attributeID == "calories" && units! == "kJ" ? 4.184 : 1))
        .toStringAsFixed(1); // Format to one decimal for consistency
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
    setState(() {
      if (units != startingUnits) {
        _changeUnits(normalizeUnit(startingUnits!));
        units = startingUnits;
        _currFoodVals[currEditIndex!] = "$amount $units";
      }

      if (attributeID == "serving_size") {
        if (scaleOtherUnits == true) _scaleUpFoods!(startingAmount! / amount!);
        _currFoodVals[currEditIndex!] = "$startingAmount $units";
      } else if (attributeID == "servings") {
        if (scaleOtherUnits == true) _scaleUpFoods!(startingAmount! / amount!);
        _currFoodVals[currEditIndex!] = startingAmount;
      } else if (attributeID == "calories") {
        if (units == "kJ") {
          _currFoodVals[currEditIndex!] = startingAmount! / 4.184;
        }
      } else if (attributeID == "density") {
        _scaleUpFoods!(startingAmount! / amount!);
      } else {
        _currFoodVals[currEditIndex!] = startingAmount;
      }
      amount = startingAmount;
      _isCurrentlyEditing = false;
      _textController.text = startingAmount!.toStringAsFixed(1);
      currZeroScale = startingAmount;
    });
  }

// Debounce timer for textbox changes
  Timer? _debounce;

  void _handleTextboxChange(String str) {
    str = str.replaceAll(',', '.');
    _isCurrentlyEditing = true;

    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        try {
          num newValue = double.parse(str);
          if (newValue == 0 &&
              (attributeID == "serving_size" || attributeID == "servings")) {
            newValue = .00000000000017;
          }
          if (attributeID == "serving_size") {
            if (scaleOtherUnits == true) _scaleUpFoods!(newValue / amount!);
            _currFoodVals[currEditIndex!] = "$newValue $units";
          } else if (attributeID == 'servings') {
            if (scaleOtherUnits == true) _scaleUpFoods!(newValue / amount!);
            _currFoodVals[currEditIndex!] = newValue;
          } else if (attributeID == "density") {
            _scaleUpFoods!(newValue / amount!);
            _currFoodVals[currEditIndex!] = newValue;
          } else {
            _currFoodVals[currEditIndex!] = newValue /
                (attributeID == "calories" && units! == "kJ" ? 4.184 : 1);
          }
          amount = newValue;
        } catch (e) {
          return;
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose(); // Dispose of the controller
    _textFocusNode.dispose();
    _allFocusNode.removeListener(_onAllFocusChange);
    _allFocusNode.dispose();
    super.dispose();
  }

  void _setZeroScale() {
    setState(() {
      if (amount != null) {
        amount! > 0
            ? currZeroScale = amount! *
                (attributeID == "calories" && units! == "kJ" ? 4.184 : 1)
            : null;
      }
    });
  }

  String normalizeUnit(String value) {
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
        if (units != newValue) {
          units = newValue;
          currZeroScale = currZeroScale! *
              (attributeID == "calories" && units! == "kJ" ? 4.184 : 1 / 4.184);
          
        }
      });
      return;
    }

    bool oldIsWeightUnit = weightUnitsPerGram[normalizeUnit(units!)] != null;
    bool newIsWeightUnit = weightUnitsPerGram[newValue] != null;
    setState(() {
      if (oldIsWeightUnit != newIsWeightUnit) {
        if (oldIsWeightUnit) {
          _currFoodVals[11] = true;
        } else {
          _currFoodVals[11] = false;
        }
      }
      num? oldScale = oldIsWeightUnit
          ? weightUnitsPerGram[normalizeUnit(units!)]
          : volumeUnitsPerMl[normalizeUnit(units!)];
      num? newScale = newIsWeightUnit
          ? weightUnitsPerGram[newValue]
          : volumeUnitsPerMl[newValue];
      num densityFactor =
          _currFoodVals[11] && oldIsWeightUnit ? 1 / _currFoodVals[8] : 1.0;
      num scaleFactor = newIsWeightUnit
          ? (1 / newScale!)
          : (oldScale! / newScale!) * densityFactor;
      startingAmount = newIsWeightUnit
          ? scaleFactor * _currFoodVals[2]
          : startingAmount! * scaleFactor;
      currZeroScale = currZeroScale! *
          (newIsWeightUnit ? oldScale! * scaleFactor : scaleFactor);
      amount = newIsWeightUnit
          ? _currFoodVals[2] * scaleFactor
          : amount! * scaleFactor;
      units = newValue;
      _currFoodVals[currEditIndex!] = "$amount $units";
      _scaleUpFoods!(1);
    });
  }

  List seperateAmtAndUnits(String str) {
    String units = str
        .replaceFirst(RegExp(r'[\d.,+eE+-]+'), ' ')
        .replaceAll(RegExp(r'[\s]+'), ' ')
        .trim()
        .toLowerCase();
    String doublePart = str.replaceAll(RegExp(r'[^\d.,+eE+-]+'), ' ').trim();
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
    amount = amount ?? widget.amt;

    !currEditing ? _setZeroScale() : null;
    if ((amount == null && quantity != null) ||
        (units == null && quantity != null)) {
      List tempList;
      quantity == "quantity not specified"
          ? tempList = seperateAmtAndUnits("${_currFoodVals[2]}g")
          : tempList = seperateAmtAndUnits(quantity);
      String normalUnit = normalizeUnit(tempList[1]);
      num? mlScale = volumeUnitsPerMl[normalUnit];

      if (!_currFoodVals[11] && mlScale != null) {
        _currFoodVals[8] = _currFoodVals[2] / (tempList[0] * mlScale);
      }
      return ModifiableFoodItemData(
          lbl: label,
          qty: null,
          amt: tempList[0],
          uts: tempList[1],
          editValue: widget.editValue,
          editAll: widget.editAll,
          currFood: widget.currFood,
          currFoodVals: _currFoodVals,
          scaleFunc: widget.scaleFunc);
    }
    if (currZeroScale != null && currZeroScale! <= .00001) {
      if (attributeID == "serving_size") {
        currZeroScale = seperateAmtAndUnits(widget.currFood[attributeID!])[0];
      } else if (attributeID != "meal" && attributeID != "time") {
        currZeroScale = widget.currFood[attributeID!];
      }
    }
    if (!_isCurrentlyEditing) {
      if (attributeID != "serving_size" && attributeID != "servings") {
        _textController.text = (amount! *
                (attributeID == "calories" && units! == "kJ" ? 4.184 : 1))
            .toStringAsFixed(1);
      } else {
        _textController.text = (amount! *
                (attributeID == "calories" && units! == "kJ" ? 4.184 : 1))
            .toStringAsFixed(1);
      }
    }
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

    Widget attributeDisplayDefault = Row(children: [
      SizedBox(width: 34),
      Expanded(
        child: Text("$label:",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: ColorTheme["textPrimary"])),
      ),
      attributeID! != "meal" && attributeID != "time"
          ? GestureDetector(
              onDoubleTap: () {
                widget.editAll();
                setState(() {
                  _textFocusNode.requestFocus();
                  editingField = true;
                });
              },
              child: SizedBox(
                width: 150,
                child: Text(
                    "${(((_currFoodVals[11] && attributeID != "serving_size" && attributeID != "density" && attributeID != "servings" ? amount! * _currFoodVals[8] : amount!) * (attributeID == "calories" && units! == "kJ" ? 4.184 : 1)).toStringAsFixed(1))} ${units!}",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 12, color: ColorTheme["textPrimary"])),
              ),
            )
          : attributeID! == "meal"
              ?           
                Container(
                  alignment: Alignment.centerRight,
                  child:           
                  GestureDetector(
                    child: 
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text(
                              _currFoodVals[14] != "" ? _currFoodVals[14] : "No Meal",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.clip,
                                color: ColorTheme["textPrimary"])),
                            Icon(Icons.arrow_drop_down, color: ColorTheme["textPrimary"], size: 24),
                          ],
                        ),
                      ),
                      onTap: () {
                      final List<String> mealOptions = ["No Meal", "Breakfast", "Lunch", "Dinner", "Snack"];
                      int initialIndex = mealOptions.indexOf(_currFoodVals[14] != "" ? _currFoodVals[14] : "No Meal");
                      _showCupertinoPicker(context, mealOptions, initialIndex, (int newIndex) {
                        setState(() {
                          _currFoodVals[14] = mealOptions[newIndex] != "No Meal" ? mealOptions[newIndex] : "";
                        });
                      });
                    },
                  )
                )
              : 
            Row(
              children: [
                // Date & Time Selector Button (Combined for a better UX)
                GestureDetector(
                  onTap: () {
                    _showDialog(
                      context,
                      CupertinoTheme(
                        data: CupertinoThemeData(textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(color: Colors.white, fontSize: 21),
                        )),
                        child:
                          CupertinoDatePicker(
                            initialDateTime: DateTime.fromMillisecondsSinceEpoch(_currFoodVals[15] * 1000),
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() {
                                final utcTime = newDate.toUtc();
                                _currFoodVals[15] = utcTime.millisecondsSinceEpoch ~/ 1000;
                              });
                            },
                          ),),
                      );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorTheme["textPrimary"]!),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 16, color: ColorTheme["textPrimary"]),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_currFoodVals[15] * 1000)),
                          style: TextStyle(fontSize: 12, color: ColorTheme["textPrimary"]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      SizedBox(width: 34),
    ]);

    Widget attributeDisplayEdit = Column(
      children: [
        attributeID == "density"
            ? Text("ⓘ Density required for accurate measurements",
                style: TextStyle(
                    fontSize: 8,
                    color: ColorTheme["textPrimary"]!.withAlpha(175)))
            : SizedBox.shrink(),
        Row(children: [
          Icon(
            attributeID != "meal" && attributeID != "time" && editingField
                ? Icons.arrow_drop_down
                : Icons.arrow_right,
            color: attributeID != "meal" && attributeID != "time"
                ? ColorTheme["textPrimary"]
                : ColorTheme["transparent"],
            size: 24,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label:",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: ColorTheme["textPrimary"]),
              textAlign: TextAlign.start,
            ),
          ),
          attributeID != "meal" && attributeID != "time"
              ? SizedBox(
                  width: 50,
                  child: TextField(
                    cursorColor: ColorTheme["textPrimary"],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      isDense: true,
                    ),
                    onTap: () => setState(() => editingField = true),
                    focusNode: _textFocusNode,
                    controller: _textController,
                    onChanged: _handleTextboxChange,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        color: ColorTheme["textPrimary"]),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]*'))
                    ],
                  ),
                )
              : attributeID! == "meal"
                  ? 
                    GestureDetector(
                      child: 
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                _currFoodVals[14] != "" ? _currFoodVals[14] : "No Meal",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.clip,
                                  color: ColorTheme["textPrimary"])),
                              Icon(Icons.arrow_drop_down, color: ColorTheme["textPrimary"], size: 24),
                            ],
                          ),
                        ),
                        onTap: () {
                        final List<String> mealOptions = ["No Meal", "Breakfast", "Lunch", "Dinner", "Snack"];
                        int initialIndex = mealOptions.indexOf(_currFoodVals[14] != "" ? _currFoodVals[14] : "No Meal");
                        _showCupertinoPicker(context, mealOptions, initialIndex, (int newIndex) {
                          setState(() {
                            _currFoodVals[14] = mealOptions[newIndex] != "No Meal" ? mealOptions[newIndex] : "";
                          });
                        });
                      },
                    )
                  : // This Row can be placed in the `else` part of your ternary operator
                  Row(
                    children: [
                      // Date & Time Selector Button (Combined for a better UX)
                      GestureDetector(
                        onTap: () {
                          _showDialog(
                            context,
                            CupertinoDatePicker(
                              initialDateTime: DateTime.fromMillisecondsSinceEpoch(_currFoodVals[15] * 1000),
                              mode: CupertinoDatePickerMode.dateAndTime,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  final utcTime = newDate.toUtc();
                                  _currFoodVals[15] = utcTime.millisecondsSinceEpoch ~/ 1000;
                                });
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorTheme["textPrimary"]!),
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, size: 16, color: ColorTheme["textPrimary"]),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_currFoodVals[15] * 1000)),
                                style: TextStyle(fontSize: 12, color: ColorTheme["textPrimary"]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          SizedBox(width: 10),
          Container(
            child: "calories" == attributeID
                ? 
                GestureDetector(
                  child: 
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(
                            units!,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.clip,
                              color: ColorTheme["textPrimary"])),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_drop_down, color: ColorTheme["textPrimary"], size: 24),
                        ],
                      ),
                    ),
                    onTap: () {
                      final calorieOptions = ["kcal", "kJ"];
                      final initialIndex = calorieOptions.indexOf(units!);
                      
                      _showCupertinoPicker(context, calorieOptions, initialIndex, (int newIndex) {
                        _changeUnits(calorieOptions[newIndex]);
                        _textController.text = (amount! *
                          (attributeID == "calories" && units! == "kJ" ? 4.184 : 1))
                          .toStringAsFixed(1);
                      });
                    },
                )
              : normalizedUnit != "" && "serving_size" == attributeID
                    ? 
                  GestureDetector(
                    child: 
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text(
                              normalizedUnit,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.clip,
                                color: ColorTheme["textPrimary"])),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_drop_down, color: ColorTheme["textPrimary"], size: 24),
                          ],
                        ),
                      ),
                      onTap: () {
                        final unitOptions = unitNormalization.keys.toList();
                        final initialIndex = unitOptions.indexOf(normalizedUnit);

                        _showCupertinoPicker(context, unitOptions, initialIndex, (int newIndex) {
                          _changeUnits(unitOptions[newIndex]);
                        });
                      },
                  ): SizedBox(
                    width: attributeID != "meal" ? attributeID != "time" ? null: 10: 0,
                    child: Text(units!,
                          style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.clip,
                              color: ColorTheme["textPrimary"])),
                  ),
          ),
          GestureDetector(
            onTap: attributeID != "meal" && attributeID != "time"
                ? _resetToDefaultValue
                : () => attributeID == "meal"
                    ? {
                        setState(() {
                          _currFoodVals[14] = widget.currFood.meal;
                        })
                      }
                    : {
                        setState(() {
                          _currFoodVals[15] = DateTime.now()
                              .toUtc()
                              .difference(DateTime.utc(1970, 1, 1))
                              .inSeconds;
                        })
                      },
            child: Icon(Icons.undo,
                color: attributeID == "meal" ||
                        attributeID == "time" ||
                        editingField
                    ? ColorTheme["textPrimary"]
                    : ColorTheme["transparent"],
                size: 24),
          ),
        ]),
        attributeID == "density" && editingField
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Expanded(child: SizedBox.shrink()),
                    Text("Preset: ",
                        style: TextStyle(
                            fontSize: 12,
                            color: ColorTheme["textPrimary"]!.withAlpha(175))),
                    SizedBox(width: 10),
                    GestureDetector(
                      child: 
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                normalizedUnit,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.clip,
                                  color: ColorTheme["textPrimary"])),
                              Icon(Icons.arrow_drop_down, color: ColorTheme["textPrimary"], size: 24),
                            ],
                          ),
                        ),
                        onTap: () {
                          final presetOptions = ["Choose Preset"] + densityPresets.keys.toList();
                          final String currentValue = presetOptions.firstWhere((element) => densityPresets[element] == _currFoodVals[8], orElse: () => "Choose Preset");
                          final initialIndex = presetOptions.indexOf(currentValue);

                          _showCupertinoPicker(context, presetOptions, initialIndex, (int newIndex) {
                            final String str = presetOptions[newIndex];
                            setState(() {
                              if (str != "Choose Preset") {
                                _scaleUpFoods!(densityPresets[str]! / amount!);
                                _currFoodVals[8] = densityPresets[str];
                                amount = _currFoodVals[8];
                                _textController.text = _currFoodVals[8].toStringAsFixed(2);
                              } else {
                                _currFoodVals[8] = _currFoodVals[8] + .00000000000017;
                                amount = _currFoodVals[8];
                              }
                            });
                          });
                        },
                    )                 
                  ],
                ),
              )
            : SizedBox.shrink(),
        attributeID != "meal" && attributeID != "time" && editingField
            ? Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    // Optional: Customize slider appearance
                    activeTrackColor: ColorTheme["primaryLight"],
                    inactiveTrackColor: ColorTheme["grey"],
                    thumbColor: ColorTheme["primary"],
                    overlayColor: ColorTheme["transparent"],
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 0.0),
                    trackHeight: 2.0,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                    onChangeEnd: (double num) => setState(() {
                      currZeroScale! < .1
                          ? currZeroScale = .1
                          : num > currZeroScale! * 1.9
                              ? currZeroScale = currZeroScale! * 2
                              : num < currZeroScale! / 4 && num != 0
                                  ? currZeroScale = num
                                  : null;
                    }),
                    value: ((amount == .00000000000017 ? 0.0 : amount ?? 0.0)
                                .toDouble() *
                            (attributeID == "calories" && units! == "kJ"
                                ? 4.184
                                : 1))
                        .clamp(
                            0.0,
                            (currZeroScale! >= 0
                                ? currZeroScale!.toDouble() * 2.0
                                : 0.0)),
                    min: 0.0,
                    max: (currZeroScale == 0 || currZeroScale == null)
                        ? 100.0
                        : (currZeroScale! < 0
                            ? 0.0
                            : currZeroScale!.toDouble() * 2.0),
                    divisions: 1000,
                    label: (amount! *
                            (attributeID == "calories" && units! == "kJ"
                                ? 4.184
                                : 1))
                        .toStringAsFixed(1),
                    onChanged: (double newValue) {
                      setState(() {
                        if ((newValue == 0 &&
                            (attributeID == "serving_size" ||
                                attributeID == "servings"))) {
                          newValue = .00000000000017;
                        }
                        _textController.text = (newValue *
                                (attributeID == "calories" && units! == "kJ"
                                    ? 4.184
                                    : 1))
                            .toStringAsFixed(1);
                        num oldAmount = amount!;
                        amount = newValue /
                            (attributeID == "calories" && units! == "kJ"
                                ? 4.184
                                : 1);
                        if (attributeID == "serving_size") {
                          if (scaleOtherUnits == true) {
                            _scaleUpFoods!(newValue / oldAmount);
                          }
                          _currFoodVals[currEditIndex!] = "$newValue $units";
                        } else if (attributeID == 'servings') {
                          if (scaleOtherUnits == true) {
                            _scaleUpFoods!(newValue / oldAmount);
                            _currFoodVals[currEditIndex!] = amount;
                          }
                        } else if (attributeID == "density") {
                          _scaleUpFoods!(newValue / oldAmount);
                          _currFoodVals[currEditIndex!] = amount;
                        } else {
                          _currFoodVals[currEditIndex!] = amount;
                        }
                      });
                    },
                  ),
                ),
            )
            : SizedBox.shrink(),
        (attributeID == "serving_size" || attributeID == "servings") &&
                editingField
            ? Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      // 2. Set the splash color and highlight color to transparent
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent, // Also disable the hover effect on web/desktop
                    ),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: scaleOtherUnits,
                      onChanged: (bool? value) {
                        setState(() {
                          scaleOtherUnits = value;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          scaleOtherUnits = !(scaleOtherUnits ?? false);
                        });
                      },
                      child: Text("Scale other attributes",
                          style: TextStyle(
                              fontSize: 12, color: ColorTheme["textPrimary"]),
                          overflow: TextOverflow.ellipsis)),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
    if (!currEditing) {
      setState(() => editingField = false);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorTheme["textPrimary"]!.withAlpha(50)),
        ),
        color: ["calories", "carbs", "fats", "protein", "sugar"]
                .contains(attributeID)
            ? ColorTheme["primaryBGDark"]
            : ColorTheme["transparent"],
      ),
      child: currEditing
          ? GestureDetector(
              onTap: () {
                setState(() {
                  editingField = !editingField;
                });
              },
              child: Focus(
                  focusNode: _allFocusNode,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: ColorTheme["transparent"],
                      child: attributeDisplayEdit)))
          : GestureDetector(
              onDoubleTap: () {
                widget.editAll();
                setState(() => editingField = true);
              },
              child: Container(
                  padding: EdgeInsets.all(10), child: attributeDisplayDefault)),
    );
  }
}

class GraphFoodItemDataDisplay extends StatefulWidget {
  final List currFoodVals;
  final List dailyValues;

  const GraphFoodItemDataDisplay({
    super.key,
    required this.currFoodVals,
    this.dailyValues = const [
      "FDA 2000-Calorie Guide",
      2000.0,
      275.0,
      78.0,
      50.0,
      100.0
    ],
  });

  @override
  State<GraphFoodItemDataDisplay> createState() =>
      _GraphFoodItemDataDisplayState();
}

const Map<String, Color> kNutrientColors = {
  'Calories': Color.fromARGB(255, 76, 164, 59),
  'Carbs': Color.fromARGB(255, 170, 149, 64), // Placeholder Green
  'Fats': Color.fromARGB(255, 154, 77, 77), // Placeholder Yellow
  'Protein': Color.fromARGB(255, 131, 76, 163), // Placeholder Orange
  'Sugar': Color.fromARGB(255, 73, 123, 156), // Placeholder Light Blue
};

class _GraphFoodItemDataDisplayState extends State<GraphFoodItemDataDisplay> {
  late List currFoodVals;

  @override
  void initState() {
    super.initState();
    currFoodVals = widget.currFoodVals;
  }

  @override
  void didUpdateWidget(covariant GraphFoodItemDataDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currFoodVals != oldWidget.currFoodVals) {
      setState(() {
        currFoodVals = widget.currFoodVals;
      });
    }
  }

  double _calculateGraphScaleMax(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 100.0;
    double maxPercent = 0.0;
    for (var item in data) {
      final value = item['value'];
      final dailyValue = item['dailyValue'];
      if (dailyValue > 0) {
        maxPercent = max(maxPercent, (value / dailyValue) * 100.0);
      }
    }
    if (maxPercent == 0) return 10.0;

    // For values over 100, round up to the nearest 25 or 50 for clarity
    return (maxPercent / 10).ceil() * 10.0;
  }

  Widget _buildAxis(double scaleMax) {
    return Column(
      children: [
        Container(
          height: 1,
          color: ColorTheme["lightGrey"],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text('0%',
                    style: TextStyle(
                        fontSize: 10,
                        color: ColorTheme["textPrimary"],
                        overflow: TextOverflow.clip))),
            if (scaleMax >= 50)
              Flexible(
                child: Text('${(scaleMax * 0.5).toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 10,
                        color: ColorTheme["textPrimary"],
                        overflow: TextOverflow.clip)),
              ),
            Flexible(
              child: Text('${scaleMax.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 10,
                      color: ColorTheme["textPrimary"],
                      overflow: TextOverflow.clip)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> nutrientData = [
      {
        'label': 'Calories',
        'value': currFoodVals[3],
        'dailyValue': widget.dailyValues[1],
        'unit': 'kcal'
      },
      {
        'label': 'Carbs',
        'value': currFoodVals[4],
        'dailyValue': widget.dailyValues[2],
        'unit': 'g'
      },
      {
        'label': 'Fats',
        'value': currFoodVals[5],
        'dailyValue': widget.dailyValues[3],
        'unit': 'g'
      },
      {
        'label': 'Protein',
        'value': currFoodVals[6],
        'dailyValue': widget.dailyValues[4],
        'unit': 'g'
      },
      {
        'label': 'Sugar',
        'value': currFoodVals[7],
        'dailyValue': widget.dailyValues[5],
        'unit': 'g'
      },
    ];

    final double graphScaleMax = _calculateGraphScaleMax(nutrientData);

    final String detailsString =
        "(Carbs: ${widget.dailyValues[2].toInt()}g, Fats: ${widget.dailyValues[3].toInt()}g, Protein: ${widget.dailyValues[4].toInt()}g, Sugar: ${widget.dailyValues[5].toInt()}g)";

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorTheme["textPrimary"]!.withAlpha(50)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Main section for aligned key/bar rows ---
            Column(
              children: nutrientData.map((data) {
                final double percentage = data['dailyValue'] > 0
                    ? (data['value'] / data['dailyValue']) * 100.0
                    : 0.0;
                final String valueText = '${percentage.toStringAsFixed(1)}%';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      // --- Key Element ---
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: kNutrientColors[data['label']],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${data['label']} (${data['value'].toStringAsFixed(0)}${data['unit']})',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: ColorTheme["textPrimary"]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing between key and bar
                      // --- Graph Bar Element ---
                      Flexible(
                        flex: 3,
                        // ***** SOLUTION: Place LayoutBuilder here *****
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Now, constraints.maxWidth is the correct width for the bar
                            final barWidth =
                                (percentage / graphScaleMax).clamp(0, 1) *
                                    constraints.maxWidth;

                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: ColorTheme["darkGrey"],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  height: 22,
                                  width: barWidth,
                                  decoration: BoxDecoration(
                                    color: kNutrientColors[data['label']],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  child: Text(
                                    valueText,
                                    style: TextStyle(
                                      color: ColorTheme["textPrimary"],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 5),

            // --- Axis and Footer Labels ---
            Row(
              children: [
                Flexible(flex: 2, child: Container()), // Spacer to align axis
                SizedBox(width: 8),
                Expanded(flex: 3, child: _buildAxis(graphScaleMax)),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Percent of ${widget.dailyValues[0]}",
              style: TextStyle(fontSize: 12, color: ColorTheme["textPrimary"]),
            ),
            SizedBox(height: 4),
            Text(
              detailsString,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: ColorTheme["textPrimary"]!.withAlpha(179)),
            ),
          ],
        ),
      ),
    );
  }
}
