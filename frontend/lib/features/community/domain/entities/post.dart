import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String? authorImage;
  final String content;
  final List<String> images;
  final PostType type;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final Map<String, dynamic>? metadata; // For looking-for posts

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    this.authorImage,
    required this.content,
    this.images = const [],
    required this.type,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorRole,
    authorImage,
    content,
    images,
    type,
    createdAt,
    likes,
    comments,
    shares,
    isLiked,
    metadata,
  ];

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorImage,
    String? content,
    List<String>? images,
    PostType? type,
    DateTime? createdAt,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    Map<String, dynamic>? metadata,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorImage: authorImage ?? this.authorImage,
      content: content ?? this.content,
      images: images ?? this.images,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum PostType { general, news, article, lookingFor }
