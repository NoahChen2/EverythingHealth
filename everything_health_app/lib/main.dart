import 'dart:io' show File;

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database
  //await deleteIsarDatabase();
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [SavedFoodSchema, HistoryFoodSchema], // Pass your collection schema here
    directory: dir.path,
  );
  
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