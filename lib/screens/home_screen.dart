import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/rss_service.dart';
import '../widgets/loading_card.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RssService _rssService = RssService();

  late Future<List<Article>> _future;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _future = _rssService.getArticles();
  }

  Future<void> _refresh() async {
    setState(_loadNews);
    await _future;
  }

  void _openDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          article: article,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  8,
                ),
                sliver: SliverToBoxAdapter(
                  child: _header(),
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Tin nổi bật',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              FutureBuilder<List<Article>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SliverPadding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      sliver: SliverList.separated(
                        itemCount: 5,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 14),
                        itemBuilder: (_, _) =>
                            const LoadingCard(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: _error(),
                    );
                  }

                  final articles =
                      snapshot.data ?? [];

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      30,
                    ),
                    sliver: SliverList.separated(
                      itemCount: articles.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 14),
                      itemBuilder: (_, index) {
                        return NewsCard(
                          article: articles[index],
                          onTap: () => _openDetail(
                            articles[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.newspaper_rounded,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'ĐỌC BÁO ONLINE',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'VNews - Tin tức mỗi ngày',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: _refresh,
          icon: const Icon(
            Icons.refresh_rounded,
          ),
        ),
      ],
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 55,
          ),
          const SizedBox(height: 15),
          const Text(
            'Không thể tải tin tức',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          FilledButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}