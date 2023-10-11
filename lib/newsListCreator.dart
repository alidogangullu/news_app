import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;

class NewsData {
  final String title;
  final String date;
  final String description;

  NewsData({
    required this.title,
    required this.date,
    required this.description,
  });
}

Future<List<NewsData>> fetchRssData(String url) async {
  final List<NewsData> newsDataList = [];

  final client = http.Client();

  final response = await client.get(Uri.parse(url));
  final bodyString = response.body;
  final channel = RssFeed.parse(bodyString);

  for (final item in channel.items) {
    var news = NewsData(
        title: item.title!,
        date: item.pubDate!.split("+").first.split("-").first,
        description: item.description!);
    newsDataList.add(news);
  }

  return newsDataList;
}
