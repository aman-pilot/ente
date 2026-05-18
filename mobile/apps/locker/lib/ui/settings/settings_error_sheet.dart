import "package:dio/dio.dart";
import "package:ente_components/ente_components.dart";
import "package:ente_utils/email_util.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:locker/l10n/l10n.dart";

Future<void> showSettingsErrorBottomSheet({
  required BuildContext context,
  required Object? error,
}) async {
  final l10n = context.l10n;
  await showErrorBottomSheetComponent<void>(
    context: context,
    title: l10n.somethingWentWrong,
    message: _settingsErrorMessage(context, error),
    illustration: Image.asset("assets/warning-grey.png"),
    actions: [
      ButtonComponent(
        label: l10n.contactSupport,
        onTap: () async {
          await sendLogs(context, "support@ente.com", postShare: () {});
        },
      ),
    ],
  );
}

String _settingsErrorMessage(BuildContext context, Object? error) {
  final l10n = context.l10n;
  final genericError = l10n.pleaseTryAgain;

  try {
    if (error == null) {
      return genericError;
    }
    if (error is DioException &&
        (error.type == DioExceptionType.unknown ||
            error.type == DioExceptionType.connectionError)) {
      final cause = error.error.toString();
      if (cause.contains("Failed host lookup") ||
          cause.contains("SocketException")) {
        return l10n.checkInternetConnection;
      }
    }
    if (!kDebugMode) {
      return genericError;
    }
    return "$genericError\n\n$error";
  } catch (_) {
    return genericError;
  }
}
