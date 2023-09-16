import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

class NewsCards extends StatelessWidget {
  NewsCards({super.key});

  final List<Color> predefinedColors = [
    const Color(0xFFFFF2C5),
    const Color(0xFFFFE8E5),
    const Color(0xFFE0F1FF),
    const Color(0xFFE8E1FB),
  ];

  Future<List<RssItem>> fetchRssFeedItems() async {
    final client = http.Client();

    final response = await client.get(Uri.parse('https://evrimagaci.org/rss.xml'));
    final bodyString = response.body;
    final channel = RssFeed.parse(bodyString);

    return channel.items;
  }

  String truncateTitle(String title, int maxLength) {
    if (title.length <= maxLength) {
      return title;
    }

    int lastSpaceIndex = title.lastIndexOf(' ', maxLength);
    if (lastSpaceIndex == -1) {
      return "${title.substring(0, maxLength)}...";
    }

    return "${title.substring(0, lastSpaceIndex)}...";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RssItem>>(
      future: fetchRssFeedItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white),);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No news available.', style: TextStyle(color: Colors.white));
        } else {
          return AppinioSwiper(
            cardsCount: snapshot.data!.length,
            onSwiping: (AppinioSwiperDirection direction) {
              //print(direction.toString());
            },
            cardsBuilder: (BuildContext context, int index) {
              final colorIndex = index % predefinedColors.length;
              final selectedColor = predefinedColors[colorIndex];

              final item = snapshot.data![index];

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(35),
                  color: selectedColor,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:Text(truncateTitle(item.title ?? "No Title", 35),
                        style: const TextStyle(fontSize: 35),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(item.pubDate!.split("+").first.split("-").first, style: const TextStyle(fontSize: 12),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(item.description ?? "No Description", style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
