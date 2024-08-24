import 'package:flutter/material.dart';

import '../dialogs.dart';

/// Extension on BuildContext to simplify showing dialogs using the Dialogs class.
extension DialogsHelper on BuildContext {
  /// Shows an alert dialog with the provided title and message.
  ///
  /// Example:
  /// ```dart
  /// context.showAlert(title: "Alert", message: "This is an alert!");
  /// ```
  Future<bool> showAlert({String? title, String? message}) {
    return Dialogs.i.alert(this, title: title, message: message);
  }

  /// Shows an editable dialog for user input with the provided title, initial text, and hint.
  ///
  /// Example:
  /// ```dart
  /// context.showEditor(title: "Edit Text", text: "Initial value", hint: "Enter text here");
  /// ```
  Future<String> showEditor({String? title, String? text, String? hint}) {
    return Dialogs.i.editor(this, title: title, text: text, hint: hint);
  }

  /// Shows or hides a loader dialog with an optional loading status.
  ///
  /// Example:
  /// ```dart
  /// context.showLoader(); // Show loader
  /// context.showLoader(false); // Hide loader
  /// ```
  Future<bool> showLoader([bool status = true]) {
    return Dialogs.i.loader(this, status: status);
  }

  /// Shows a message dialog with the provided message and optional title.
  ///
  /// Example:
  /// ```dart
  /// context.showMessage("Hello World", title: "Greetings");
  /// ```
  Future<bool> showMessage(String? message, {String? title}) {
    return Dialogs.i.message(this, message, title: title);
  }

  /// Shows a SnackBar with the provided message.
  ///
  /// Example:
  /// ```dart
  /// context.showSnackBar("This is a SnackBar message");
  /// ```
  void showSnackBar(String? message, {String? title}) {
    Dialogs.i.snackBar(this, title: title, message: message);
  }

  /// Shows an error-themed SnackBar with the provided error message.
  ///
  /// Example:
  /// ```dart
  /// context.showErrorSnackBar("An error occurred");
  /// ```
  void showErrorSnackBar(String? message, {String? title}) {
    Dialogs.i.snackBarError(this, title: title, message: message);
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showWarningSnackBar("This is a info message");
  /// ```
  void showInfoSnackBar(String? message, {String? title}) {
    Dialogs.i.snackBarInfo(this, title: title, message: message);
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showWaitingSnackBar("This is a waiting message");
  /// ```
  void showWaitingSnackBar(String? message, {String? title}) {
    Dialogs.i.snackBarWaiting(this, title: title, message: message);
  }

  /// Shows a warning-themed SnackBar with the provided warning message.
  ///
  /// Example:
  /// ```dart
  /// context.showWarningSnackBar("This is a warning message");
  /// ```
  void showWarningSnackBar(String? message, {String? title}) {
    Dialogs.i.snackBarWarning(this, title: title, message: message);
  }
}
