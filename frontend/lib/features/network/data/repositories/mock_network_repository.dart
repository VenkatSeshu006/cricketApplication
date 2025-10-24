import '../../domain/entities/connection.dart';
import '../../domain/entities/connection_request.dart';
import '../../domain/repositories/network_repository.dart';

class MockNetworkRepository implements NetworkRepository {
  // Mock data
  final List<Connection> _mockConnections = [
    const Connection(
      id: '1',
      name: 'Shakib Al Hasan',
      role: 'Player',
      designation: 'All-rounder',
      location: 'Dhaka, Bangladesh',
      mutualConnections: 45,
      bio: 'Professional cricketer, Captain Bangladesh National Team',
      isConnected: true,
    ),
    const Connection(
      id: '2',
      name: 'Mashrafe Mortaza',
      role: 'Coach',
      designation: 'Head Coach',
      location: 'Dhaka, Bangladesh',
      mutualConnections: 38,
      bio: 'Former Bangladesh Captain, Current Head Coach',
      isConnected: true,
    ),
    const Connection(
      id: '3',
      name: 'Tamim Iqbal',
      role: 'Player',
      designation: 'Opening Batsman',
      location: 'Chattogram, Bangladesh',
      mutualConnections: 52,
      bio: 'Opening batsman, Record holder for most ODI runs for Bangladesh',
      isConnected: true,
    ),
  ];

  final List<ConnectionRequest> _mockRequests = [
    ConnectionRequest(
      id: 'req1',
      userId: '101',
      name: 'Mushfiqur Rahim',
      role: 'Player',
      designation: 'Wicket Keeper',
      location: 'Dhaka, Bangladesh',
      mutualConnections: 23,
      message: 'Would like to connect with you',
      requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ConnectionRequest(
      id: 'req2',
      userId: '102',
      name: 'Mehidy Hasan',
      role: 'Player',
      designation: 'All-rounder',
      location: 'Khulna, Bangladesh',
      mutualConnections: 15,
      message: 'Interested in networking',
      requestedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<Connection> _mockSuggestions = [
    const Connection(
      id: '201',
      name: 'Liton Das',
      role: 'Player',
      designation: 'Wicket Keeper Batsman',
      location: 'Dhaka, Bangladesh',
      mutualConnections: 18,
      bio: 'Wicket-keeper batsman for Bangladesh',
      isConnected: false,
    ),
    const Connection(
      id: '202',
      name: 'Mustafizur Rahman',
      role: 'Player',
      designation: 'Fast Bowler',
      location: 'Satkhira, Bangladesh',
      mutualConnections: 25,
      bio: 'Left-arm fast bowler, known as "The Fizz"',
      isConnected: false,
    ),
  ];

  @override
  Future<List<Connection>> getConnections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockConnections;
  }

  @override
  Future<List<ConnectionRequest>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockRequests;
  }

  @override
  Future<List<Connection>> getSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _mockSuggestions;
  }

  @override
  Future<List<Connection>> searchConnections(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.isEmpty) {
      return _mockConnections;
    }

    return _mockConnections.where((connection) {
      return connection.name.toLowerCase().contains(query.toLowerCase()) ||
          connection.designation.toLowerCase().contains(query.toLowerCase()) ||
          connection.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Future<List<Connection>> filterConnectionsByRole(String role) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (role == 'All') {
      return _mockConnections;
    }

    // Map role filter to plural for matching
    final roleMap = {
      'Players': 'Player',
      'Coaches': 'Coach',
      'Umpires': 'Umpire',
      'Organizers': 'Organizer',
    };

    final targetRole = roleMap[role] ?? role;

    return _mockConnections.where((connection) {
      return connection.role == targetRole;
    }).toList();
  }

  @override
  Future<void> sendConnectionRequest(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would make an API call
    // For now, we'll just simulate success
  }

  @override
  Future<void> acceptConnectionRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove from requests list
    _mockRequests.removeWhere((req) => req.id == requestId);

    // In a real app, this would add to connections
  }

  @override
  Future<void> rejectConnectionRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove from requests list
    _mockRequests.removeWhere((req) => req.id == requestId);
  }

  @override
  Future<void> removeConnection(String connectionId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove from connections list
    _mockConnections.removeWhere((conn) => conn.id == connectionId);
  }
}
