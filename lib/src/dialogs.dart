import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import 'button.dart';

part 'configs.dart';
part 'dialog_alert.dart';
part 'dialog_editor.dart';
part 'dialog_loading.dart';
part 'dialog_message.dart';
part 'dialog_snack_bar.dart';
part 'type.dart';

// Typedef for building dialog configurations dynamically
typedef DialogConfigBuilder<T extends DialogConfig> = T Function(
  BuildContext context,
);

// Class for managing various types of dialogs and snack bars
class Dialogs {
  final Map<DialogType, dynamic> _tags = {};

  DialogConfigBuilder<AlertDialogConfig>? alertDialogConfig;
  DialogConfigBuilder<EditableDialogConfig>? editableDialogConfig;
  DialogConfigBuilder<LoadingDialogConfig>? loadingDialogConfig;
  DialogConfigBuilder<MessageDialogConfig>? messageDialogConfig;
  DialogConfigBuilder<SnackBarConfig>? snackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? errorSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? infoSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? waitingSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? warningSnackBarConfig;

  Dialogs._();

  static Dialogs? _i;

  static Dialogs get i => _i ??= Dialogs._();

  // Initialize the dialog configurations
  static init({
    DialogConfigBuilder<AlertDialogConfig>? alertDialogConfig,
    DialogConfigBuilder<EditableDialogConfig>? editableDialogConfig,
    DialogConfigBuilder<LoadingDialogConfig>? loadingDialogConfig,
    DialogConfigBuilder<MessageDialogConfig>? messageDialogConfig,
    DialogConfigBuilder<SnackBarConfig>? snackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? errorSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? infoSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? waitingSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? warningSnackBarConfig,
  }) {
    i.alertDialogConfig = alertDialogConfig ?? i.alertDialogConfig;
    i.editableDialogConfig = editableDialogConfig ?? i.editableDialogConfig;
    i.loadingDialogConfig = loadingDialogConfig ?? i.loadingDialogConfig;
    i.messageDialogConfig = messageDialogConfig ?? i.messageDialogConfig;
    i.snackBarConfig = snackBarConfig ?? i.snackBarConfig;
    i.errorSnackBarConfig = errorSnackBarConfig ?? i.errorSnackBarConfig;
    i.infoSnackBarConfig = infoSnackBarConfig ?? i.infoSnackBarConfig;
    i.waitingSnackBarConfig = waitingSnackBarConfig ?? i.waitingSnackBarConfig;
    i.warningSnackBarConfig = warningSnackBarConfig ?? i.warningSnackBarConfig;
  }

  /// Shows an alert dialog.
  ///
  /// Example:
  /// ```dart
  /// await Dialogs.i.alert(context, title: "Alert", message: "This is an alert message");
  /// ```
  Future<bool> alert(BuildContext context, {String? title, String? message}) {
    final config =
        alertDialogConfig?.call(context) ?? const AlertDialogConfig();
    if (config.material) {
      return showDialog(
        context: context,
        builder: (_) => AndrossyAlertDialog(
          config: config,
          title: title,
          message: message,
        ),
      ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
    } else {
      return showCupertinoDialog(
        context: context,
        builder: (_) => AndrossyAlertDialog(
          config: config,
          title: title,
          message: message,
        ),
      ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
    }
  }

  /// Shows an editable dialog for input.
  ///
  /// Example:
  /// ```dart
  /// String result = await Dialogs.i.editor(context, title: "Edit", text: "Initial text", hint: "Enter text");
  /// ```
  Future<String> editor(BuildContext context,
      {String? title, String? text, String? hint}) {
    final config =
        editableDialogConfig?.call(context) ?? const EditableDialogConfig();
    if (config.material) {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AndrossyEditableDialog(
          config: config,
          title: title,
          text: text,
          hint: hint,
        ),
      ).onError((_, __) => null).then((_) => _ is String ? _ : "");
    } else {
      return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AndrossyEditableDialog(
          config: config,
          title: title,
          text: text,
          hint: hint,
        ),
      ).onError((_, __) => null).then((_) => _ is String ? _ : "");
    }
  }

