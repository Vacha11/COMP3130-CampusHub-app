import 'package:flutter/material.dart';

class CategoryTabSelector extends StatelessWidget {
  final int selectedIndex; // Index of the currently selected tab
  final Function(int) onTabSelected; // Callback function to handle tab selection

  const CategoryTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row( // Allows horizontal scrolling for the tabs
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:[
        _tabs("All", 0), // Tab for "All" category
        _tabs("Items", 1), // Tab for "Events" category
        _tabs("Services", 2), // Tab for "Clubs" category
      ],
    );
  }

  Widget _tabs(String title, int index) {
    final isSelected = selectedIndex == index; // Check if the current tab is selected
    return GestureDetector(
      onTap:() => onTabSelected(index), // Call the callback function with the index of the selected tab
      child: Column(
        children:[
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.black, // Change text color based on selectio
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Change font weight based on selection
            ),
          ),
          const SizedBox(height: 4), // Spacing between the text and the underline
          Container(
            height: 2,
            width: 20,
            color: isSelected ? Colors.red : Colors.transparent, // Show underline if selected, otherwise
          ),
        ],
      ),
    );
  }
}