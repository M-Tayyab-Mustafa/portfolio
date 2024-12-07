import '../../export.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CDrawer(),
      appBar: AppHelper.instance.isMobile(context) ? AppBar() : null,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              if (!AppHelper.instance.isMobile(context)) const HorizontalDrawer(),
            ],
          );
        },
      ),
    );
  }
}
