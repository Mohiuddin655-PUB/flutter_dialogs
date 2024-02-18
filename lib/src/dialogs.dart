import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button.dart';

part 'configs.dart';
part 'dialog_alert.dart';
part 'dialog_editor.dart';
part 'dialog_loading.dart';
part 'dialog_message.dart';
part 'dialog_snack_bar.dart';
part 'type.dart';

class Dialogs {
  final Map<DialogType, dynamic> _tags = {};

  AlertDialogConfig alertDialogConfig = const AlertDialogConfig();
  EditableDialogConfig editableDialogConfig = const EditableDialogConfig();
  LoadingDialogConfig loadingDialogConfig = const LoadingDialogConfig();
  MessageDialogConfig messageDialogConfig = const MessageDialogConfig();
  SnackBarConfig snackBarConfig = const SnackBarConfig();
  SnackBarConfig errorSnackBarConfig = const SnackBarConfig();
  SnackBarConfig warningSnackBarConfig = const SnackBarConfig();

  Dialogs._();

  static Dialogs? _i;

  static Dialogs get i => _i ??= Dialogs._();

  static init({
    AlertDialogConfig? alertDialogConfig,
    EditableDialogConfig? editableDialogConfig,
    LoadingDialogConfig? loadingDialogConfig,
    MessageDialogConfig? messageDialogConfig,
    SnackBarConfig? snackBarConfig,
    SnackBarConfig? errorSnackBarConfig,
    SnackBarConfig? warningSnackBarConfig,
  }) {
    i.alertDialogConfig = alertDialogConfig ?? i.alertDialogConfig;
    i.editableDialogConfig = editableDialogConfig ?? i.editableDialogConfig;
    i.loadingDialogConfig = loadingDialogConfig ?? i.loadingDialogConfig;
    i.messageDialogConfig = messageDialogConfig ?? i.messageDialogConfig;
    i.snackBarConfig = snackBarConfig ?? i.snackBarConfig;
    i.errorSnackBarConfig = errorSnackBarConfig ?? i.errorSnackBarConfig;
    i.warningSnackBarConfig = warningSnackBarConfig ?? i.warningSnackBarConfig;
  }

  Future<bool> alert(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    final config = alertDialogConfig;
    if (config.material) {
      return showDialog(
        context: context,
        builder: (_) => _AlertDialog(
          config: config,
          title: title,
          message: message,
        ),
      ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
    } else {
      return showCupertinoDialog(
        context: context,
        builder: (_) => _AlertDialog(
          config: config,
          title: title,
          message: message,
        ),
      ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
    }
  }

  Future<String> editor(
    BuildContext context, {
    String? title,
    String? text,
    String? hint,
  }) {
    final config = editableDialogConfig;
    if (config.material) {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => _EditableDialog(
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
        builder: (_) => _EditableDialog(
          config: config,
          title: title,
          text: text,
          hint: hint,
        ),
      ).onError((_, __) => null).then((_) => _ is String ? _ : "");
    }
  }

  bool get isLoaderMode => _tags[DialogType.loader] ?? false;

  Future<bool> loader(
    BuildContext context, {
    bool status = true,
  }) {
    final config = loadingDialogConfig;
    if (isLoaderMode && status) return Future.value(false);
    if (!isLoaderMode && !status) return Future.value(false);
    if (status) {
      _tags[DialogType.loader] = true;
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoadingDialog(config: config),
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

  Future<bool> message(
    BuildContext context,
    String? message, {
    String? title,
  }) {
    final oldMessage = _tags[DialogType.message];
    if (message != oldMessage) {
      final config = messageDialogConfig;
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

  void _snackBar(
    BuildContext context,
    String message,
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
          message: message,
        ),
      );
      _tags[type] = message;
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
        _tags.remove(type);
      });
    }
  }

  void snackBar(BuildContext context, String message) {
    _snackBar(
      context,
      message,
      snackBarConfig,
      DialogType.snackBar,
    );
  }

  void snackBarError(BuildContext context, String message) {
    _snackBar(
      context,
      message,
      errorSnackBarConfig,
      DialogType.snackBarError,
    );
  }

  void snackBarWarning(BuildContext context, String message) {
    _snackBar(
      context,
      message,
      warningSnackBarConfig,
      DialogType.snackBarWarning,
    );
  }
}
