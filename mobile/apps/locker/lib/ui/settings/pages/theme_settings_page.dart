import "package:adaptive_theme/adaptive_theme.dart";
import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";
import "package:locker/l10n/l10n.dart";
import "package:locker/ui/settings/widgets/settings_app_bar.dart";
import "package:locker/ui/settings/widgets/settings_item.dart";

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  AdaptiveThemeMode? currentThemeMode;

  @override
  void initState() {
    super.initState();
    AdaptiveTheme.getThemeMode().then((value) {
      currentThemeMode = value ?? AdaptiveThemeMode.system;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.componentColors;

    return SettingsPageScaffold(
      title: l10n.theme,
      children: [
        SettingsItem(
          title: l10n.systemTheme,
          selected: currentThemeMode == AdaptiveThemeMode.system,
          showChevron: false,
          trailing: currentThemeMode == AdaptiveThemeMode.system
              ? Icon(Icons.check, color: colors.primary)
              : null,
          onTap: () => _setTheme(AdaptiveThemeMode.system),
        ),
        const SizedBox(height: 8),
        SettingsItem(
          title: l10n.lightTheme,
          selected: currentThemeMode == AdaptiveThemeMode.light,
          showChevron: false,
          trailing: currentThemeMode == AdaptiveThemeMode.light
              ? Icon(Icons.check, color: colors.primary)
              : null,
          onTap: () => _setTheme(AdaptiveThemeMode.light),
        ),
        const SizedBox(height: 8),
        SettingsItem(
          title: l10n.darkTheme,
          selected: currentThemeMode == AdaptiveThemeMode.dark,
          showChevron: false,
          trailing: currentThemeMode == AdaptiveThemeMode.dark
              ? Icon(Icons.check, color: colors.primary)
              : null,
          onTap: () => _setTheme(AdaptiveThemeMode.dark),
        ),
      ],
    );
  }

  Future<void> _setTheme(AdaptiveThemeMode themeMode) async {
    AdaptiveTheme.of(context).setThemeMode(themeMode);
    currentThemeMode = themeMode;
    if (mounted) {
      setState(() {});
    }
  }
}
