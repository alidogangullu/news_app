import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final sourcesMapProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'source1': true,
    'source2': true,
    'source3': true,
  };
});

class SourcesTab extends StatefulWidget {
  const SourcesTab({super.key});

  @override
  State<SourcesTab> createState() => _SourcesTabState();
}

class _SourcesTabState extends State<SourcesTab> {
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

class EditSourcesPage extends ConsumerWidget {
  const EditSourcesPage({super.key});

  @override
    Widget build(BuildContext context, WidgetRef ref) {
    
    final sourcesMap = ref.read(sourcesMapProvider);
    final List<String> newsSources = sourcesMap.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFE8E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE8E5),
        title: const Text(
          'Select Sources',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: EditableSourcesList(
        sources: newsSources,
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35), color: Colors.black),
            child: const Center(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
            )),
      ),
    );
  }
}

class EditableSourcesList extends StatefulWidget {
  const EditableSourcesList({super.key, required this.sources});

  final List<String> sources;

  @override
  EditableSourcesListState createState() => EditableSourcesListState();
}

class EditableSourcesListState extends State<EditableSourcesList> {
  List<bool> selectedCategories = List.empty();

  void toggleCategory(int index) {
    setState(() {
      selectedCategories[index] = !selectedCategories[index];
    });
  }

  @override
  void initState() {
    super.initState();

    selectedCategories = List.filled(widget.sources.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.sources.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(35),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              widget.sources[index],
              style: const TextStyle(fontSize: 17),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: selectedCategories[index]
                      ? Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                            ),
                            const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                  onPressed: () {
                    toggleCategory(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

