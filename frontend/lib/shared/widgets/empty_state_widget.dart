import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Empty state widget for when there's no data
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 60,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty search results widget
class EmptySearchWidget extends StatelessWidget {
  final String query;
  final VoidCallback? onClearSearch;

  const EmptySearchWidget({
    super.key,
    required this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: 'We couldn\'t find anything matching "".\nTry different keywords.',
      icon: Icons.search_off,
      actionText: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty list widget with custom icon
class EmptyListWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyListWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      message: message,
      icon: icon,
      actionText: actionText,
      onAction: onAction,
    );
  }
}