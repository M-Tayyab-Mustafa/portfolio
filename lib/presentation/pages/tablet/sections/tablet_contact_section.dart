import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/pages/tablet/widgets/tablet_section.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';

class TabletContactSection extends StatelessWidget {
  const TabletContactSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final heading = content.heading('contact');

    return TabletSection(
      background: AppColors.surface,
      ambientAlignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabletSectionHeader(
            eyebrow: heading.eyebrow,
            title: heading.title,
            accentTitle: heading.accentTitle,
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final sideBySide = constraints.maxWidth >= 820;
              final details = _ContactDetails(content: content);
              const form = _TabletContactForm();
              if (!sideBySide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [details, const SizedBox(height: 24), form],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: details),
                  const SizedBox(width: 24),
                  const Expanded(flex: 7, child: form),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({required this.content});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Have a product in mind? Let’s make it real.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          'Share the scope, the users you are building for, and the outcome you need. I’ll reply with a practical next step.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (content.contactChannels.isNotEmpty) ...[
          const SizedBox(height: 24),
          for (final entry in content.contactChannels.indexed) ...[
            _ContactChannelCard(channel: entry.$2),
            if (entry.$1 != content.contactChannels.length - 1)
              const SizedBox(height: 10),
          ],
        ],
        const SizedBox(height: 24),
        const Text(
          'ELSEWHERE',
          style: TextStyle(
            color: AppColors.textMuted,
            fontFamily: 'monospace',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final social in content.socials)
              AppIconButton(
                size: 42,
                tooltip: social.label,
                onPressed: () => context.read<ExternalLinkCubit>().open(
                  url: social.url,
                  label: social.label,
                  failureTemplate: '{label} could not be opened.',
                ),
                icon: AppIcon(social.iconName, size: 17),
              ),
          ],
        ),
      ],
    );
  }
}

class _ContactChannelCard extends StatelessWidget {
  const _ContactChannelCard({required this.channel});

  final ContactChannel channel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(3),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.read<ExternalLinkCubit>().open(
          url: channel.url,
          label: channel.label,
          failureTemplate: '{label} could not be opened.',
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: AppIcon(
                    channel.iconName,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.label.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      channel.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const AppIcon('external', size: 15, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabletContactForm extends StatelessWidget {
  const _TabletContactForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        return TabletSurface(
          padding: const EdgeInsets.all(24),
          color: AppColors.background,
          accent: true,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactField(
                  key: ValueKey('tablet-name-${state.formRevision}'),
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
                const SizedBox(height: 17),
                _ContactField(
                  key: ValueKey('tablet-email-${state.formRevision}'),
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
                const SizedBox(height: 17),
                _ContactField(
                  key: ValueKey('tablet-subject-${state.formRevision}'),
                  label: 'Subject',
                  hint: 'Flutter project / collaboration',
                  initialValue: state.subject,
                  errorText: state.subjectError,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactSubjectChanged(value),
                  ),
                ),
                const SizedBox(height: 17),
                _ContactField(
                  key: ValueKey('tablet-message-${state.formRevision}'),
                  label: 'Message',
                  hint: 'Tell me about the product and the outcome you need…',
                  initialValue: state.message,
                  errorText: state.messageError,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) => context.read<ContactBloc>().add(
                    ContactMessageChanged(value),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: state.isSubmitting ? 'Sending…' : 'Send message',
                  expanded: true,
                  icon: const AppIcon(
                    'send',
                    size: 16,
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

class _ContactField extends StatelessWidget {
  const _ContactField({
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
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          autofillHints: autofillHints,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5),
          decoration: InputDecoration(hintText: hint, errorText: errorText),
        ),
      ],
    );
  }
}
