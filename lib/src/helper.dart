import 'package:flutter/material.dart';

import 'dialogs.dart';

extension DialogsHelper on BuildContext {
  Future<bool> showAlert({
    Key? key,
    String? title,
    String? message,
    AlertDialogConfig config = const AlertDialogConfig(),
  }) {
    return Dialogs.showAlert(
      this,
      key: key,
      title: title,
      message: message,
      config: config,
    );
  }

  Future<String> showEditor({
    Key? key,
    String? title,
    String? message,
    String? hint,
    EditableDialogConfig config = const EditableDialogConfig(),
  }) {
    return Dialogs.showEditor(
      this,
      key: key,
      title: title,
      message: message,
      hint: hint,
      config: config,
    );
  }

  Future<bool> showLoading({
    Key? key,
    ValueNotifier<double>? progress,
    LoadingDialogConfig config = const LoadingDialogConfig(),
  }) {
    return Dialogs.showLoading(
      this,
      key: key,
      progress: progress,
      config: config,
    );
  }

  Future<bool> showMessage(
    String? message, {
    String? title,
    Key? key,
    MessageDialogConfig config = const MessageDialogConfig(),
  }) {
    return Dialogs.showMessage(
      this,
      message,
      key: key,
      title: title,
      config: config,
    );
  }
}
