import 'package:flutter/material.dart';

// Helper widget to build individual navigation items
Widget buildNavItem({ // Renamed from _buildNavItem and made public
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required Color colorUsed,
}) {
  return Expanded(
    flex: 1,
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: colorUsed, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: colorUsed),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}