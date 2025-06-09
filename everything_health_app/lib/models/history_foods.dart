// ignore_for_file: non_constant_identifier_names

// ignore: depend_on_referenced_packages
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// CHANGE 1: Update the part file name
part 'history_foods.g.dart';

@collection
// CHANGE 2: Update the class name
class HistoryFood { 
  final Id id = Isar.autoIncrement; 

  @Index()
  late String normalized_name;
  late String name;
  late String serving_size;
  late double grams;
  late double calories;
  late double carbs;
  late double fats;
  late double protein;
  late double sugar;
  late bool densityRequired;
  late double density;
  @Index()
  late int code;
  late int color;
  late String image_small_url;
  late String img_url;
  late int time;
  late double servings;

  // Constructor name is automatically updated with the class name
  HistoryFood({
    required this.name,
    required this.serving_size,
    required this.grams,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.protein,
    required this.sugar,
    required this.normalized_name,
    required this.color,
    this.densityRequired = false,
    this.density = 1.0,
    this.code = -1,
    this.image_small_url = "",
    this.img_url = "",
    required this.time,
    this.servings = 1,
  });

  // CHANGE 3: Update the factory constructor name
  factory HistoryFood.fromJson(Map<String, dynamic> json) {
    final random = Random();
    
    // CHANGE 4: Update the return type
    return HistoryFood(
      name: json['name'] ?? json['normalized_name'] ?? "",
      serving_size: json['serving_size'] ?? "100g",
      grams: (json['grams'] ?? 0.0).toDouble(),
      calories: (json['calories'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fats: (json['fats'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
      sugar: (json['sugar'] ?? 0.0).toDouble(),
      // CHANGE 5: Update the class name for the static method call
      normalized_name: json['normalized_name'] ?? HistoryFood._normalizeText(json['name'] ?? ""),
      densityRequired: json['densityRequired'] ?? false,
      density: (json['density'] ?? 1.0).toDouble(),
      code: json['code'] ?? -1,
      color: json['color'] ?? HSLColor.fromAHSL(1.0, random.nextInt(360).toDouble(), 0.38, 0.50).toColor(),
      image_small_url: json['image_small_url'] ?? json['image_url'] ?? "",
      img_url: json['image_url'] ?? json['image_small_url'] ?? "",
      time: json['time'] ?? DateTime.now().toUtc().difference(DateTime.utc(1970, 1, 1)).inSeconds ?? 0,
      servings: (json['servings'] ?? 1.0).toDouble(),
    );
  }
  Map<String, dynamic> toJson(){
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
        'color': color, 
        'image_small_url': image_small_url,
        'img_url': img_url,
        'time': time,
        'servings': servings,
      };
  }
  // This helper function is part of the new class now
  static String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), '');
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }
}