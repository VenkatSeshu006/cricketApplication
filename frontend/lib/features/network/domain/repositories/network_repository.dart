import '../entities/connection.dart';
import '../entities/connection_request.dart';

abstract class NetworkRepository {
  /// Get all connections for the current user
  Future<List<Connection>> getConnections();

  /// Get all connection requests for the current user
  Future<List<ConnectionRequest>> getRequests();

  /// Get suggested connections for the current user
  Future<List<Connection>> getSuggestions();

  /// Search connections by query
  Future<List<Connection>> searchConnections(String query);

  /// Filter connections by role
  Future<List<Connection>> filterConnectionsByRole(String role);

  /// Send a connection request to another user
  Future<void> sendConnectionRequest(String userId);

  /// Accept a connection request
  Future<void> acceptConnectionRequest(String requestId);

  /// Reject a connection request
  Future<void> rejectConnectionRequest(String requestId);

  /// Remove a connection
  Future<void> removeConnection(String connectionId);
}
