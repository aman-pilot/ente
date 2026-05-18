import "package:ente_components/ente_components.dart";
import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";
import "package:url_launcher/url_launcher_string.dart";

/// A row of social media icon buttons
class SocialIconsRow extends StatelessWidget {
  const SocialIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedDiscord,
          url: "https://ente.com/discord",
          color: colors.textLight,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedYoutube,
          url: "https://www.youtube.com/@entestudio",
          color: colors.textLight,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedGithub,
          url: "https://github.com/ente-io",
          color: colors.textLight,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedNewTwitter,
          url: "https://twitter.com/enteio",
          color: colors.textLight,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedMastodon,
          url: "https://fosstodon.org/@ente",
          color: colors.textLight,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: HugeIcons.strokeRoundedReddit,
          url: "https://reddit.com/r/enteio",
          color: colors.textLight,
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final dynamic icon;
  final String url;
  final Color color;

  const _SocialIconButton({
    required this.icon,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButtonComponent(
      variant: IconButtonComponentVariant.unfilled,
      shouldSurfaceExecutionStates: false,
      icon: HugeIcon(
        icon: icon,
        color: color,
        size: 20,
      ),
      onTap: () {
        launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
