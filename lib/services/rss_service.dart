import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';

import '../models/article.dart';

class RssService {
  // Địa chỉ RSS của VnExpress
  static const String _baseUrl = 'https://vnexpress.net/rss';

  // Danh sách chủ đề
  static const Map<String, String> categories = {
    'Tin mới nhất': 'tin-moi-nhat.rss',
    'Thế giới': 'the-gioi.rss',
    'Kinh doanh': 'kinh-doanh.rss',
    'Khoa học': 'khoa-hoc.rss',
    'Giải trí': 'giai-tri.rss',
    'Thể thao': 'the-thao.rss',
    'Pháp luật': 'phap-luat.rss',
    'Giáo dục': 'giao-duc.rss',
    'Sức khỏe': 'suc-khoe.rss',
    'Đời sống': 'doi-song.rss',
    'Du lịch': 'du-lich.rss',
  };

  // Lấy danh sách bài báo theo chủ đề
  Future<List<Article>> getArticles({
    String category = 'Tin mới nhất',
  }) async {
    final rssPath =
        categories[category] ?? categories['Tin mới nhất']!;

    final url = Uri.parse('$_baseUrl/$rssPath');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể tải tin tức. Mã lỗi: ${response.statusCode}',
      );
    }

    // Chuyển dữ liệu nhận được thành UTF-8
    final xmlString = utf8.decode(response.bodyBytes);

    // Parse XML RSS
    final feed = RssFeed.parse(xmlString);

    final articles = <Article>[];

    for (final item in feed.items ?? []) {
      final rawDescription = item.description ?? '';

      articles.add(
        Article(
          title: item.title?.trim() ?? 'Không có tiêu đề',
          description: _removeHtml(rawDescription),
          link: item.link ?? '',
          imageUrl: _extractImage(rawDescription),
          pubDate: item.pubDate,
          category: category,
        ),
      );
    }

    return articles;
  }

  // Lấy URL hình ảnh nằm trong description của RSS
  String _extractImage(String html) {
    final regex = RegExp(
      r'''<img[^>]+src=["']([^"']+)["']''',
      caseSensitive: false,
    );

    final match = regex.firstMatch(html);

    return match?.group(1) ?? '';
  }

  String _removeHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }
}