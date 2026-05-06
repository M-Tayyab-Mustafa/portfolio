import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:portfolio/presentation/widgets/loader.dart';
import 'package:portfolio/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

part '_event.dart';
part '_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final messageTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static final serviceId = 'service_2qn0kbl';
  static final templateId = 'template_je37up9';
  static final publicKey = 'mMDGCdpkwFOjjGdut';
  static final privateKey = 'f6j7Pt_e6NxI6nM05v-a6';

  ContactBloc() : super(const ContactState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<GitHubEvent>(_onGitHubEvent);
    on<LinkedinEvent>(_onLinkedinEvent);
    on<EmailEvent>(_onEmailEvent);
  }

  Future<void> _onSendMessage(SendMessageEvent event, emit) async {
    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      EasyLoader.show();
      final templateParams = {
        'from_name': nameTextController.text.trim(),
        'reply_to': emailTextController.text.trim(),
        'message': messageTextController.text.trim(),
      };

      await emailjs.send(
        serviceId,
        templateId,
        templateParams,
        emailjs.Options(publicKey: publicKey, privateKey: privateKey),
      );

      EasyLoader.hide();
      nameTextController.clear();
      emailTextController.clear();
      messageTextController.clear();
      formKey.currentState?.reset();
    } catch (e) {
      EasyLoader.hide();
      Logger.log("EmailJS Error: $e");
    }
  }

  Future<void> _onGitHubEvent(GitHubEvent event, Emitter emit) async {
    final Uri githubUri = Uri.parse('https://github.com/M-Tayyab-Mustafa');

    await launchUrl(githubUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _onLinkedinEvent(LinkedinEvent event, Emitter emit) async {
    final Uri linkedinUri = Uri.parse(
      'https://www.linkedin.com/in/muhammad-tayyab-a34b68295/',
    );

    await launchUrl(linkedinUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _onEmailEvent(EmailEvent event, emit) async {
    final Uri gmailUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=m.tayyabmustafa.joiya@gmail.com,',
    );

    await launchUrl(gmailUri);
  }

  @override
  Future<void> close() {
    nameTextController.dispose();
    emailTextController.dispose();
    messageTextController.dispose();
    return super.close();
  }
}
