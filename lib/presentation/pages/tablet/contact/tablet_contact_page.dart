import 'package:portfolio/presentation/blocs/contact/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/text_field.dart';
import 'package:portfolio/utils/exports.dart';

class TabletContactPage extends StatelessWidget {
  const TabletContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: context.read<ContactBloc>().formKey,
      child: Padding(
        // Tablet: reduced vertical rhythm, full-width padded container
        padding: context.edgeInsets(vertical: 48, horizontal: 24),
        child: FadeSlide(
          beginOffset: const Offset(0, 50),
          child: HoverCard(
            hoverScale: 1.004,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(14.r),
              ),
              child: Padding(
                padding: context.edgeInsets(
                  horizontal: 32,
                  top: 44,
                  bottom: 36,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeSlide(
                      delay: const Duration(milliseconds: 190),
                      child: Text(
                        'Let\'s build your next mobile app.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontFamily: AppTextStyles.interFontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    FadeSlide(
                      delay: const Duration(milliseconds: 180),
                      child: Padding(
                        padding: context.edgeInsets(top: 8, bottom: 40),
                        child: Text(
                          'Currently open for new opportunities and freelance projects.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),

                    // ── On tablet: stack Name / Email vertically ───────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 260),
                      child: CTextField(
                        hintText: 'John Doe',
                        label: 'Name',
                        validator: Validators.name,
                        controller: context
                            .read<ContactBloc>()
                            .nameTextController,
                      ),
                    ),
                    FadeSlide(
                      delay: const Duration(milliseconds: 290),
                      child: CTextField(
                        hintText: 'john@example.com',
                        label: 'Email',
                        margin: context.edgeInsets(top: 20),
                        validator: Validators.email,
                        controller: context
                            .read<ContactBloc>()
                            .emailTextController,
                      ),
                    ),

                    FadeSlide(
                      delay: const Duration(milliseconds: 320),
                      child: CTextField(
                        hintText: 'Tell me about your project...',
                        margin: context.edgeInsets(top: 20),
                        maxLine: 7,
                        label: 'Message',
                        validator: Validators.message,
                        controller: context
                            .read<ContactBloc>()
                            .messageTextController,
                      ),
                    ),
                    FadeSlide(
                      delay: const Duration(milliseconds: 400),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: HoverCard(
                          child: AppButton(
                            onTap: () => context.read<ContactBloc>().add(
                              const SendMessageEvent(),
                            ),
                            margin: context.edgeInsets(top: 24),
                            // Tablet: full-width button feels more native
                            width: double.infinity,
                            title: 'Send Message',
                          ),
                        ),
                      ),
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
