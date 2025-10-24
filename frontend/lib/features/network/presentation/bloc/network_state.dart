import 'package:equatable/equatable.dart';
import '../../domain/entities/connection.dart';
import '../../domain/entities/connection_request.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object?> get props => [];
}

class NetworkInitial extends NetworkState {
  const NetworkInitial();
}

class NetworkLoading extends NetworkState {
  const NetworkLoading();
}

class NetworkLoaded extends NetworkState {
  final List<Connection> connections;
  final List<ConnectionRequest> requests;
  final List<Connection> suggestions;
  final String? searchQuery;
  final String? roleFilter;

  const NetworkLoaded({
    required this.connections,
    required this.requests,
    required this.suggestions,
    this.searchQuery,
    this.roleFilter,
  });

  @override
  List<Object?> get props => [
    connections,
    requests,
    suggestions,
    searchQuery,
    roleFilter,
  ];

  NetworkLoaded copyWith({
    List<Connection>? connections,
    List<ConnectionRequest>? requests,
    List<Connection>? suggestions,
    String? searchQuery,
    String? roleFilter,
  }) {
    return NetworkLoaded(
      connections: connections ?? this.connections,
      requests: requests ?? this.requests,
      suggestions: suggestions ?? this.suggestions,
      searchQuery: searchQuery ?? this.searchQuery,
      roleFilter: roleFilter ?? this.roleFilter,
    );
  }
}

class ConnectionRequestSending extends NetworkState {
  const ConnectionRequestSending();
}

class ConnectionRequestSent extends NetworkState {
  final String message;

  const ConnectionRequestSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ConnectionRequestAccepted extends NetworkState {
  final String message;

  const ConnectionRequestAccepted(this.message);

  @override
  List<Object?> get props => [message];
}

class ConnectionRequestRejected extends NetworkState {
  final String message;

  const ConnectionRequestRejected(this.message);

  @override
  List<Object?> get props => [message];
}

class ConnectionRemoved extends NetworkState {
  final String message;

  const ConnectionRemoved(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkError extends NetworkState {
  final String message;
  final NetworkErrorType type;

  const NetworkError({
    required this.message,
    this.type = NetworkErrorType.unknown,
  });

  @override
  List<Object?> get props => [message, type];
}

enum NetworkErrorType { network, server, notFound, unauthorized, unknown }
