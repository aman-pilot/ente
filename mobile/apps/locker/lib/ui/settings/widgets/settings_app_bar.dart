import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";

class SettingsPageScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final double maxWidth;

  const SettingsPageScaffold({
    required this.title,
    this.subtitle,
    required this.children,
    this.maxWidth = double.infinity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: CustomScrollView(
            slivers: [
              HeaderAppBarComponent(title: title, subtitle: subtitle),
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    0,
                    Spacing.lg,
                    Spacing.lg,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(children),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
