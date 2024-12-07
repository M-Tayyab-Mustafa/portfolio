import '../export.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({super.key, required this.title, this.icon, this.color, this.borderRadius = 0.0, this.onTap, this.isSelected = false});
  final String title;
  final Icon? icon;
  final Color? color;
  final double borderRadius;
  final GestureTapCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppHelper.padding_5, vertical: AppHelper.padding_5),
        child: InkWell(
          overlayColor: WidgetStatePropertyAll(color ?? CColors.transparent),
          hoverColor: CColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
          onHover: (value) {
            log(value.toString());
          },
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppHelper.padding_10),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppHelper.padding_5),
                    child: icon,
                  ),
                Text(title).w500(color: isSelected ? CColors.primary : CColors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalDrawer extends StatelessWidget {
  const HorizontalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppHelper.padding_10),
            child: const Text('Muhammad Tayyab').w900(fontSize: 20),
          ),
        ),
        DrawerTile(
          title: 'Home',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
        DrawerTile(
          title: 'About Me',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
        DrawerTile(
          title: 'What I Do',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
        DrawerTile(
          title: 'Portfolio',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
        DrawerTile(
          title: 'My Resume',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
        DrawerTile(
          title: 'Contact Me',
          borderRadius: AppHelper.borderRadiusInfinity,
          onTap: () {},
        ),
      ],
    );
  }
}

class CDrawer extends StatelessWidget {
  const CDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Container()),
          DrawerTile(
            title: 'Home',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          DrawerTile(
            title: 'About Me',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          DrawerTile(
            title: 'What I Do',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          DrawerTile(
            title: 'Portfolio',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          DrawerTile(
            title: 'My Resume',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          DrawerTile(
            title: 'Contact Me',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
