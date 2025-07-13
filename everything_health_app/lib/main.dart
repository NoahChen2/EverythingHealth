import 'dart:io' show File, FileSystemEntity;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // Import MyAppState
import 'screens/my_home_page.dart'; // Import MyHomePage
import 'models/history_foods.dart';
import 'models/saved_foods.dart';

import 'package:isar/isar.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
late Isar isar; // A global Isar instance


Future<void> deleteIsarDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  // Assumes default Isar instance. If you named it, use that name.
  final isarFile = File('${dir.path}/default.isar'); 

  if (await isarFile.exists()) {
    print('Deleting existing Isar database at: ${isarFile.path}');
    await isarFile.delete();
  } else {
    print('No Isar database found to delete.');
  }
}

Future<void> deleteUnusedFiles() async {
  print("--- Running Cleanup: Deleting unused images... ---");
  try {
    // 1. Get the directory where your private files are stored
    final dir = await getApplicationDocumentsDirectory();

    // 2. Get a list of all files in that directory
    final List<FileSystemEntity> entities = await dir.list().toList();

    // 3. Loop through each file
    for (FileSystemEntity entity in entities) {
      // Make sure we're only checking image files
      if (entity is File && (entity.path.endsWith('.jpg') || entity.path.endsWith('.png'))) {
        
        final String path = entity.path;

        // 4. Use your helper functions to check if the file is in either database
        final bool isInSaved = await imgInIsarSavedFoods(path);
        final bool isInHistory = await imgInIsarHistoryFoods(path);

        // 5. If it's in neither, delete it
        if (!isInSaved && !isInHistory) {
          print('DELETING unused file: $path');
          await entity.delete();
        }
      }
    }
  } catch (e) {
    print("An error occurred during file cleanup: $e");
  }
  print("--- Cleanup complete. ---");
}

Future<bool> imgInIsarSavedFoods(String path) async {
  return ((await isar.savedFoods.filter().img_urlEqualTo(path).findFirst()) != null || (await isar.savedFoods.filter().image_small_urlEqualTo(path).findFirst()) != null);
}

Future<bool> imgInIsarHistoryFoods(String path) async {
  return ((await isar.historyFoods.filter().img_urlEqualTo(path).findFirst()) != null || (await isar.historyFoods.filter().image_small_urlEqualTo(path).findFirst()) != null);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database
  //await deleteIsarDatabase();
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [SavedFoodSchema, HistoryFoodSchema], // Pass your collection schema here
    directory: dir.path,
  );
  
  await deleteUnusedFiles();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Everything Health',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const MyHomePage(), // Made MyHomePage const
      ),
    );
  }
}