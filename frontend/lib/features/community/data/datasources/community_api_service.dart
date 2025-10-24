import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/entities/post.dart';
import '../../domain/models/comment.dart';

class CommunityApiService {
  final http.Client _client = http.Client();

  // Get community feed with pagination
  Future<Map<String, dynamic>> getFeed({
    int page = 1,
    int limit = 10,
    String? postType,
    String? visibility,
  }) async {
    try {
      var uri = Uri.parse('${ApiConfig.baseUrl}/posts?page=$page&limit=$limit');

      if (postType != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'post_type': postType},
        );
      }
      if (visibility != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'visibility': visibility},
        );
      }

      final response = await _client.get(uri, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['posts'] as List)
              .map((p) => _mapPostFromBackend(p))
              .toList(),
          'pagination': data['pagination'],
        };
      } else {
        throw Exception('Failed to load feed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get single post details
  Future<Post> getPost(String postId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapPostFromBackend(data['post']);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create new post
  Future<Post> createPost({
    required String token,
    required String content,
    List<String>? mediaUrls,
    String postType = 'general',
    String visibility = 'public',
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/posts'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'content': content,
          'media_urls': mediaUrls ?? [],
          'post_type': postType,
          'visibility': visibility,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapPostFromBackend(data['post']);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update post
  Future<void> updatePost({
    required String token,
    required String postId,
    String? content,
    String? visibility,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (content != null) body['content'] = content;
      if (visibility != null) body['visibility'] = visibility;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete post
  Future<void> deletePost({
    required String token,
    required String postId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get comments for a post
  Future<List<Comment>> getComments({
    required String postId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/posts/$postId/comments?page=$page&limit=$limit',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['comments'] as List)
            .map((c) => _mapCommentFromBackend(c))
            .toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create comment
  Future<Comment> createComment({
    required String token,
    required String postId,
    required String content,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/comments'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapCommentFromBackend(data['comment']);
      } else {
        throw Exception('Failed to create comment');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update comment
  Future<void> updateComment({
    required String token,
    required String commentId,
    required String content,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/comments/$commentId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({'content': content}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update comment');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/comments/$commentId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Like post
  Future<void> likePost({required String token, required String postId}) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/like'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to like post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Unlike post
  Future<void> unlikePost({
    required String token,
    required String postId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/like'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unlike post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Like comment
  Future<void> likeComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/comments/$commentId/like'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to like comment');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Unlike comment
  Future<void> unlikeComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/comments/$commentId/like'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unlike comment');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Private mapper: Backend Post -> Frontend Post
  Post _mapPostFromBackend(Map<String, dynamic> backendPost) {
    PostType postType = PostType.general;
    final typeStr = backendPost['post_type'] as String? ?? 'general';
    switch (typeStr) {
      case 'general':
        postType = PostType.general;
        break;
      case 'match':
      case 'news':
        postType = PostType.news;
        break;
      case 'training':
      case 'article':
        postType = PostType.article;
        break;
      case 'achievement':
      case 'question':
        postType = PostType.lookingFor;
        break;
    }

    return Post(
      id: backendPost['id'] as String,
      authorId: backendPost['user_id'] as String,
      authorName: backendPost['user_name'] as String? ?? 'Unknown User',
      authorRole: 'Player', // Default role, could be enhanced
      authorImage: backendPost['user_photo'] as String?,
      content: backendPost['content'] as String,
      images: List<String>.from(backendPost['media_urls'] ?? []),
      type: postType,
      createdAt: DateTime.parse(backendPost['created_at'] as String),
      likes: backendPost['likes_count'] as int? ?? 0,
      comments: backendPost['comments_count'] as int? ?? 0,
      shares: backendPost['shares_count'] as int? ?? 0,
      isLiked: backendPost['is_liked_by_user'] as bool? ?? false,
    );
  }

  // Private mapper: Backend Comment -> Frontend Comment
  Comment _mapCommentFromBackend(Map<String, dynamic> backendComment) {
    return Comment(
      id: backendComment['id'] as String,
      postId: backendComment['post_id'] as String,
      userId: backendComment['user_id'] as String,
      userName: backendComment['user_name'] as String? ?? 'Unknown User',
      userPhoto: backendComment['user_photo'] as String?,
      content: backendComment['content'] as String,
      likesCount: backendComment['likes_count'] as int? ?? 0,
      isLikedByUser: backendComment['is_liked_by_user'] as bool? ?? false,
      createdAt: DateTime.parse(backendComment['created_at'] as String),
    );
  }
}
