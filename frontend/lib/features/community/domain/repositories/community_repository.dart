
abstract class CommunityRepository {
  Future<Map<String, dynamic>> getFeed({
    int page = 1,
    int limit = 10,
    String? postType,
    String? visibility,
  });

  Future<Map<String, dynamic>> getPost(String postId);

  Future<Map<String, dynamic>> createPost({
    required String content,
    List<String>? mediaUrls,
    String postType = 'general',
    String visibility = 'public',
  });

  Future<Map<String, dynamic>> updatePost({
    required String postId,
    String? content,
    String? visibility,
  });

  Future<Map<String, dynamic>> deletePost(String postId);

  Future<Map<String, dynamic>> getComments({
    required String postId,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String content,
  });

  Future<Map<String, dynamic>> updateComment({
    required String commentId,
    required String content,
  });

  Future<Map<String, dynamic>> deleteComment(String commentId);

  Future<Map<String, dynamic>> likePost(String postId);

  Future<Map<String, dynamic>> unlikePost(String postId);

  Future<Map<String, dynamic>> likeComment(String commentId);

  Future<Map<String, dynamic>> unlikeComment(String commentId);
}
