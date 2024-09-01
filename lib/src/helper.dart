import 'package:flutter/material.dart';

import '../dialogs.dart';

/// Extension on BuildContext to simplify showing dialogs using the Dialogs class.
extension DialogsHelper on BuildContext {
  Future<T?> show<T>(
    String name, {
    DialogContent content = const DialogContent(id: "custom"),
  }) {
    return Dialogs.i.show(this, name, content: content);
  }

  void dismiss([Object? result]) => Dialogs.i.dismiss(result);

  /// Shows an alert dialog with the provided title and message.
  ///
  /// Example:
  /// ```dart
  /// context.showAlert(title: "Alert", message: "This is an alert!");
  /// ```
  Future<bool> showAlert({
    String? title,
    String? message,
    AlertDialogContent content = const AlertDialogContent(),
  }) {
    return Dialogs.i.alert(
      this,
      title: title,
      message: message,
      content: content,
    );
  }

  /// Shows an editable dialog for user input with the provided title, initial text, and hint.
  ///
  /// Example:
  /// ```dart
  /// context.showEditor(title: "Edit Text", text: "Initial value", hint: "Enter text here");
  /// ```
  Future<String> showEditor({
    String? title,
    String? subtitle,
    String? hint,
    String? text,
    EditableDialogContent content = const EditableDialogContent(),
  }) {
    return Dialogs.i.editor(
      this,
      title: title,
      subtitle: subtitle,
      text: text,
      hint: hint,
      content: content,
    );
  }

  /// Shows or hides a loader dialog with an optional loading status.
  ///
  /// Example:
  /// ```dart
  /// context.showLoader(); // Show loader
  /// context.showLoader(false); // Hide loader
  /// ```
  Future<bool> showLoader([
    bool status = true,
    LoadingDialogContent content = const LoadingDialogContent(),
  ]) {
    return Dialogs.i.loader(this, status: status, content: content);
  }

  /// Shows a message dialog with the provided message and optional title.
  ///
  /// Example:
  /// ```dart
  /// context.showMessage("Hello World", title: "Greetings");
  /// ```
  Future<bool> showMessage(
    String? message, {
    String? title,
    MessageDialogContent content = const MessageDialogContent(),
  }) {
    return Dialogs.i.message(this, message, title: title, content: content);
  }

  /// Shows a Options with the provided some options.
  ///
  /// Example:
  /// ```dart
  /// context.showOption(["A","B","C"], initialIndex: 1);
  /// ```
  Future<T?> showOption<T extends Object?>(
    List<T> options, {
    int initialIndex = 0,
    OptionDialogContent content = const OptionDialogContent(),
  }) {
    return Dialogs.i.option(
      this,
      options,
      initialIndex: initialIndex,
      content: content,
    );
  }

  /// Shows a SnackBar with the provided message.
  ///
  /// Example:
  /// ```dart
  /// context.showSnackBar("This is a SnackBar message");
  /// ```
  Future<bool> showSnackBar(
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(),
  }) {
    return Dialogs.i.snackBar(this, message, title: title, content: content);
  }

  /// Shows an error-themed SnackBar with the provided error message.
  ///
  /// Example:
  /// ```dart
  /// context.showErrorSnackBar("An error occurred");
  /// ```
  Future<bool> showErrorSnackBar(
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "error_snack_bar"),
  }) {
    return Dialogs.i.snackBarError(
      this,
      message,
      title: title,
      content: content,
    );
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showInfoSnackBar("This is a info message");
  /// ```
  Future<bool> showInfoSnackBar(
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "info_snack_bar"),
  }) {
    return Dialogs.i.snackBarInfo(
      this,
      message,
      title: title,
      content: content,
    );
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showWaitingSnackBar("This is a waiting message");
  /// ```
  Future<bool> showWaitingSnackBar(
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "waiting_snack_bar"),
  }) {
    return Dialogs.i.snackBarWaiting(
      this,
      message,
      title: title,
      content: content,
    );
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showWarningSnackBar("This is a warning message");
  /// ```
  Future<bool> showWarningSnackBar(
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "warning_snack_bar"),
  }) {
    return Dialogs.i.snackBarWarning(
      this,
      message,
      title: title,
      content: content,
    );
  }
}
