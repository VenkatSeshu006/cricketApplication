import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_api_service.dart';

class RealCommunityRepository implements CommunityRepository {
  final CommunityApiService _apiService;
  static const _keyToken = 'auth_token';

  RealCommunityRepository(this._apiService);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @override
  Future<Map<String, dynamic>> getFeed({
    int page = 1,
    int limit = 10,
    String? postType,
    String? visibility,
  }) async {
    try {
      final result = await _apiService.getFeed(
        page: page,
        limit: limit,
        postType: postType,
        visibility: visibility,
      );

      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load feed: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getPost(String postId) async {
    try {
      final post = await _apiService.getPost(postId);

      return {'success': true, 'data': post};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createPost({
    required String content,
    List<String>? mediaUrls,
    String postType = 'general',
    String visibility = 'public',
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final post = await _apiService.createPost(
        token: token,
        content: content,
        mediaUrls: mediaUrls,
        postType: postType,
        visibility: visibility,
      );

      return {
        'success': true,
        'data': post,
        'message': 'Post created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updatePost({
    required String postId,
    String? content,
    String? visibility,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updatePost(
        token: token,
        postId: postId,
        content: content,
        visibility: visibility,
      );

      return {'success': true, 'message': 'Post updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deletePost(String postId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.deletePost(token: token, postId: postId);

      return {'success': true, 'message': 'Post deleted successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getComments({
    required String postId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final comments = await _apiService.getComments(
        postId: postId,
        page: page,
        limit: limit,
      );

      return {'success': true, 'data': comments};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load comments: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final comment = await _apiService.createComment(
        token: token,
        postId: postId,
        content: content,
      );

      return {
        'success': true,
        'data': comment,
        'message': 'Comment added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add comment: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateComment(
        token: token,
        commentId: commentId,
        content: content,
      );

      return {'success': true, 'message': 'Comment updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update comment: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.deleteComment(token: token, commentId: commentId);

      return {'success': true, 'message': 'Comment deleted successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete comment: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> likePost(String postId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.likePost(token: token, postId: postId);

      return {'success': true, 'message': 'Post liked'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to like post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> unlikePost(String postId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.unlikePost(token: token, postId: postId);

      return {'success': true, 'message': 'Post unliked'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to unlike post: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> likeComment(String commentId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.likeComment(token: token, commentId: commentId);

      return {'success': true, 'message': 'Comment liked'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to like comment: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> unlikeComment(String commentId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.unlikeComment(token: token, commentId: commentId);

      return {'success': true, 'message': 'Comment unliked'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to unlike comment: ${e.toString()}',
      };
    }
  }
}
