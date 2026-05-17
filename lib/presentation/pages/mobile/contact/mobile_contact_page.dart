import 'package:portfolio/presentation/blocs/contact/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/text_field.dart';
import 'package:portfolio/utils/exports.dart';

class MobileContactPage extends StatelessWidget {
  const MobileContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: context.read<ContactBloc>().formKey,
      child: Padding(
        // Mobile: tighter outer padding
        padding: context.edgeInsets(vertical: 32, horizontal: 16),
        child: FadeSlide(
          beginOffset: const Offset(0, 40),
          child: HoverCard(
            hoverScale: 1.002,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12.r),
              ),
              child: Padding(
                padding: context.edgeInsets(
                  horizontal: 20,
                  top: 32,
                  bottom: 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Heading ──────────────────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 160),
                      child: Text(
                        'Let\'s build your next mobile app.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          // Mobile: one step smaller than headlineMedium
                          fontSize: 20.sp,
                          height: 1.3,
                        ),
                      ),
                    ),

                    // ── Subtitle ─────────────────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: context.edgeInsets(top: 8, bottom: 28),
                        child: Text(
                          'Currently open for new opportunities and freelance projects.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: cs.onSurfaceVariant,
                                height: 1.5,
                              ),
                        ),
                      ),
                    ),

                    // ── Name ─────────────────────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 240),
                      child: CTextField(
                        hintText: 'John Doe',
                        label: 'Name',
                        validator: Validators.name,
                        controller: context
                            .read<ContactBloc>()
                            .nameTextController,
                      ),
                    ),

                    // ── Email ────────────────────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 270),
                      child: CTextField(
                        hintText: 'john@example.com',
                        label: 'Email',
                        margin: context.edgeInsets(top: 16),
                        validator: Validators.email,
                        controller: context
                            .read<ContactBloc>()
                            .emailTextController,
                      ),
                    ),

                    // ── Message ──────────────────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 300),
                      child: CTextField(
                        hintText: 'Tell me about your project...',
                        margin: context.edgeInsets(top: 16),
                        // Mobile: 5 lines instead of 7 — fits without scrolling
                        maxLine: 5,
                        label: 'Message',
                        validator: Validators.message,
                        controller: context
                            .read<ContactBloc>()
                            .messageTextController,
                      ),
                    ),

                    // ── Submit – full width ───────────────────────────────
                    FadeSlide(
                      delay: const Duration(milliseconds: 380),
                      child: HoverCard(
                        child: AppButton(
                          onTap: () => context.read<ContactBloc>().add(
                            const SendMessageEvent(),
                          ),
                          margin: context.edgeInsets(top: 20),
                          width: double.infinity,
                          title: 'Send Message',
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
