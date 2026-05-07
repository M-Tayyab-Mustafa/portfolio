import 'package:portfolio/presentation/blocs/shell/_bloc.dart';
import 'package:portfolio/presentation/widgets/appbar.dart';
import 'package:portfolio/presentation/widgets/drawer.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/utils/exports.dart';

/// Web Layout
import 'package:portfolio/presentation/pages/web/about/web_about_page.dart';
import 'package:portfolio/presentation/pages/web/contact/web_contact_page.dart';
import 'package:portfolio/presentation/pages/web/experience/web_experience_page.dart';
import 'package:portfolio/presentation/pages/web/projects/web_projects_page.dart';
import 'package:portfolio/presentation/pages/web/skills/web_skills_page.dart';

/// Tablet Layout
import 'package:portfolio/presentation/pages/tablet/about/tablet_about_page.dart';
import 'package:portfolio/presentation/pages/tablet/contact/tablet_contact_page.dart';
import 'package:portfolio/presentation/pages/tablet/experience/tablet_experience_page.dart';
import 'package:portfolio/presentation/pages/tablet/projects/tablet_projects_page.dart';
import 'package:portfolio/presentation/pages/tablet/skills/tablet_skills_page.dart';

/// Mobile Layout
import 'package:portfolio/presentation/pages/mobile/about/mobile_about_page.dart';
import 'package:portfolio/presentation/pages/mobile/experience/mobile_experience_page.dart';
import 'package:portfolio/presentation/pages/mobile/projects/mobile_projects_page.dart';
import 'package:portfolio/presentation/pages/mobile/skills/mobile_skills_page.dart';
import 'package:portfolio/presentation/pages/mobile/contact/mobile_contact_page.dart';

part 'mobile_layout.dart';
part 'tablet_layout.dart';
part 'web_layout.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  late final ShellBloc _shellBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _shellBloc = context.read<ShellBloc>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _shellBloc.add(
        ShellStarted(
          router: GoRouter.of(context),
          scrollController: _scrollController,
        ),
      );
    });
  }

  @override
  void dispose() {
    _shellBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: CImage(
              path: AppThemeScope.isDark(context)
                  ? Constants.darkBackground
                  : Constants.lightBackground,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              CSliverAppBar(),
              SliverToBoxAdapter(child: _buildBody()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return const MobileLayout();
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return const TabletLayout();
    } else {
      return const WebLayout();
    }
  }
}
