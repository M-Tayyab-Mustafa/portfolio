import 'package:portfolio/presentation/blocs/contact/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/text_field.dart';
import 'package:portfolio/utils/exports.dart';

class WebContactPage extends StatelessWidget {
  const WebContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: context.read<ContactBloc>().formKey,
      child: Padding(
        padding: context.edgeInsets(vertical: 70),
        child: FadeSlide(
          beginOffset: const Offset(0, 50),
          child: HoverCard(
            hoverScale: 1.004,
            child: Card(
              child: SizedBox(
                width: 800.w,
                child: Padding(
                  padding: context.edgeInsets(
                    horizontal: 80,
                    top: 60,
                    bottom: 48,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeSlide(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          'Let\'s build your next mobile app.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontFamily: AppTextStyles.interFontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      FadeSlide(
                        delay: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: context.edgeInsets(top: 8, bottom: 56),
                          child: Text(
                            'Currently open for new opportunities and freelance projects.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ),
                      ),
                      FadeSlide(
                        delay: const Duration(milliseconds: 380),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: CTextField(
                                hintText: 'John Doe',
                                label: 'Name',
                                validator: Validators.name,
                                controller: context
                                    .read<ContactBloc>()
                                    .nameTextController,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 5,
                              child: CTextField(
                                hintText: 'john@example.com',
                                label: 'Email',
                                validator: Validators.email,
                                controller: context
                                    .read<ContactBloc>()
                                    .emailTextController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeSlide(
                        delay: const Duration(milliseconds: 460),
                        child: CTextField(
                          hintText: 'Tell me about your project...',
                          margin: context.edgeInsets(top: 28),
                          maxLine: 8,
                          label: 'Message',
                          validator: Validators.message,
                          controller: context
                              .read<ContactBloc>()
                              .messageTextController,
                        ),
                      ),
                      FadeSlide(
                        delay: const Duration(milliseconds: 540),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: HoverCard(
                            child: AppButton(
                              onTap: () => context.read<ContactBloc>().add(
                                const SendMessageEvent(),
                              ),
                              margin: context.edgeInsets(top: 28),
                              width: 200.w,
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
      ),
    );
  }
}
