import "dart:async";

import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";

class SettingsItem extends StatelessWidget {
  final dynamic icon;
  final String title;
  final FutureOr<void> Function()? onTap;
  final VoidCallback? onDoubleTap;
  final Widget? trailing;
  final Color? textColor;
  final Color? iconColor;
  final bool showChevron;
  final bool isDestructive;
  final bool selected;
  final bool showOnlyLoadingState;
  final bool shouldSurfaceExecutionStates;

  const SettingsItem({
    this.icon,
    required this.title,
    this.onTap,
    this.onDoubleTap,
    this.trailing,
    this.textColor,
    this.iconColor,
    this.showChevron = true,
    this.isDestructive = false,
    this.selected = false,
    this.showOnlyLoadingState = false,
    this.shouldSurfaceExecutionStates = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;
    final effectiveTextColor =
        isDestructive ? colors.warning : textColor ?? colors.textBase;
    final effectiveIconColor =
        isDestructive ? colors.warning : iconColor ?? colors.textLight;

    final item = MenuComponent(
      title: title,
      titleColor: effectiveTextColor,
      selected: selected,
      leading: icon == null
          ? null
          : HugeIcon(
              icon: icon,
              color: effectiveIconColor,
              size: 24,
              strokeWidth: 1.6,
            ),
      trailing: trailing ??
          (showChevron
              ? HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight02,
                  color: colors.textLight,
                  size: 18,
                  strokeWidth: 1.6,
                )
              : null),
      iconColor: effectiveIconColor,
      showOnlyLoadingState: showOnlyLoadingState,
      shouldSurfaceExecutionStates: shouldSurfaceExecutionStates,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
    );
    return item;
  }
}
