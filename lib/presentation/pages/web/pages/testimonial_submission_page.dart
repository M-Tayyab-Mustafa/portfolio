import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/services/email_js_contact_message_sender.dart';
import 'package:portfolio/presentation/blocs/content/portfolio_content_bloc.dart';
import 'package:portfolio/presentation/pages/web/widgets/outlined_text.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/app_toast.dart';
import 'package:portfolio/shared/widgets/brand_loader.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';

class TestimonialSubmissionPage extends StatelessWidget {
  const TestimonialSubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioContentBloc, PortfolioContentState>(
      builder: (context, state) {
        final content = state.content;
        if (content != null) return _SubmissionView(content: content);
        if (state.status == PortfolioContentStatus.failure) {
          return _SubmissionLoadFailure(message: state.errorMessage);
        }
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: BrandLoader(),
        );
      },
    );
  }
}

class _SubmissionView extends StatefulWidget {
  const _SubmissionView({required this.content});

  final PortfolioContent content;

  @override
  State<_SubmissionView> createState() => _SubmissionViewState();
}

class _SubmissionViewState extends State<_SubmissionView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 5;
  bool _submitting = false;
  bool _success = false;

  PortfolioContent get content => widget.content;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _submitting) return;
    setState(() => _submitting = true);
    try {
      await EmailJsContactMessageSender().send(
        configuration: content.emailJs,
        senderName: _nameController.text.trim(),
        senderEmail: content.profile.email,
        subject: 'Portfolio testimonial from ${_nameController.text.trim()}',
        message:
            'Role: ${_roleController.text.trim()}\n'
            'Company: ${_companyController.text.trim()}\n'
            'Rating: $_rating/5\n\n'
            '${_feedbackController.text.trim()}',
      );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _success = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppToast.show(
        context,
        message: 'Your testimonial could not be delivered. Please try again.',
        type: AppToastType.error,
      );
    }
  }

  void _reset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _roleController.clear();
    _companyController.clear();
    _feedbackController.clear();
    setState(() {
      _rating = 5;
      _success = false;
    });
  }

  void _back() => context.go(PortfolioSection.home.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SelectionArea(
        child: Stack(
          children: [
            const Positioned(
              left: -150,
              top: -150,
              child: _AmbientGlow(size: 500, opacity: .15),
            ),
            const Positioned(
              right: -150,
              bottom: -150,
              child: _AmbientGlow(size: 450, opacity: .1),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _SubmissionHeader(content: content, onBack: _back),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 52,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final mainPanel = AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-.025, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: _success
                                    ? _SuccessPanel(
                                        key: const ValueKey('success'),
                                        onBack: _back,
                                        onReset: _reset,
                                      )
                                    : _buildForm(),
                              );
                              final preview = _TestimonialPreview(
                                name: _nameController.text,
                                role: _roleController.text,
                                company: _companyController.text,
                                feedback: _feedbackController.text,
                                rating: _rating,
                              );
                              if (constraints.maxWidth < 900) {
                                return Column(
                                  children: [
                                    mainPanel,
                                    const SizedBox(height: 48),
                                    preview,
                                  ],
                                );
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 7, child: mainPanel),
                                  const SizedBox(width: 52),
                                  Expanded(flex: 5, child: preview),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _SubmissionFooter(content: content, onBack: _back),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    final headingStyle = Theme.of(context).textTheme.displayMedium!.copyWith(
      fontSize: 58,
      fontWeight: FontWeight.w900,
      height: .9,
      letterSpacing: -2.5,
    );
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SHARE YOUR FEEDBACK',
            style: TextStyle(
              color: AppColors.accent,
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.2,
            ),
          ),
          const SizedBox(height: 14),
          Text('SUBMIT A', style: headingStyle),
          OutlinedText('TESTIMONIAL', style: headingStyle),
          const SizedBox(height: 18),
          const Text(
            'Thank you for partnering with me! Your perspective and feedback are incredibly valuable. Please fill out the form below to share your experience.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 34),
          _FormPair(
            first: _SubmissionField(
              controller: _nameController,
              label: 'Full Name *',
              hint: 'e.g. Sarah Connor',
              onChanged: (_) => setState(() {}),
            ),
            second: _SubmissionField(
              controller: _roleController,
              label: 'Your Title / Role *',
              hint: 'e.g. CTO / Product Director',
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 22),
          _FormPair(
            first: _SubmissionField(
              controller: _companyController,
              label: 'Company Name *',
              hint: 'e.g. Cyberdyne Systems',
              onChanged: (_) => setState(() {}),
            ),
            second: _RatingSelector(
              rating: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _FieldLabel('Your Review / Testimonial *'),
              Text(
                '${_feedbackController.text.length} / 500 characters',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _SubmissionField(
            controller: _feedbackController,
            label: 'Your Review / Testimonial *',
            hint:
                'Share some words about our collaboration, the quality of delivery, and output results...',
            maxLength: 500,
            minLines: 5,
            maxLines: 5,
            showLabel: false,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          _PrimarySubmitButton(
            submitting: _submitting,
            onPressed: _submitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}

class _FormPair extends StatelessWidget {
  const _FormPair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Column(children: [first, const SizedBox(height: 22), second]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 24),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _SubmissionField extends StatelessWidget {
  const _SubmissionField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.label = '',
    this.showLabel = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool showLabel;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[_FieldLabel(label), const SizedBox(height: 8)],
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              return '${label.replaceAll(' *', '')} is required.';
            }
            if (minLines > 1 && text.length < 20) {
              return 'Your review must be at least 20 characters.';
            }
            return null;
          },
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: _fieldBorder(AppColors.borderStrong),
            enabledBorder: _fieldBorder(AppColors.borderStrong),
            focusedBorder: _fieldBorder(AppColors.accent),
            errorBorder: _fieldBorder(AppColors.accentBright),
            focusedErrorBorder: _fieldBorder(AppColors.accentBright),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.25,
      ),
    );
  }
}

class _RatingSelector extends StatelessWidget {
  const _RatingSelector({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Rating Experience *'),
        const SizedBox(height: 7),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              for (var value = 1; value <= 5; value++)
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 40,
                  ),
                  onPressed: () => onChanged(value),
                  tooltip: '$value stars',
                  icon: Icon(
                    value <= rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: value <= rating
                        ? AppColors.accent
                        : AppColors.borderStrong,
                    size: 29,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimarySubmitButton extends StatelessWidget {
  const _PrimarySubmitButton({
    required this.submitting,
    required this.onPressed,
  });

  final bool submitting;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          disabledBackgroundColor: AppColors.borderStrong,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (submitting) ...[
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              const Text('SAVING FEEDBACK...'),
            ] else ...[
              const Text('SUBMIT TESTIMONIAL'),
              const SizedBox(width: 12),
              const AppIcon('send', size: 16, color: AppColors.textPrimary),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubmissionHeader extends StatelessWidget {
  const _SubmissionHeader({required this.content, required this.onBack});

  final PortfolioContent content;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 700
        ? 24.0
        : 48.0;
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: Color(0xE6080808),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onBack,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.45,
              ),
            ),
            icon: const AppIcon('arrowLeft', size: 16),
            label: const Text('BACK TO PORTFOLIO'),
          ),
          BrandLogo(
            profile: content.profile,
            semanticLabel: 'Muhammad Tayyab, go to the portfolio home section',
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class _TestimonialPreview extends StatelessWidget {
  const _TestimonialPreview({
    required this.name,
    required this.role,
    required this.company,
    required this.feedback,
    required this.rating,
  });

  final String name;
  final String role;
  final String company;
  final String feedback;
  final int rating;

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().isEmpty ? 'Client Name' : name.trim();
    final displayRole = role.trim().isEmpty ? 'Role / Position' : role.trim();
    final displayCompany = company.trim().isEmpty ? 'Company' : company.trim();
    final displayFeedback = feedback.trim().isEmpty
        ? 'Enter your feedback details on the left, and watch your card instantly render here in real-time.'
        : feedback.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LIVE PREVIEW',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(minHeight: 300),
          padding: const EdgeInsets.all(38),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 34,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                right: 0,
                top: 0,
                child: Opacity(
                  opacity: .1,
                  child: AppIcon('quote', size: 64, color: AppColors.accent),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (var index = 0; index < 5; index++)
                        Icon(
                          index < rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: index < rating
                              ? AppColors.accent
                              : AppColors.borderStrong,
                          size: 19,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '“$displayFeedback”',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.accent,
                        child: Text(
                          _previewInitials(displayName),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                text: '$displayRole at ',
                                children: [
                                  TextSpan(
                                    text: displayCompany,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessPanel extends StatelessWidget {
  const _SuccessPanel({required this.onBack, required this.onReset, super.key});

  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: .1),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: .25),
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: AppIcon('check', color: AppColors.success, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRANSMISSION CONFIRMED',
                      style: TextStyle(
                        color: AppColors.success,
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'THANK YOU SO MUCH!',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Your recommendation was delivered successfully. It will be reviewed before it appears in the live portfolio testimonials.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✨', style: TextStyle(fontSize: 16, height: 1)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your feedback is sent privately through EmailJS and is never published automatically.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'View live portfolio',
                  expanded: true,
                  compact: true,
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppButton(
                  label: 'Submit another feedback',
                  variant: AppButtonVariant.outline,
                  expanded: true,
                  compact: true,
                  onPressed: onReset,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter({required this.content, required this.onBack});

  final PortfolioContent content;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 700
        ? 24.0
        : 48.0;
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: Color(0x4D121212),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© ${DateTime.now().year} ${content.profile.fullName}. All rights reserved.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              TextButton(onPressed: onBack, child: const Text('Portfolio')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '|',
                  style: TextStyle(color: AppColors.borderStrong),
                ),
              ),
              const Text(
                'Feedback Console',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: opacity),
              AppColors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmissionLoadFailure extends StatelessWidget {
  const _SubmissionLoadFailure({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon('cloud', color: AppColors.accent, size: 42),
            const SizedBox(height: 18),
            Text(message ?? 'Portfolio content could not be loaded.'),
            const SizedBox(height: 22),
            AppButton(
              label: 'Back to portfolio',
              onPressed: () => context.go(PortfolioSection.home.path),
            ),
          ],
        ),
      ),
    );
  }
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(3),
    borderSide: BorderSide(color: color),
  );
}

String _previewInitials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty || value == 'Client Name') return 'CL';
  if (parts.length == 1) {
    final part = parts.first;
    return part.substring(0, part.length.clamp(1, 2)).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
