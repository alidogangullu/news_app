import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          //fontWeight: FontWeight.bold
          // other options
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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  @override
  HomePageState createState() => HomePageState();

  final String title;
}

class HomePageState extends State<HomePage> {

  int visit = 0;
  List<TabItem> items = [
    const TabItem(
      icon: Icons.home,
      // title: 'Home',
    ),
    const TabItem(
      icon: Icons.search,
      // title: 'Search',
    ),
    const TabItem(
      icon: Icons.bookmark,
      // title: 'Bookmark',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //extendBody: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Sources(),
          Expanded(
            child: Center(child: NewsCards()),
          ),
          BottomBarFloating(
            items: items,
            backgroundColor: const Color(0xFF252525),
            color: Colors.grey,
            colorSelected: Colors.white,
            indexSelected: visit,
            paddingVertical: 24,
            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ],
      ),
    );
  }
}