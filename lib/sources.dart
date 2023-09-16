import 'package:flutter/material.dart';

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  int selectedSourcesIndex = 0;

  final List<String> newsSources = [
    'X Website',
    'Y Website',
    'Z Website',
    'T Website',
    'P Website',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: newsSources.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSourcesIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: index == selectedSourcesIndex ? 22 : 16,
                    color: index == selectedSourcesIndex
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}