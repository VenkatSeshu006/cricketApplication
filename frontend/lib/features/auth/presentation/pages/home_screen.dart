import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CricketApp Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_cricket,
                        size: 100,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome!',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Details',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                Icons.person,
                                'Name',
                                state.user.fullName,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.email,
                                'Email',
                                state.user.email,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.badge,
                                'Role',
                                state.user.role.toUpperCase(),
                              ),
                              if (state.user.phone != null) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.phone,
                                  'Phone',
                                  state.user.phone!,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '🎉 Authentication successful!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
