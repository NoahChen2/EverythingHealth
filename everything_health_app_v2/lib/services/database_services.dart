// lib/services/database_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:isar/isar.dart';

// Import both of your model files.
// Make sure the paths are correct based on your project structure.
import '../models/saved_foods.dart';
import '../models/history_foods.dart';

// These parsing functions must be top-level (outside of any class)
// so they can be used by Flutter's `compute` function for background processing.

/// Parses a JSON string into a List of SavedFoods objects.
List<SavedFood> _parseSavedFoods(String jsonString) {
  final List<dynamic> parsedJson = jsonDecode(jsonString);
  return parsedJson.map((json) => SavedFood.fromJson(json)).toList();
}

/// Parses a JSON string into a List of HistoryFood objects.
List<HistoryFood> _parseHistoryFoods(String jsonString) {
  final List<dynamic> parsedJson = jsonDecode(jsonString);
  return parsedJson.map((json) => HistoryFood.fromJson(json)).toList();
}


/// A service class to handle all database interactions for the Isar instance.
class DatabaseService {
  final Isar isar;

  // The service is initialized with an active Isar instance.
  DatabaseService(this.isar);

  // --- Methods for the 'SavedFoods' Collection ---

  /// Checks if the SavedFoods collection has already been populated.
  Future<bool> isSavedDataLoaded() async {
    return await isar.savedFoods.count() > 0;
  }

  /// Imports data from 'assets/saved_foods.json' into the SavedFoods collection.
  /// This will only run once if the collection is empty.
  Future<void> importSavedFoodsData() async {
    if (await isSavedDataLoaded()) {
      print("SavedFoods data already loaded. Skipping import.");
      return;
    }
    print("Importing SavedFoods data...");
    final jsonString = await rootBundle.loadString('assets/saved_foods.json');
    final List<SavedFood> foodList = await compute(_parseSavedFoods, jsonString);
    await isar.writeTxn(() async {
      await isar.savedFoods.putAll(foodList);
    });
    print("SavedFoods import complete!");
  }

  /// Adds a single SavedFood item to the database.
  Future<void> addSavedFood(SavedFood food) async {
    await isar.writeTxn(() async {
      await isar.savedFoods.put(food);
    });
  }

  /// Retrieves all SavedFood items from the database.
  Future<List<SavedFood>> getAllSavedFoods() async {
    return await isar.savedFoods.where().findAll();
  }

  // --- Methods for the 'HistoryFood' Collection ---

  /// Checks if the HistoryFood collection has already been populated.
  Future<bool> isHistoryDataLoaded() async {
    return await isar.historyFoods.count() > 0;
  }

  /// Imports data from 'assets/history_foods.json' into the HistoryFood collection.
  /// This will only run once if the collection is empty.
  Future<void> importHistoryData() async {
    // Make sure you have a 'history_foods.json' file in your assets folder.
    if (await isHistoryDataLoaded()) {
      print("HistoryFoods data already loaded. Skipping import.");
      return;
    }
    print("Importing HistoryFoods data...");
    final jsonString = await rootBundle.loadString('assets/history_foods.json');
    final List<HistoryFood> foodList = await compute(_parseHistoryFoods, jsonString);
    await isar.writeTxn(() async {
      await isar.historyFoods.putAll(foodList);
    });
    print("HistoryFoods import complete!");
  }

  /// Adds a single HistoryFood item to the database.
  Future<void> addFoodToHistory(HistoryFood food) async {
    await isar.writeTxn(() async {
      await isar.historyFoods.put(food);
    });
  }

  /// Retrieves all HistoryFood items from the database.
  Future<List<HistoryFood>> getFoodHistory() async {
    // Sort by time descending (most recent first)
    return await isar.historyFoods.where().sortByTimeDesc().findAll();
  }
}