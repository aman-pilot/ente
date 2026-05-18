import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";
import "package:locker/ui/settings/pages/settings_search_page.dart";

class DrawerTitleBarWidget extends StatelessWidget {
  const DrawerTitleBarWidget({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButtonComponent(
              tooltip: "Close",
              variant: IconButtonComponentVariant.unfilled,
              shouldSurfaceExecutionStates: false,
              icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
              onTap: () {
                scaffoldKey.currentState?.closeDrawer();
              },
            ),
            IconButtonComponent(
              variant: IconButtonComponentVariant.unfilled,
              shouldSurfaceExecutionStates: false,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSearch01,
                color: colors.textBase,
                size: 20,
                strokeWidth: 1.75,
              ),
              onTap: () => _openSearch(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsSearchPage()),
    );
  }
}
