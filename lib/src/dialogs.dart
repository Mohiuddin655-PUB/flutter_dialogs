import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button.dart';

part 'configs.dart';
part 'dialog_alert.dart';
part 'dialog_editor.dart';
part 'dialog_loading.dart';
part 'dialog_message.dart';
part 'type.dart';

class Dialogs {
  const Dialogs._();

  static Future<bool> showAlert(
    BuildContext context, {
    Key? key,
    String? title,
    String? message,
    AlertDialogConfig config = const AlertDialogConfig(),
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => _AlertDialog(
        key: key,
        config: config.copy(title: title, message: message),
      ),
    ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
  }

  static Future<String> showEditor(
    BuildContext context, {
    Key? key,
    String? title,
    String? message,
    String? hint,
    EditableDialogConfig config = const EditableDialogConfig(),
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => _EditableDialog(
        key: key,
        config: config.copy(title: title, message: message, hint: hint),
      ),
    ).onError((_, __) => null).then((_) => _ is String ? _ : "");
  }

  static Future<bool> showLoading(
    BuildContext context, {
    Key? key,
    ValueNotifier<double>? progress,
    LoadingDialogConfig config = const LoadingDialogConfig(),
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => _LoadingDialog(
        key: key,
        config: config.copy(progress: progress),
      ),
    ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
  }

  static Future<bool> showMessage(
    BuildContext context,
    String? message, {
    String? title,
    Key? key,
    MessageDialogConfig config = const MessageDialogConfig(),
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => _MessageDialog(
        key: key,
        config: config.copy(title: title, message: message),
      ),
    ).onError((_, __) => null).then((_) => _ is bool ? _ : false);
  }
}
