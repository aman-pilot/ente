import "package:ente_components/ente_components.dart";
import "package:ente_sharing/verify_identity_dialog.dart";
import "package:ente_strings/ente_strings.dart";
import "package:flutter/material.dart";
import "package:locker/services/configuration.dart";
import "package:locker/ui/components/legacy_collections_trash_widget.dart";
import "package:locker/ui/components/usage_card_widget.dart";
import "package:locker/ui/drawer/drawer_title_bar_widget.dart";
import "package:locker/ui/settings/settings_page.dart";

class DrawerPage extends StatelessWidget {
  final ValueNotifier<String?> emailNotifier;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerPage({
    super.key,
    required this.emailNotifier,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;
    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: Container(
        color: colors.backgroundBase,
        child: _getBody(context, colors),
      ),
    );
  }

  Widget _getBody(BuildContext context, ColorTokens colors) {
    final hasLoggedIn = Configuration.instance.hasConfiguredAccount();
    const sectionSpacing = SizedBox(height: 8);
    final List<Widget> contents = [];

    if (hasLoggedIn) {
      contents.add(
        GestureDetector(
          onDoubleTap: () => showVerifyIdentitySheet(
            context,
            self: true,
            config: Configuration.instance,
            title: context.strings.verifyIDLabel,
          ),
          onLongPress: () => showVerifyIdentitySheet(
            context,
            self: true,
            config: Configuration.instance,
            title: context.strings.verifyIDLabel,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                // [AnimatedBuilder] accepts any [Listenable] subtype.
                animation: emailNotifier,
                builder: (BuildContext context, Widget? child) {
                  return Text(
                    emailNotifier.value!,
                    style: TextStyles.body.copyWith(
                      color: colors.textLight,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      contents.addAll([
        sectionSpacing,
        const UsageCardWidget(),
        const SizedBox(height: 24),
        const LegacyCollectionsTrashWidget(),
        const SizedBox(height: 24),
      ]);
    }

    contents.addAll([
      SettingsWidget(hasLoggedIn: hasLoggedIn),
      const Padding(
        padding: EdgeInsets.only(bottom: 60),
      ),
    ]);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DrawerTitleBarWidget(
              scaffoldKey: scaffoldKey,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: contents,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
