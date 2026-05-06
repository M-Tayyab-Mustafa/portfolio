import 'package:portfolio/presentation/blocs/contact/_bloc.dart';
import 'package:portfolio/presentation/blocs/shell/_bloc.dart';
import 'package:portfolio/presentation/pages/web/about/page.dart';
import 'package:portfolio/presentation/pages/web/contact/page.dart';
import 'package:portfolio/presentation/pages/web/experience/page.dart';
import 'package:portfolio/presentation/pages/web/projects/page.dart';
import 'package:portfolio/presentation/pages/web/skills/page.dart';
import 'package:portfolio/presentation/widgets/appbar.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/utils/exports.dart';

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
