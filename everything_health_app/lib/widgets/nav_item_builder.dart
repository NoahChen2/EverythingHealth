import 'package:flutter/material.dart';

// Helper widget to build individual navigation items
Widget buildNavItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required Color colorUsed,
}) {
  return 
     Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque, // Makes the entire Expanded area tappable
        // The Column is now the direct child. It receives width constraints
        // from Expanded and uses its own properties for alignment.
        child: Column(
          // This vertically centers the icon and text within the nav bar's height.
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: const SizedBox(height: 8)
            ),
            Flexible(
              flex: 12,
              child: Icon(icon, color: colorUsed, size: 24)
            ),
            Flexible(
              flex: 2,
              child: const SizedBox(height: 4)
            ),
            Flexible(
              flex: 5,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Handles long text gracefully
                style: TextStyle(
                  fontSize: 10,
                  color: colorUsed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
         ),
     );
}