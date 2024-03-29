import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'sources.dart';

class NewsData {
  final String title;
  final String date;
  final String description;
  final String author;
  final String link;

  NewsData({
    required this.title,
    required this.date,
    required this.description,
    required this.author,
    required this.link
  });
}

Future<List<NewsData>> fetchRssDataFromSources(Iterable<Source> activatedSources) async {
  final List<NewsData> newsDataList = [];

  final client = http.Client();

  for (final source in activatedSources) {
    try {
      final url = source.rss;
      final response = await client.get(Uri.parse(url));
      final bodyString = response.body;
      final channel = RssFeed.parse(bodyString);

      for (final item in channel.items) {
        var news = NewsData(
          title: item.title ?? 'Unknown',
          date: item.pubDate?.split("+").first.split("-").first ?? 'Unknown',
          description: item.description ?? 'Unknown',
          author: item.author ?? 'Unknown',
          link: item.link ?? 'Unknown',
        );

        if(news.title!='Unknown') {
          newsDataList.add(news);
        }
      }
    } catch (e) {
      //print('Error fetching RSS from ${source.name}: $e');
      continue;
    }
  }

  client.close(); // Close the HTTP client after fetching data

  // Sort the newsDataList by date
  final DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
  newsDataList.sort((a, b) => dateFormat.parse(b.date).compareTo(dateFormat.parse(a.date)));

  return newsDataList;
}
