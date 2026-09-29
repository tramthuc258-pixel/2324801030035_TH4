import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

// Loại nội dung trong bài báo
enum ArticleContentType {
  paragraph,
  image,
  caption,
}

class ArticleContent {
  final ArticleContentType type;
  final String content;

  const ArticleContent({
    required this.type,
    required this.content,
  });
}

class ArticleService {
  Future<List<ArticleContent>> getArticleContent(
    String url,
  ) async {
    if (url.isEmpty) {
      return [];
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) '
            'AppleWebKit/537.36 '
            'Chrome/120.0 Mobile Safari/537.36',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể tải nội dung bài viết',
      );
    }

    final document = html_parser.parse(
      response.body,
    );


    final articleBody =
        document.querySelector('article.fck_detail') ??
        document.querySelector('.fck_detail');

    if (articleBody == null) {
      return [];
    }

    final contents = <ArticleContent>[];

    for (final element in articleBody.children) {
      _parseElement(element, contents);
    }

    return contents;
  }

  void _parseElement(
    Element element,
    List<ArticleContent> contents,
  ) {
    final tag = element.localName?.toLowerCase();

    // Đoạn văn
    if (tag == 'p') {
      final text = element.text.trim();

      if (text.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: ArticleContentType.paragraph,
            content: text,
          ),
        );
      }

      return;
    }

    // Ảnh + chú thích
    if (tag == 'figure') {
      _parseFigure(element, contents);
      return;
    }

    if (tag == 'table') {
      _parseImageContainer(element, contents);
      return;
    }

    for (final child in element.children) {
      _parseElement(child, contents);
    }
  }

  void _parseFigure(
    Element figure,
    List<ArticleContent> contents,
  ) {
    final image = figure.querySelector('img');

    if (image != null) {
      final imageUrl = _getImageUrl(image);

      if (imageUrl.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: ArticleContentType.image,
            content: imageUrl,
          ),
        );
      }
    }

    final caption =
        figure.querySelector('figcaption');

    if (caption != null) {
      final text = caption.text.trim();

      if (text.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: ArticleContentType.caption,
            content: text,
          ),
        );
      }
    }
  }

  void _parseImageContainer(
    Element container,
    List<ArticleContent> contents,
  ) {
    final images =
        container.querySelectorAll('img');

    for (final image in images) {
      final imageUrl = _getImageUrl(image);

      if (imageUrl.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: ArticleContentType.image,
            content: imageUrl,
          ),
        );
      }
    }

    final caption = container.querySelector(
      '.desc_cation, figcaption',
    );

    if (caption != null) {
      final text = caption.text.trim();

      if (text.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: ArticleContentType.caption,
            content: text,
          ),
        );
      }
    }
  }

  String _getImageUrl(Element image) {
    String url =
        image.attributes['data-src'] ??
        image.attributes['data-original'] ??
        image.attributes['src'] ??
        '';

    url = url.trim();

    if (url.startsWith('//')) {
      return 'https:$url';
    }

    return url;
  }
}