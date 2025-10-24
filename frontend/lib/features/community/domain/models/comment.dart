class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String content;
  final int likesCount;
  final bool isLikedByUser;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.content,
    required this.likesCount,
    required this.isLikedByUser,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhoto: json['userPhoto'] as String?,
      content: json['content'] as String,
      likesCount: json['likesCount'] as int? ?? 0,
      isLikedByUser: json['isLikedByUser'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'content': content,
      'likesCount': likesCount,
      'isLikedByUser': isLikedByUser,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userPhoto,
    String? content,
    int? likesCount,
    bool? isLikedByUser,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
