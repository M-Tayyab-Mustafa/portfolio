import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/app_toast.dart';

class PersistentResumeButton extends StatefulWidget {
  const PersistentResumeButton({
    required this.resumeUrl,
    required this.ownerName,
    super.key,
  });

  final String resumeUrl;
  final String ownerName;

  @override
  State<PersistentResumeButton> createState() => _PersistentResumeButtonState();
}

class _PersistentResumeButtonState extends State<PersistentResumeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _feedbackTimer;
  bool _hovered = false;
  bool _downloaded = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _download() async {
    final url = widget.resumeUrl.trim();
    if (url.isEmpty) {
      AppToast.show(
        context,
        message: 'The resume download link is not available yet.',
        type: AppToastType.error,
      );
      return;
    }

    final opened = await LinkLauncher.download(url);
    if (!mounted) return;
    if (!opened) {
      AppToast.show(
        context,
        message: 'The resume could not be downloaded.',
        type: AppToastType.error,
      );
      return;
    }

    _feedbackTimer?.cancel();
    setState(() => _downloaded = true);
    _feedbackTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) setState(() => _downloaded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final showBadge = MediaQuery.sizeOf(context).width >= 480;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: showBadge ? 172 : 142,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedScale(
                    scale: _hovered ? 1 : .9,
                    duration: const Duration(milliseconds: 200),
                    child: _ResumeTooltip(ownerName: widget.ownerName),
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Download resume',
              child: AnimatedScale(
                scale: _hovered ? 1.03 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppLayout.radius),
                    boxShadow: [
                      BoxShadow(
                        color: _hovered
                            ? AppColors.accent.withValues(alpha: .3)
                            : Colors.black.withValues(alpha: .7),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TextButton(
                    key: const ValueKey('persistent-resume-download-button'),
                    onPressed: _download,
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.surface.withValues(alpha: .96),
                      ),
                      foregroundColor: WidgetStateProperty.all(
                        AppColors.textPrimary,
                      ),
                      overlayColor: WidgetStateProperty.all(
                        AppColors.accent.withValues(alpha: .08),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppLayout.radius),
                          side: BorderSide(
                            color: _downloaded
                                ? AppColors.success
                                : AppColors.accent.withValues(
                                    alpha: _hovered ? 1 : .5,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PulseDot(controller: _pulseController),
                        const SizedBox(width: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: AppIcon(
                            _downloaded ? 'check' : 'download',
                            key: ValueKey(_downloaded),
                            size: 17,
                            color: _downloaded
                                ? AppColors.success
                                : AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          _downloaded ? 'DOWNLOADED!' : 'RESUME',
                          style: TextStyle(
                            color: _downloaded
                                ? AppColors.success
                                : AppColors.textPrimary,
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
                        ),
                        if (showBadge) ...[
                          const SizedBox(width: 10),
                          const _PdfBadge(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeTooltip extends StatelessWidget {
  const _ResumeTooltip({required this.ownerName});

  final String ownerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .96),
        border: Border.all(color: AppColors.accent.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(AppLayout.radius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon('repository', size: 14, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            '$ownerName\'s Resume (PDF)'.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfBadge extends StatelessWidget {
  const _PdfBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: .2),
        border: Border.all(color: AppColors.accent.withValues(alpha: .3)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Text(
        'PDF',
        style: TextStyle(
          color: AppColors.accent,
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 10,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1 + controller.value * 1.25,
              child: Opacity(
                opacity: .75 * (1 - controller.value),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(dimension: 8),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 8),
            ),
          ],
        ),
      ),
    );
  }
}
