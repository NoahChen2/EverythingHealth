import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // Import MyAppState
import 'screens/my_home_page.dart'; // Import MyHomePage
import 'models/history_foods.dart';
import 'models/saved_foods.dart';

import 'package:isar/isar.dart';

late Isar isar; // A global Isar instance


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [SavedFoodSchema, HistoryFoodSchema], // Pass your collection schema here
    directory: dir.path,
  );

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