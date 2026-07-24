import "dart:io";

import "package:ente_components/ente_components.dart";
import 'package:ente_pure_utils/ente_pure_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import "package:photos/generated/l10n.dart";
import 'package:photos/models/freeable_space_info.dart';
import "package:photos/ui/notification/toast.dart";
import "package:photos/ui/settings/components/settings_page_scaffold.dart";
import 'package:photos/utils/delete_file_util.dart';

class FreeSpacePage extends StatefulWidget {
  final FreeableSpaceInfo status;
  final bool clearSpaceForFolder;

  const FreeSpacePage(
    this.status, {
    super.key,
    this.clearSpaceForFolder = false,
  });

  @override
  State<FreeSpacePage> createState() => _FreeSpacePageState();
}

class _FreeSpacePageState extends State<FreeSpacePage> {
  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: AppLocalizations.of(context).freeUpSpace,
      padding: EdgeInsets.zero,
      children: [_getBody()],
    );
  }

  Widget _getBody() {
    Logger("FreeSpacePage").info(
      "Number of uploaded files: " + widget.status.localIDs.length.toString(),
    );
    Logger(
      "FreeSpacePage",
    ).info("Space consumed: " + widget.status.size.toString());
    return _getWidget(widget.status);
  }

  Widget _getWidget(FreeableSpaceInfo status) {
    final l10n = AppLocalizations.of(context);
    final count = status.localIDs.length;
    final formattedCount = NumberFormat().format(count);
    final String textMessage = widget.clearSpaceForFolder
        ? l10n.filesBackedUpInAlbum(
            count: count,
            formattedNumber: formattedCount,
          )
        : l10n.filesBackedUpFromDevice(
            count: count,
            formattedNumber: formattedCount,
          );
    return Column(
      children: [
        const SizedBox(height: Spacing.xxl),
        Image.asset("assets/empty_state_trash.png", width: 194, height: 161),
        const SizedBox(height: Spacing.xxl),
        _InformationRow(icon: Icons.cloud_done_outlined, text: textMessage),
        const SizedBox(height: Spacing.xxl),
        _InformationRow(
          icon: Icons.delete_outline,
          text: l10n.freeUpSpaceSaving(
            count: count,
            formattedSize: formatBytes(status.size),
          ),
        ),
        const SizedBox(height: Spacing.xxl),
        _InformationRow(
          icon: Icons.devices_outlined,
          text: l10n.freeUpAccessPostDelete(count: count),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
          child: ButtonComponent(
            label: l10n.freeUpAmount(sizeInMBorGB: formatBytes(status.size)),
            shouldSurfaceExecutionStates: false,
            onTap: () async {
              await _showConfirmFreeSpaceSheet(context, status);
            },
          ),
        ),
        const SizedBox(height: Spacing.xxl),
      ],
    );
  }

  Future<void> _freeStorage(FreeableSpaceInfo status) async {
    bool isSuccess = await deleteLocalFiles(context, status.localIDs);

    if (isSuccess == false) {
      if (!mounted) return;
      isSuccess = await deleteLocalFilesAfterRemovingAlreadyDeletedIDs(
        context,
        status.localIDs,
      );
    }

    if (isSuccess == false && Platform.isAndroid) {
      if (!mounted) return;
      isSuccess = await retryFreeUpSpaceAfterRemovingAssetsNonExistingInDisk(
        context,
      );
    }

    if (isSuccess) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!mounted) return;
      showToast(context, AppLocalizations.of(context).couldNotFreeUpSpace);
    }
  }

  Future<void> _showConfirmFreeSpaceSheet(
    BuildContext context,
    FreeableSpaceInfo status,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showBottomSheetComponent(
      context: context,
      builder: (_) => BottomSheetComponent(
        title: l10n.areYouSure,
        message: l10n.freeUpDeviceSpaceConfirmDesc(
          count: status.localIDs.length,
        ),
        illustration: Image.asset("assets/warning-red.png"),
        actions: [
          ButtonComponent(
            label: l10n.yesDelete,
            variant: .critical,
            onTap: () async {
              Navigator.of(context).pop();
              await _freeStorage(status);
            },
          ),
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.componentColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: Text(
              text,
              style: TextStyles.body.copyWith(color: colors.textBase),
            ),
          ),
        ],
      ),
    );
  }
}
