import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:news_app/newsListCreator.dart';

class NewsCards extends StatelessWidget {
  final List<NewsData> newsDataList;

  NewsCards({super.key, required this.newsDataList});

  final List<Color> predefinedColors = [
    const Color(0xFFFFF2C5),
    const Color(0xFFFFE8E5),
    const Color(0xFFE0F1FF),
    const Color(0xFFE8E1FB),
  ];

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
    return AppinioSwiper(
      cardsCount: newsDataList.length,
      onSwiping: (AppinioSwiperDirection direction) {
        //print(direction.toString());
      },
      cardsBuilder: (BuildContext context, int index) {
        final colorIndex = index % predefinedColors.length;
        final selectedColor = predefinedColors[colorIndex];

        final item = newsDataList[index];

        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(35),
            color: selectedColor,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    truncateTitle(item.title, 35),
                    style: const TextStyle(fontSize: 35),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  item.date,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item.description,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}
