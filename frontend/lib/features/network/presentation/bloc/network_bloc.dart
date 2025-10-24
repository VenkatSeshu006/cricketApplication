import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/network_repository.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkRepository repository;

  NetworkBloc({required this.repository}) : super(const NetworkInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<LoadRequests>(_onLoadRequests);
    on<LoadSuggestions>(_onLoadSuggestions);
    on<SearchNetwork>(_onSearchNetwork);
    on<FilterByRole>(_onFilterByRole);
    on<SendConnectionRequest>(_onSendConnectionRequest);
    on<AcceptConnectionRequest>(_onAcceptConnectionRequest);
    on<RejectConnectionRequest>(_onRejectConnectionRequest);
    on<RemoveConnection>(_onRemoveConnection);
  }

  Future<void> _onLoadConnections(
    LoadConnections event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      emit(const NetworkLoading());

      final connections = await repository.getConnections();
      final requests = await repository.getRequests();
      final suggestions = await repository.getSuggestions();

      emit(
        NetworkLoaded(
          connections: connections,
          requests: requests,
          suggestions: suggestions,
        ),
      );
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to load connections: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onLoadRequests(
    LoadRequests event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      if (state is! NetworkLoaded) {
        emit(const NetworkLoading());
      }

      final requests = await repository.getRequests();

      if (state is NetworkLoaded) {
        emit((state as NetworkLoaded).copyWith(requests: requests));
      } else {
        final connections = await repository.getConnections();
        final suggestions = await repository.getSuggestions();

        emit(
          NetworkLoaded(
            connections: connections,
            requests: requests,
            suggestions: suggestions,
          ),
        );
      }
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to load requests: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onLoadSuggestions(
    LoadSuggestions event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      if (state is! NetworkLoaded) {
        emit(const NetworkLoading());
      }

      final suggestions = await repository.getSuggestions();

      if (state is NetworkLoaded) {
        emit((state as NetworkLoaded).copyWith(suggestions: suggestions));
      } else {
        final connections = await repository.getConnections();
        final requests = await repository.getRequests();

        emit(
          NetworkLoaded(
            connections: connections,
            requests: requests,
            suggestions: suggestions,
          ),
        );
      }
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to load suggestions: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onSearchNetwork(
    SearchNetwork event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      if (state is NetworkLoaded) {
        final currentState = state as NetworkLoaded;

        final connections = await repository.searchConnections(event.query);

        emit(
          currentState.copyWith(
            connections: connections,
            searchQuery: event.query,
          ),
        );
      }
    } catch (e) {
      emit(
        NetworkError(
          message: 'Search failed: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onFilterByRole(
    FilterByRole event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      if (state is NetworkLoaded) {
        final currentState = state as NetworkLoaded;

        final connections = await repository.filterConnectionsByRole(
          event.role,
        );

        emit(
          currentState.copyWith(
            connections: connections,
            roleFilter: event.role,
          ),
        );
      }
    } catch (e) {
      emit(
        NetworkError(
          message: 'Filter failed: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onSendConnectionRequest(
    SendConnectionRequest event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      emit(const ConnectionRequestSending());

      await repository.sendConnectionRequest(event.userId);

      emit(const ConnectionRequestSent('Connection request sent successfully'));

      // Reload data after sending request
      add(const LoadConnections());
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to send connection request: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onAcceptConnectionRequest(
    AcceptConnectionRequest event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      await repository.acceptConnectionRequest(event.requestId);

      emit(const ConnectionRequestAccepted('Connection request accepted'));

      // Reload data after accepting request
      add(const LoadConnections());
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to accept connection request: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onRejectConnectionRequest(
    RejectConnectionRequest event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      await repository.rejectConnectionRequest(event.requestId);

      emit(const ConnectionRequestRejected('Connection request rejected'));

      // Reload data after rejecting request
      add(const LoadConnections());
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to reject connection request: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  Future<void> _onRemoveConnection(
    RemoveConnection event,
    Emitter<NetworkState> emit,
  ) async {
    try {
      await repository.removeConnection(event.connectionId);

      emit(const ConnectionRemoved('Connection removed successfully'));

      // Reload data after removing connection
      add(const LoadConnections());
    } catch (e) {
      emit(
        NetworkError(
          message: 'Failed to remove connection: ${e.toString()}',
          type: _getErrorType(e),
        ),
      );
    }
  }

  NetworkErrorType _getErrorType(dynamic error) {
    // In a real app, you would check the actual error type
    // For now, return unknown
    return NetworkErrorType.unknown;
  }
}
