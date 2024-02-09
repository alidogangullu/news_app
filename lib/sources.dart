import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Source {
  String name;
  String rss;
  bool isActivated;

  Source(this.name, this.rss, this.isActivated);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rss': rss,
      'isActivated': isActivated,
    };
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      json['name'],
      json['rss'],
      json['isActivated'],
    );
  }
}

final sourcesProvider = StateProvider<List<Source>>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).value;
  final sourcesJson = sharedPreferences!.getStringList('sources');
  if (sourcesJson != null) {
    return sourcesJson.map((json) => Source.fromJson(jsonDecode(json))).toList();
  }
  return [
    Source("source1", "https://evrimagaci.org/rss.xml", true),
    Source("source2", "https://www.jpl.nasa.gov/feeds/news/", true),
    Source("source3", "https://www.haberturk.com/rss", true),
  ];
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final saveSourcesProvider = Provider.autoDispose((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).value;
  final sources = ref.watch(sourcesProvider);
  final sourcesJson = sources.map((source) => jsonEncode(source.toJson())).toList();
  sharedPreferences!.setStringList('sources', sourcesJson);
});

final loadSourcesProvider = Provider.autoDispose((ref) async {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).value;
  final sourcesJson = sharedPreferences?.getStringList('sources');
  if (sourcesJson != null) {
    final sources = sourcesJson.map((json) => Source.fromJson(jsonDecode(json))).toList();
    ref.read(sourcesProvider.state).state = sources;
  }
});

class SourcesTab extends ConsumerStatefulWidget {
  const SourcesTab({super.key});

  @override
  ConsumerState<SourcesTab> createState() => _SourcesTabState();
}

class _SourcesTabState extends ConsumerState<SourcesTab> {
  int selectedSourcesIndex = 0;

  @override
  Widget build(BuildContext context) {

    final sourcesMap = ref.watch(sourcesProvider);
    final List<Source> activeSources = sourcesMap.where((source) => source.isActivated).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: activeSources.asMap().entries.map((entry) {
            final index = entry.key;
            final source = entry.value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSourcesIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  source.name,
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
    void showAddSourceDialog() {
      TextEditingController nameController = TextEditingController();
      TextEditingController rssController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Source'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: rssController,
                    decoration: const InputDecoration(
                      labelText: 'RSS Link',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final sourcesList = ref.read(sourcesProvider);
                  final newSource = Source(nameController.text, rssController.text, true);
                  ref.read(sourcesProvider.state).state = [...sourcesList, newSource];
                  ref.read(saveSourcesProvider);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

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
        actions: [
          IconButton(
            onPressed: showAddSourceDialog,
            icon: const Icon(Icons.add_circle_rounded, size: 35, color: Colors.black,),
          ),
        ],
      ),
      body: const EditableSourcesList(),
      extendBody: true,
      /*
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white, fontSize: 21),
            ),
          ),
        ),
      ),
    */
    );
  }
}


class EditableSourcesList extends ConsumerStatefulWidget {
  const EditableSourcesList({super.key});

  @override
  EditableSourcesListState createState() => EditableSourcesListState();
}

class EditableSourcesListState extends ConsumerState<EditableSourcesList> {
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    final sourcesMap = ref.read(sourcesProvider);
    itemCount = sourcesMap.length;
  }

  void toggleCategory(int index, WidgetRef ref) {
    final sourcesList = ref.read(sourcesProvider);

    if (index >= 0 && index < sourcesList.length) {
      final source = sourcesList[index];

      source.isActivated = !source.isActivated;

      ref.read(sourcesProvider.state).state = List.from(sourcesList);
      ref.read(saveSourcesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final sourcesList = ref.watch(sourcesProvider);
        final int itemCount = sourcesList.length;

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final Source source = sourcesList[index];
            final bool isSelected = source.isActivated;

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
                  source.name,
                  style: const TextStyle(fontSize: 19),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: isSelected
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
                        toggleCategory(index, ref);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

