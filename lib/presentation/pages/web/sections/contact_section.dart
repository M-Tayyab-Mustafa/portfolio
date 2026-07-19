import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < AppLayout.compactDesktop;
    final heading = content.heading('contact');

    return SectionContainer(
      background: AppColors.surface,
      ambientAlignment: Alignment.centerRight,
      ambientOpacity: .06,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: heading.eyebrow,
              title: heading.title,
              accentTitle: heading.accentTitle,
              centered: false,
            ),
          ),
          SizedBox(height: compact ? 62 : 78),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: RevealOnScroll(
                    offset: const Offset(-.06, 0),
                    child: _ContactDetails(content: content),
                  ),
                ),
                SizedBox(width: compact ? 44 : 72),
                Expanded(
                  flex: 7,
                  child: RevealOnScroll(
                    delay: const Duration(milliseconds: 100),
                    offset: const Offset(.05, 0),
                    child: _ContactForm(content: content),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let’s create something legendary together.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Whether you have an upcoming project, are interested in hiring me full-time, or just want to talk about design systems and animations, feel free to drop me a line!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        for (final entry in content.contactChannels.indexed) ...[
          _ContactChannelCard(
            channel: entry.$2,
            failureTemplate: '{label} could not be opened.',
          ),
          if (entry.$1 != content.contactChannels.length - 1)
            const SizedBox(height: 13),
        ],
        const SizedBox(height: 40),
        const Divider(height: 1),
        const SizedBox(height: 24),
        Text(
          'FIND ME ON SOCIAL MEDIA',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 9,
          children: [
            for (final social in content.socials)
              AppIconButton(
                tooltip: social.label,
                onPressed: () => context.read<ExternalLinkCubit>().open(
                  url: social.url,
                  label: social.label,
                  failureTemplate: '{label} could not be opened.',
                ),
                icon: AppIcon(social.iconName, size: 19),
              ),
          ],
        ),
      ],
    );
  }
}

class _ContactChannelCard extends StatefulWidget {
  const _ContactChannelCard({
    required this.channel,
    required this.failureTemplate,
  });

  final ContactChannel channel;
  final String failureTemplate;

  @override
  State<_ContactChannelCard> createState() => _ContactChannelCardState();
}

class _ContactChannelCardState extends State<_ContactChannelCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: .55),
            border: Border.all(
              color: active
                  ? AppColors.accent.withValues(alpha: .5)
                  : AppColors.border,
              width: _focused ? 2 : 1,
            ),
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () => context.read<ExternalLinkCubit>().open(
                url: widget.channel.url,
                label: widget.channel.label,
                failureTemplate: widget.failureTemplate,
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: AppIcon(
                          widget.channel.iconName,
                          size: 20,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.channel.label.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontFamily: 'monospace',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .9,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.channel.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppIcon(
                      'external',
                      size: 17,
                      color: active ? AppColors.accent : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(34),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledField(
                  key: ValueKey('contact-name-${state.formRevision}'),
                  label: 'Full name',
                  hint: 'e.g. John Doe',
                  initialValue: state.name,
                  errorText: state.nameError,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactNameChanged(value),
                  ),
                ),
                const SizedBox(height: 20),
                _LabeledField(
                  key: ValueKey('contact-email-${state.formRevision}'),
                  label: 'Email address',
                  hint: 'e.g. john@example.com',
                  initialValue: state.email,
                  errorText: state.emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactEmailChanged(value),
                  ),
                ),
                const SizedBox(height: 20),
                _LabeledField(
                  key: ValueKey('contact-subject-${state.formRevision}'),
                  label: 'Subject',
                  hint: 'Flutter project / collaboration',
                  initialValue: state.subject,
                  errorText: state.subjectError,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactSubjectChanged(value),
                  ),
                ),
                const SizedBox(height: 20),
                _LabeledField(
                  key: ValueKey('contact-message-${state.formRevision}'),
                  label: 'Message',
                  hint:
                      'Tell me about the product, scope, and outcome you need…',
                  initialValue: state.message,
                  errorText: state.messageError,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactMessageChanged(value),
                  ),
                ),
                const SizedBox(height: 22),
                AppButton(
                  label: state.isSubmitting
                      ? 'Sending message…'
                      : 'Send message',
                  expanded: true,
                  icon: const AppIcon(
                    'send',
                    size: 17,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          context.read<ContactBloc>().add(
                            const ContactSubmitted(),
                          );
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.errorText,
    required this.textInputAction,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.autofillHints,
    super.key,
  });

  final String label;
  final String hint;
  final String initialValue;
  final String? errorText;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label.toUpperCase(),
            children: const [
              TextSpan(
                text: '  *',
                style: TextStyle(color: AppColors.accent),
              ),
            ],
          ),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .9,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          autofillHints: autofillHints,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(hintText: hint, errorText: errorText),
        ),
      ],
    );
  }
}
