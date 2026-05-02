import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged; // Callback function to handle changes in the search input
  
  const SearchBarWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField( // Text field for search input
      onChanged: onChanged, // Call the callback function when the text changes
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