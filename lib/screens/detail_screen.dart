import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';
import '../services/article_service.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ArticleService _articleService = ArticleService();

  late Future<List<ArticleContent>> _contentFuture;

  @override
  void initState() {
    super.initState();

    _contentFuture = _articleService.getArticleContent(
      widget.article.link,
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết tin',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: FutureBuilder<List<ArticleContent>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    // CHỦ ĐỀ
                   
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.category,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                   
                    // TIÊU ĐỀ
                   
                    Text(
                      article.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 14),

                
                    // THỜI GIAN
                   
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _formatDate(article.pubDate),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

               
                    // MÔ TẢ 
                
                    if (article.description.isNotEmpty)
                      Text(
                        article.description,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    const SizedBox(height: 24),

                 
                    // NỘI DUNG BÀI BÁO
                 
                    _buildArticleContent(snapshot),

                    const SizedBox(height: 32),

                    const Divider(),

                    const SizedBox(height: 14),

                   
                    // NGUỒN
               
                    Row(
                      children: [
                        Icon(
                          Icons.language_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Nguồn: VnExpress',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // HIỂN THỊ NỘI DUNG BÀI

  Widget _buildArticleContent(
    AsyncSnapshot<List<ArticleContent>> snapshot,
  ) {
    // Đang tải
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40,
          ),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text(
                'Đang tải nội dung bài viết...',
              ),
            ],
          ),
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 45,
                color: Colors.grey,
              ),
              const SizedBox(height: 12),
              const Text(
                'Không thể tải toàn bộ nội dung.',
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _reload,
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

    final contents = snapshot.data ?? [];

    if (contents.isEmpty) {
      return const Text(
        'Không tìm thấy nội dung chi tiết.',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    }

    // Render theo đúng thứ tự lấy được từ VnExpress
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contents.map((content) {
        switch (content.type) {
          case ArticleContentType.paragraph:
            return _buildParagraph(
              content.content,
            );

          case ArticleContentType.image:
            return _buildImage(
              content.content,
            );

          case ArticleContentType.caption:
            return _buildCaption(
              content.content,
            );
        }
      }).toList(),
    );
  }


  // ĐOẠN VĂN
 
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.fitWidth,

          // Loading ảnh
          placeholder: (context, url) {
            return Container(
              width: double.infinity,
              height: 220,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },

          errorWidget: (context, url, error) {
            return Container(
              width: double.infinity,
              height: 180,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 42,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // CHÚ THÍCH ẢNH

  Widget _buildCaption(String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  // TẢI LẠI
  void _reload() {
    setState(() {
      _contentFuture = _articleService.getArticleContent(
        widget.article.link,
      );
    });
  }

  // FORMAT NGÀY

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Vừa cập nhật';
    }

    return DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(
      date.toLocal(),
    );
  }
}