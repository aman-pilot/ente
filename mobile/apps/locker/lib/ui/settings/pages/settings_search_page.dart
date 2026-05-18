import "dart:async";
import "dart:io";

import "package:ente_accounts/services/user_service.dart";
import "package:ente_components/ente_components.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";
import "package:locker/l10n/l10n.dart";
import "package:locker/services/configuration.dart";
import "package:locker/services/update_service.dart";
import "package:locker/ui/settings/pages/about_page.dart";
import "package:locker/ui/settings/pages/account_settings_page.dart";
import "package:locker/ui/settings/pages/general_settings_page.dart";
import "package:locker/ui/settings/pages/security_settings_page.dart";
import "package:locker/ui/settings/pages/support_page.dart";
import "package:locker/ui/settings/pages/theme_settings_page.dart";
import "package:locker/ui/settings/widgets/suggestion_chip.dart";

class SettingsSearchPage extends StatefulWidget {
  const SettingsSearchPage({super.key});

  @override
  State<SettingsSearchPage> createState() => _SettingsSearchPageState();
}

class _SettingsSearchPageState extends State<SettingsSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  String _searchQuery = "";
  List<_SearchableSetting> _searchResults = [];
  late List<_SearchableSetting> _allSettings;
  late List<_SearchableSetting> _suggestions;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allSettings = _buildSettingsList(context);
    _suggestions = _getDefaultSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  List<_SearchableSetting> _buildSettingsList(BuildContext context) {
    final l10n = context.l10n;
    final hasLoggedIn = Configuration.instance.hasConfiguredAccount();

    return [
      if (hasLoggedIn) ...[
        _SearchableSetting(
          title: l10n.account,
          category: l10n.account,
          page: const AccountSettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.changeEmail,
          category: l10n.account,
          page: const AccountSettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.recoveryKey,
          category: l10n.account,
          page: const AccountSettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.changePassword,
          category: l10n.account,
          page: const AccountSettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.deleteAccount,
          category: l10n.account,
          page: const AccountSettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.security,
          category: l10n.security,
          page: const SecuritySettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.emailVerificationToggle,
          category: l10n.security,
          page: const SecuritySettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.passkey,
          category: l10n.security,
          page: const SecuritySettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.appLock,
          category: l10n.security,
          page: const SecuritySettingsPage(),
        ),
        _SearchableSetting(
          title: l10n.viewActiveSessions,
          category: l10n.security,
          page: const SecuritySettingsPage(),
        ),
        if (Platform.isAndroid || kDebugMode)
          _SearchableSetting(
            title: l10n.appearance,
            category: l10n.appearance,
            page: const ThemeSettingsPage(),
          ),
      ],
      _SearchableSetting(
        title: l10n.general,
        category: l10n.general,
        page: const GeneralSettingsPage(),
      ),
      _SearchableSetting(
        title: l10n.selectLanguage,
        category: l10n.general,
        page: const GeneralSettingsPage(),
      ),
      _SearchableSetting(
        title: l10n.helpAndSupport,
        category: l10n.helpAndSupport,
        page: const SupportPage(),
      ),
      _SearchableSetting(
        title: l10n.contactSupport,
        category: l10n.helpAndSupport,
        page: const SupportPage(),
      ),
      _SearchableSetting(
        title: l10n.help,
        category: l10n.helpAndSupport,
        page: const SupportPage(),
      ),
      _SearchableSetting(
        title: l10n.suggestFeatures,
        category: l10n.helpAndSupport,
        page: const SupportPage(),
      ),
      _SearchableSetting(
        title: l10n.reportABug,
        category: l10n.helpAndSupport,
        page: const SupportPage(),
      ),
      _SearchableSetting(
        title: l10n.aboutUs,
        category: l10n.aboutUs,
        page: const AboutPage(),
      ),
      _SearchableSetting(
        title: l10n.weAreOpenSource,
        category: l10n.aboutUs,
        page: const AboutPage(),
      ),
      _SearchableSetting(
        title: l10n.privacy,
        category: l10n.aboutUs,
        page: const AboutPage(),
      ),
      _SearchableSetting(
        title: l10n.termsOfServicesTitle,
        category: l10n.aboutUs,
        page: const AboutPage(),
      ),
      if (UpdateService.instance.isIndependent())
        _SearchableSetting(
          title: l10n.checkForUpdates,
          category: l10n.aboutUs,
          page: const AboutPage(),
        ),
      if (hasLoggedIn)
        _SearchableSetting(
          title: l10n.logout,
          category: l10n.logout,
          onTap: _onLogoutTapped,
        ),
    ];
  }

  List<_SearchableSetting> _getDefaultSuggestions() {
    final l10n = context.l10n;
    final hasLoggedIn = Configuration.instance.hasConfiguredAccount();

    return _allSettings.where((s) {
      if (hasLoggedIn) {
        return s.title == l10n.appLock ||
            s.title == l10n.appearance ||
            s.title == l10n.selectLanguage ||
            s.title == l10n.privacy;
      } else {
        return s.title == l10n.selectLanguage ||
            s.title == l10n.help ||
            s.title == l10n.privacy;
      }
    }).toList();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
          if (_searchQuery.isEmpty) {
            _searchResults = [];
          } else {
            _searchResults = _allSettings.where((setting) {
              return _containsQuery(setting.title, _searchQuery) ||
                  _containsQuery(setting.category, _searchQuery);
            }).toList();
          }
        });
      }
    });
  }

  bool _containsQuery(String text, String query) {
    if (text.isEmpty) return false;
    final lowerText = text.toLowerCase();
    if (lowerText.contains(query)) {
      return true;
    }
    final words = lowerText.split(RegExp(r'[\s\-_\.]+'));
    return words.any((word) => word.startsWith(query));
  }

  void _onSettingTapped(_SearchableSetting setting) {
    if (setting.onTap != null) {
      setting.onTap!();
    } else if (setting.page != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => setting.page!));
    }
  }

  void _onLogoutTapped() {
    showBottomSheetComponent<void>(
      context: context,
      builder: (sheetContext) => BottomSheetComponent(
        title: context.l10n.warning,
        message: context.l10n.areYouSureYouWantToLogout,
        illustration: Image.asset("assets/warning-grey.png"),
        actions: [
          ButtonComponent(
            label: context.l10n.yesLogout,
            variant: ButtonComponentVariant.critical,
            onTap: () async {
              Navigator.of(sheetContext).pop();
              await UserService.instance.logout(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextInputComponent(
                controller: _searchController,
                focusNode: _focusNode,
                hintText: l10n.searchSettings,
                onChanged: _onSearchChanged,
                prefix: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: colors.textLight,
                  size: 20,
                  strokeWidth: 1.75,
                ),
                suffix: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: colors.textLight,
                    size: 20,
                    strokeWidth: 1.75,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildSuggestions(l10n)
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(AppLocalizations l10n) {
    final colors = context.componentColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.suggestions,
            style: TextStyles.body.copyWith(color: colors.textBase),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions
                .map(
                  (setting) => SuggestionChip(
                    label: setting.title,
                    onTap: () => _onSettingTapped(setting),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final colors = context.componentColors;

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noResultsFound,
          style: TextStyles.body.copyWith(color: colors.textLight),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final setting = _searchResults[index];
        return MenuComponent(
          title: setting.title,
          subtitle: setting.title != setting.category ? setting.category : null,
          trailing: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight02,
            color: colors.textLight,
            size: 18,
            strokeWidth: 1.6,
          ),
          onTap: () => _onSettingTapped(setting),
        );
      },
    );
  }
}

class _SearchableSetting {
  final String title;
  final String category;
  final Widget? page;
  final VoidCallback? onTap;

  const _SearchableSetting({
    required this.title,
    required this.category,
    this.page,
    this.onTap,
  });
}
