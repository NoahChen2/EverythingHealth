import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container( // Added a container for potential background color or full screen behavior
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.surface, // Example background
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20), // Adjust for status bar
      child: const Column( // Made column const
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Everything Health Dashboard",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 219, 219, 219), // Use theme color
                  decoration: TextDecoration.none, // Default
                )
              )
            ],
          )
        ],
      ),
    );
  }
}