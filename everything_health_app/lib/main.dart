import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // Import MyAppState
import 'screens/my_home_page.dart'; // Import MyHomePage

void main() {
  runApp(const MyApp()); // Made MyApp const
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: const MyHomePage(), // Made MyHomePage const
      ),
    );
  }
}