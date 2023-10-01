import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/navbar.dart';
import 'package:news_app/newsListCreator.dart';
import 'package:news_app/newsCards.dart';
import 'package:news_app/sources.dart';

void main() {
  runApp(const MyApp());
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
      home: HomePage(title: 'News App'),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.title});

  final String title;

  final List<NewsData> myNewsDataList = [
    NewsData(
      title: "Sample Title",
      date: "2023-10-01",
      description: "Sample Description",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Sources(),
          Expanded(
            child: Center(
                child: NewsCards(
              newsDataList: myNewsDataList,
            )),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
