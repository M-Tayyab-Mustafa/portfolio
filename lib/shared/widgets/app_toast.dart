import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';

enum AppToastType { success, error }

abstract final class AppToast {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    required AppToastType type,
  }) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 460,
        elevation: 0,
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.transparent,
        duration: Duration(seconds: type == AppToastType.success ? 4 : 6),
        content: _AppToastCard(
          message: message,
          type: type,
          onDismissed: messenger.hideCurrentSnackBar,
        ),
      ),
    );
  }
}

class _AppToastCard extends StatelessWidget {
  const _AppToastCard({
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  final String message;
  final AppToastType type;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final success = type == AppToastType.success;
    final color = success ? AppColors.success : AppColors.accentBright;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        border: Border.all(color: color.withValues(alpha: .6)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .16),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(color: color, child: const SizedBox(width: 4)),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  border: Border.all(color: color.withValues(alpha: .35)),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppIcon(
                    success ? 'check' : 'close',
                    size: 16,
                    color: color,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      success ? 'MESSAGE SENT' : 'SOMETHING WENT WRONG',
                      style: TextStyle(
                        color: color,
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onDismissed,
              tooltip: 'Dismiss notification',
              icon: const AppIcon(
                'close',
                size: 15,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
