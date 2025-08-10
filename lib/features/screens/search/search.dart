import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Object? extra;
  const Search({super.key, this.extra});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Screen'),
    );
  }
}