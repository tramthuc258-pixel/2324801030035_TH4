import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/rss_service.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class LatestScreen extends StatefulWidget {
  const LatestScreen({super.key});

  @override
  State<LatestScreen> createState() =>
      _LatestScreenState();
}

class _LatestScreenState
    extends State<LatestScreen> {
  final RssService _service = RssService();

  late Future<List<Article>> _future;

  @override
  void initState() {
    super.initState();

    _future = _service.getArticles(
      category: 'Tin mới nhất',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tin mới nhất',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: FutureBuilder<List<Article>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Không thể tải tin mới nhất.',
              ),
            );
          }

          final allArticles =
              snapshot.data ?? [];

          final articles =
              allArticles.take(10).toList();

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              30,
            ),
            itemCount: articles.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: 14),
            itemBuilder: (_, index) {
              final article = articles[index];

              return NewsCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(
                        article: article,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}