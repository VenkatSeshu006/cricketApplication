import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

class LoadConnections extends NetworkEvent {
  const LoadConnections();
}

class LoadRequests extends NetworkEvent {
  const LoadRequests();
}

class LoadSuggestions extends NetworkEvent {
  const LoadSuggestions();
}

class SearchNetwork extends NetworkEvent {
  final String query;

  const SearchNetwork(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByRole extends NetworkEvent {
  final String role;

  const FilterByRole(this.role);

  @override
  List<Object?> get props => [role];
}

class SendConnectionRequest extends NetworkEvent {
  final String userId;

  const SendConnectionRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AcceptConnectionRequest extends NetworkEvent {
  final String requestId;

  const AcceptConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class RejectConnectionRequest extends NetworkEvent {
  final String requestId;

  const RejectConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class RemoveConnection extends NetworkEvent {
  final String connectionId;

  const RemoveConnection(this.connectionId);

  @override
  List<Object?> get props => [connectionId];
}
