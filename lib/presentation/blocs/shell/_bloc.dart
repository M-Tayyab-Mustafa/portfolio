import 'package:portfolio/utils/exports.dart';

part '_event.dart';
part '_state.dart';

class ShellBloc extends Bloc<ShellEvent, ShellState> {
  ScrollController? _scrollController;

  ShellBloc() : super(const ShellState()) {
    on<ShellStarted>(_onStarted);
    on<ShellRouteChanged>(_onRouteChanged);
    on<ShellScrolled>(_onScrolled);
    on<ShellSectionSelected>(_onSectionSelected);
  }

  GoRouter? _router;
  Timer? _debounce;
  Timer? _programmaticScrollTimer;
  bool _isProgrammaticScroll = false;
  String? _scrollDrivenRoutePath;

  static final Map<String, GlobalKey> _sections = {
    AppRoutes.about: SectionService.about,
    AppRoutes.skills: SectionService.skills,
    AppRoutes.experience: SectionService.experience,
    AppRoutes.projects: SectionService.projects,
    AppRoutes.contact: SectionService.contact,
  };

  void _onScroll() => add(const ShellScrolled());

  void _onStarted(ShellStarted event, Emitter<ShellState> emit) {
    _scrollController = event.scrollController;
    _scrollController!.addListener(_onScroll);
    _router = event.router;
    event.router.routerDelegate.addListener(_onRouteChange);
    add(const ShellRouteChanged());
  }

  void _onRouteChanged(ShellRouteChanged event, Emitter<ShellState> emit) {
    final path = _router?.routerDelegate.currentConfiguration.uri.path;
    if (path == null) return;

    final key = SectionService.fromRoute(path);
    if (key == null) return;

    emit(state.copyWith(currentRoute: path));

    final isScrollDrivenRouteChange = _scrollDrivenRoutePath == path;
    _scrollDrivenRoutePath = null;

    if (isScrollDrivenRouteChange) {
      return;
    }

    _isProgrammaticScroll = true;
    _programmaticScrollTimer?.cancel();

    SectionService.scrollToSection(key).whenComplete(() {
      _programmaticScrollTimer?.cancel();
      _programmaticScrollTimer = Timer(const Duration(milliseconds: 500), () {
        _isProgrammaticScroll = false;
      });
    });
  }

  void _onScrolled(ShellScrolled event, Emitter<ShellState> emit) {
    if (_isProgrammaticScroll) return;

    double height = Constants.getHeight(_sections[state.currentRoute]!);
    final newRoute = _getActiveSection(viewportHeight: height);

    if (newRoute == null || newRoute == state.currentRoute) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      _scrollDrivenRoutePath = newRoute;
      _router?.go(newRoute);
    });

    emit(state.copyWith(currentRoute: newRoute));
  }

  void _onSectionSelected(
    ShellSectionSelected event,
    Emitter<ShellState> emit,
  ) {
    if (event.route == state.currentRoute) return;

    _debounce?.cancel();
    _scrollDrivenRoutePath = null;
    emit(state.copyWith(currentRoute: event.route));
    _router?.go(event.route);
  }

  String? _getActiveSection({double viewportHeight = 0}) {
    final topZone = viewportHeight * 0.05;
    final bottomZone = viewportHeight * 0.95;

    String? active;
    double bestScore = 0;

    for (final entry in _sections.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject();
      if (box is! RenderBox) continue;

      final position = box.localToGlobal(Offset.zero);
      final sectionTop = position.dy;
      final sectionBottom = position.dy + box.size.height;
      final visibleTop = sectionTop.clamp(topZone, bottomZone);
      final visibleBottom = sectionBottom.clamp(topZone, bottomZone);
      final visibleHeight = visibleBottom - visibleTop;

      if (visibleHeight > bestScore) {
        bestScore = visibleHeight;
        active = entry.key;
      }
    }

    return active;
  }

  void _onRouteChange() => add(const ShellRouteChanged());

  @override
  Future<void> close() {
    _router?.routerDelegate.removeListener(_onRouteChange);
    _debounce?.cancel();
    _programmaticScrollTimer?.cancel();
    _scrollController?.removeListener(_onScroll);
    return super.close();
  }
}