  /// Checks if loader mode is active.
  ///
  /// Example:
  /// ```dart
  /// bool isLoading = Dialogs.i.isLoaderMode;
  /// ```
  bool get isLoaderMode => _tags[DialogType.loader] ?? false;

  /// Shows or hides a loader dialog.
  ///
  /// Example:
  /// ```dart
  /// bool showLoader = true; // Set to false to hide loader
  /// await Dialogs.i.loader(context, status: showLoader);
  /// ```
  Future<bool> loader(BuildContext context, {bool status = true}) {
    final config =
        loadingDialogConfig?.call(context) ?? const LoadingDialogConfig();
    if (isLoaderMode && status) return Future.value(false);
    if (!isLoaderMode && !status) return Future.value(false);
    if (status) {
      _tags[DialogType.loader] = true;
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AndrossyLoadingDialog(config: config),
      ).onError((_, __) => null).then((value) {
        _tags.remove(DialogType.loader);
        return value is bool ? value : false;
      });
    } else {
      if (isLoaderMode) {
        if (Navigator.canPop(context)) {
          _tags.remove(DialogType.loader);
          Navigator.pop(context);
        }
      }
      return Future.value(false);
    }
  }

  /// Shows a message dialog.
  ///
  /// Example:
  /// ```dart
  /// await Dialogs.i.message(context, "This is a message", title: "Message");
  /// ```
  Future<bool> message(BuildContext context, String? message, {String? title}) {
    final oldMessage = _tags[DialogType.message];
    if (message != oldMessage) {
      final config =
          messageDialogConfig?.call(context) ?? const MessageDialogConfig();
      _tags[DialogType.message] = message;
      if (config.material) {
        return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => _MaterialMessageDialog(
            message: message,
            title: title,
            config: config,
          ),
        ).onError((_, __) => null).then((_) {
          _tags.remove(DialogType.message);
          return _ is bool ? _ : false;
        });
      } else {
        return showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => _CupertinoMessageDialog(
            message: message,
            title: title,
            config: config,
          ),
        ).onError((_, __) => null).then((_) {
          _tags.remove(DialogType.message);
          return _ is bool ? _ : false;
        });
      }
    } else {
      return Future.value(false);
    }
  }

  /// Private function to show a custom SnackBar.
  void _snackBar(
    BuildContext context,
    String? title,
    String? message,
    SnackBarConfig config,
    DialogType type,
  ) {
    final oldMessage = _tags[type];
    if (message != oldMessage) {
      final snackBar = SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: _SnackBar(
          config: config,
          title: title,
          message: message,
        ),
      );
      _tags[type] = message;
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
        _tags.remove(type);
      });
    }
  }

  /// Shows a snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBar(context, "This is a snack bar message");
  /// ```
  void snackBar(
    BuildContext context, {
    String? message,
    String? title,
  }) {
    _snackBar(
      context,
      title,
      message,
      snackBarConfig?.call(context) ?? const SnackBarConfig(),
      DialogType.snackBar,
    );
  }

  /// Shows an error-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarError(context, "An error occurred");
  /// ```
  void snackBarError(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    _snackBar(
      context,
      title,
      message,
      errorSnackBarConfig?.call(context) ?? const SnackBarConfig(),
      DialogType.snackBarError,
    );
  }

  /// Shows a info-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarInfo(context, "Warning: Something went wrong");
  /// ```
  void snackBarInfo(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    _snackBar(
      context,
      title,
      message,
      infoSnackBarConfig?.call(context) ?? const SnackBarConfig(),
      DialogType.snackBarWarning,
    );
  }

  /// Shows a waiting-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarWaiting(context, "Warning: Something went wrong");
  /// ```
  void snackBarWaiting(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    _snackBar(
      context,
      title,
      message,
      waitingSnackBarConfig?.call(context) ?? const SnackBarConfig(),
      DialogType.snackBarWaiting,
    );
  }

  /// Shows a warning-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarWarning(context, "Warning: Something went wrong");
  /// ```
  void snackBarWarning(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    _snackBar(
      context,
      title,
      message,
      warningSnackBarConfig?.call(context) ?? const SnackBarConfig(),
      DialogType.snackBarWarning,
    );
  }
}
