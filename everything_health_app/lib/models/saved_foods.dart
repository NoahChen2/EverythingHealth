// ignore_for_file: non_constant_identifier_names

// ignore: depend_on_referenced_packages
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

part 'saved_foods.g.dart';

@collection
class SavedFood {
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
  late double servings;

  // The constructor no longer requires 'id'.
  SavedFood({
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
    this.servings = 1.0,
  });

  factory SavedFood.fromJson(Map<String, dynamic> json) {
    final random = Random();
    
    return SavedFood(
      name: json['name'] ?? json['normalized_name'] ?? "",
      serving_size: json['serving_size'] ?? "100g",
      grams: (json['grams'] ?? 0.0).toDouble(),
      calories: (json['calories'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fats: (json['fats'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
      sugar: (json['sugar'] ?? 0.0).toDouble(),
      normalized_name: json['normalized_name'] ?? SavedFood._normalizeText(json['name'] ?? ""),
      densityRequired: json['densityRequired'] ?? false,
      density: (json['density'] ?? 1.0).toDouble(),
      code: json['code'] ?? -1,
      color: json['color'] ?? HSLColor.fromAHSL(1.0, random.nextInt(360).toDouble(), 0.38, 0.50).toColor().toARGB32(),
      image_small_url: json['image_small_url'] ?? json['image_url'] ?? "",
      img_url: json['image_url'] ?? json['image_small_url'] ?? "",
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
        'servings': servings,
      };
  }
  // Helper function is now static and part of the class
  static String _normalizeText(String text) {
    String normalized = text.toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]+'), '');
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized;
  }
}