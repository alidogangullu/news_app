import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/navbar.dart';
import 'package:news_app/newsListCreator.dart';
import 'package:news_app/newsCards.dart';
import 'package:news_app/sources.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF111111),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF111111),
      primary: const Color(0xFF111111),
      secondary: const Color(0xFF111111),
    ),
    textTheme: GoogleFonts.outfitTextTheme(),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      color: const Color(0xFF111111),
      titleTextStyle: GoogleFonts.outfit(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      // other options
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkThemeData,
      home: const HomePage(title: 'News App'),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Source> sources = ref.read(sourcesProvider);
    final activatedSources = sources.where((source) => source.isActivated);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[700]!,
                  width: 0.5,
                ),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditSourcesPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.widgets_outlined,
                    color: Colors.grey[200],
                    size: 28,
                  )),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SourcesTab(),
          Expanded(
            //todo change news cards after activate or deactivate sources
            child: FutureBuilder(
              future: fetchRssDataFromSources(activatedSources),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: NewsCards(newsDataList: snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator(color: Colors.white,));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
