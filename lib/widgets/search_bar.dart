import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField( // Text field for search input
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search), // Search icon at the beginning of the text field
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder( // Rounded border for the search bar
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}