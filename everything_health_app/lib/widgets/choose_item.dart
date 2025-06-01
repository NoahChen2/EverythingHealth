import 'package:everything_health_app/screens/log_food_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import the package

class ChooseFoodItem extends StatefulWidget {
  final FoodItem food;
  final Function close;

  const ChooseFoodItem({super.key, required this.food, required this.close});

  @override
  State<ChooseFoodItem> createState() => _ChooseFoodItemState();
}

class _ChooseFoodItemState extends State<ChooseFoodItem> {
  bool _enlargeImage = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleEnlargeImage() {
    setState(() {
      _enlargeImage = !_enlargeImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pageHeight = screenSize.height;
    final double pageWidth = screenSize.width;

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
                height: pageHeight * .8,
                width: pageWidth,
                child: Image.network(widget.food.img_url, fit: BoxFit.contain,
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
      return Stack(children: [
        GestureDetector(
            onTap: () => widget.close(),
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
                          height: 100,
                          width: pageWidth * .8,
                          decoration: BoxDecoration(color: widget.food.color)),
                      Row(children: [
                        Column(
                          children: [
                            Container(
                                height: 100,
                                width: pageWidth * .5,
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: AutoSizeText(
                                    widget.food.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                            Container(
                                height: 50,
                                width: pageWidth * .5,
                                padding: EdgeInsets.all(5),
                                child: Center(
                                    child: Text(
                                        widget.food.code == -1
                                            ? "Barcode: Unknown Code"
                                            : "Barcode: ${widget.food.code}",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 15))))
                          ],
                        ),
                        Container(
                            height: 150,
                            width: pageWidth * .3,
                            decoration: BoxDecoration(
                                color: widget.food.color,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(pageWidth * .05))),
                            clipBehavior: Clip.antiAlias,
                            child: GestureDetector(
                              onTap: () => _handleEnlargeImage(),
                              child: Center(
                                child: Image.network(
                                    widget.food.image_small_url,
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
                      ])
                    ]),
                    //Temp info displayer
                    Column(children: [
                      Text("Serving Size: ${widget.food.serving_size}",
                          textAlign: TextAlign.left),
                      Text("Weight: ${widget.food.grams}g",
                          textAlign: TextAlign.left),
                      Text("Calories: ${widget.food.calories}kcal",
                          textAlign: TextAlign.left),
                      Text("Carbohydrates: ${widget.food.carbs}g",
                          textAlign: TextAlign.left),
                      Text("Fats: ${widget.food.fats}g",
                          textAlign: TextAlign.left),
                      Text("Protein: ${widget.food.protein}g",
                          textAlign: TextAlign.left),
                      Text("Sugar: ${widget.food.sugar}g",
                          textAlign: TextAlign.left),
                    ])
                  ],
                )),
          ),
          enlargedPic,
          Positioned(
              top: pageHeight * .95 - 30 / 2,
              left: pageWidth * .5 - 30 / 2,
              child: GestureDetector(
                onTap: () { 
                  setState(() => _enlargeImage = false);
                  widget.close();},
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
