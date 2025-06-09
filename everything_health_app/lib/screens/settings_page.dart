import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Everything Health Settings",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 110, 110, 110), // Use theme color
                      decoration: TextDecoration.none, // Default
                    ))
          ],
        )
      ],
    );
  }
}
