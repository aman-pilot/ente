import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";

class SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SuggestionChip({required this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;

    return FilterChipComponent(
      label: label,
      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedSparkles,
        color: colors.textBase,
        size: 18,
        strokeWidth: 1.6,
      ),
      state: onTap == null
          ? FilterChipComponentState.disabled
          : FilterChipComponentState.unselected,
      onChanged: onTap == null ? null : (_) => onTap!(),
    );
  }
}
