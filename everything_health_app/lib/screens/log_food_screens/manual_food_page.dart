import 'package:everything_health_app/services/color_services.dart';
import 'package:everything_health_app/widgets/eh_widgets.dart';

import '../log_food_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualFoodPage extends StatelessWidget {
  final Function addFoodFunc;

  const ManualFoodPage({super.key, required this.addFoodFunc});
  
  String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    // Remove common punctuation. This regex removes most symbols except letters, numbers, and whitespace.
    // You can customize it to be more or less aggressive.
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), ''); 
    // Replace multiple whitespace characters with a single space and trim.
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 90),
      color: ColorTheme["primaryBG"],
      child: Align(
        alignment: Alignment.topCenter,
        child: EHMenuButton(
          onTap: addFoodFunc(FoodItem(
            name: "​New Food ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}",
            serving_size: "100 g",
            grams: 100,
            calories: 0,
            carbs: 0,
            fats: 0,
            protein: 0,
            sugar: 0,
            density: 1,
            densityRequired: false,
            normalized_name: _normalizeText("​New Food ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}"),
            servings: 1,
            code: -1,
          )),
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text("Create New Food", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorTheme["textPrimary"]), overflow: TextOverflow.clip)),
                  SizedBox(width: 20),
                  Icon(Icons.add, color: ColorTheme["textPrimary"]),
                ]),
        ),
      )
    );
  }
}