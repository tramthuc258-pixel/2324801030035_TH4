import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/rss_service.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final RssService _service = RssService();

  String _selectedCategory = 'Thế giới';

  late Future<List<Article>> _future;

  // Icon + màu riêng cho từng chủ đề
  final Map<String, ({IconData icon, Color color})> _categoryStyles = {
    'Thế giới': (
      icon: Icons.public_rounded,
      color: Colors.blue,
    ),
    'Kinh doanh': (
      icon: Icons.business_center_rounded,
      color: Colors.orange,
    ),
    'Khoa học': (
      icon: Icons.science_rounded,
      color: Colors.purple,
    ),
    'Giải trí': (
      icon: Icons.movie_rounded,
      color: Colors.pink,
    ),
    'Thể thao': (
      icon: Icons.sports_soccer_rounded,
      color: Colors.green,
    ),
    'Pháp luật': (
      icon: Icons.gavel_rounded,
      color: Colors.brown,
    ),
    'Giáo dục': (
      icon: Icons.school_rounded,
      color: Colors.indigo,
    ),
    'Sức khỏe': (
      icon: Icons.favorite_rounded,
      color: Colors.red,
    ),
    'Đời sống': (
      icon: Icons.home_rounded,
      color: Colors.teal,
    ),
    'Du lịch': (
      icon: Icons.flight_rounded,
      color: Colors.cyan,
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  // Tải tin theo chủ đề đang chọn
  void _loadCategory() {
    _future = _service.getArticles(
      category: _selectedCategory,
    );
  }

  // Chọn chủ đề
  void _selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }

    setState(() {
      _selectedCategory = category;
      _loadCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = RssService.categories.keys
        .where((category) => category != 'Tin mới nhất')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chủ đề',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: Column(
        children: [
          // DANH SÁCH CHỦ ĐỀ
          SizedBox(
            height: 62,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 9),
              itemBuilder: (context, index) {
                final category = categories[index];

                final bool isSelected =
                    category == _selectedCategory;

                // Lấy icon + màu của chủ đề
                final style = _categoryStyles[category];

                final IconData categoryIcon =
                    style?.icon ?? Icons.article_rounded;

                final Color categoryColor =
                    style?.color ?? theme.colorScheme.primary;

                return ChoiceChip(
                  // Icon
                  avatar: Icon(
                    categoryIcon,
                    size: 19,
                    color: categoryColor,
                  ),

                  // Tên chủ đề
                  label: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,

                      color: isSelected
                          ? categoryColor
                          : theme.colorScheme.onSurface,
                    ),
                  ),

                  selected: isSelected,

                  showCheckmark: false,

                  backgroundColor:
                      theme.colorScheme.surface,

                  selectedColor: categoryColor.withValues(
                    alpha: 0.13,
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 8,
                  ),

                  side: BorderSide(
                    width: isSelected ? 1.3 : 1,
                    color: isSelected
                        ? categoryColor.withValues(
                            alpha: 0.55,
                          )
                        : theme.colorScheme.outlineVariant,
                  ),

                  // Bấm chọn chủ đề
                  onSelected: (_) {
                    _selectCategory(category);
                  },
                );
              },
            ),
          ),

          // DANH SÁCH BÀI VIẾT
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _future,
              builder: (context, snapshot) {
                // Đang tải dữ liệu
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Lỗi tải RSS
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 50,
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Không thể tải chủ đề.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Vui lòng kiểm tra kết nối Internet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 16),

                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _loadCategory();
                              });
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                            ),
                            label: const Text(
                              'Thử lại',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final articles = snapshot.data ?? [];

                // Không có bài viết
                if (articles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 50,
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Không có bài viết trong chủ đề này.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Danh sách tin
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    24,
                  ),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final article = articles[index];

                    return NewsCard(
                      article: article,

                      // Bấm vào bài -> màn hình chi tiết
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
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
          ),
        ],
      ),
    );
  }
}