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

  Future<void> dismiss({bool? force, Object? result}) {
    return Dialogs.i.dismiss(force: force, result: result);
  }

  /// Shows an alert dialog with the provided title and message.
  ///
  /// Example:
  /// ```dart
  /// context.showAlert(title: "Alert", message: "This is an alert!");
  /// ```
  Future<bool> showAlert({
    String? title,
    String? message,
    String? positiveButtonText,
    String? negativeButtonText,
    AlertDialogContent content = const AlertDialogContent(),
  }) {
    return Dialogs.i.alert(
      this,
      title: title,
      message: message,
      positiveButtonText: positiveButtonText,
      negativeButtonText: negativeButtonText,
      content: content,
    );
  }

  /// Shows an editable dialog for user input with the provided title, initial text, and hint.
  ///
  /// Example:
  /// ```dart
  /// context.showEditor(title: "Edit Text", text: "Initial value", hint: "Enter text here");
  /// ```
  Future<String?> showEditor({
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

  /// Shows an editable sheet for user input with the provided title, initial text, and hint.
  ///
  /// Example:
  /// ```dart
  /// context.showEditorSheet(title: "Edit Text", text: "Initial value", hint: "Enter text here");
  /// ```
  Future<String?> showEditorSheet({
    String? title,
    String? subtitle,
    String? hint,
    String? text,
    EditableDialogContent content = const EditableDialogContent(),
  }) {
    return Dialogs.i.editorSheet(
      this,
      title: title,
      subtitle: subtitle,
      text: text,
      hint: hint,
      content: content,
    );
  }

  /// Displays a custom toast-like overlay message.
  ///
  /// This method inserts a temporary overlay entry into the current [Overlay]
  /// to display a toast widget with a given message.
  ///
  /// The toast is automatically removed after the specified [duration].
  /// You can also control its position using [alignment] and optionally pass
  /// extra [args] to customize the appearance or behavior.
  ///
  /// ### Use cases:
  ///
  /// ```dart
  /// // Show a default toast
  /// Toast.show('This is a toast message');
  ///
  /// ```dart
  /// // Show a default toast
  /// context.showToast('This is a toast message');
  ///
  /// // Show a toast with custom duration and alignment
  /// Toast.show(
  ///   'Bottom Toast',
  ///   duration: Duration(seconds: 3),
  ///   alignment: Alignment.bottomCenter,
  /// );
  ///
  /// // Show a toast using a specific BuildContext (e.g., inside a Navigator)
  /// Toast.show(
  ///   'Toast from nested context',
  ///   context: nestedContext,
  /// );
  /// ```
  ///
  /// - The toast relies on an existing `Overlay` widget in the widget tree.
  /// - If no [context] is provided, it falls back to a globally available `Toast.context`.
  /// - If no [duration] is provided, it uses a default internal value.
  /// - If no [alignment] is provided, it uses a default internal alignment.
  ///
  /// [msg]      The text to be displayed in the toast.
  /// [context]  Optional context used to find the overlay.
  /// [duration] Duration before the toast disappears (defaults to internal setting).
  /// [alignment] Position on screen for toast display (defaults to internal setting).
  /// [args]     Optional arguments passed to the builder function for further customization.
  void showToast(
    String msg, {
    Duration? duration,
    Alignment? alignment,
    Object? args,
    Widget? custom,
  }) {
    return Toast.show(
      msg,
      context: this,
      alignment: alignment,
      args: args,
      duration: duration,
      custom: custom,
    );
  }

  /// Shows or hides a loader dialog with an optional loading status.
  ///
  /// Example:
  /// ```dart
  /// context.showLoader(); // Show loader
  /// ```
  void showLoader({
    Alignment? alignment,
    bool? barrierDismissible,
    Color? barrierColor,
    double? barrierBlurSigma,
    Curve? curve,
    Curve? reverseCurve,
    Duration? duration,
    Duration? reverseDuration,
    Object? args,
    WidgetBuilder? builder,
    LoaderTransitionBuilder? transitionBuilder,
  }) {
    return Loader.show(
      context: this,
      alignment: alignment,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierBlurSigma: barrierBlurSigma,
      curve: curve,
      reverseCurve: reverseCurve,
      duration: duration,
      reverseDuration: reverseDuration,
      args: args,
      builder: builder,
      transitionBuilder: transitionBuilder,
    );
  }

  /// Shows or hides a loader dialog with an optional loading status.
  ///
  /// Example:
  /// ```dart
  /// context.hideLoader(); // Hide loader
  /// ```
  Future<void> hideLoader([bool force = false]) {
    return Loader.hide(force);
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
  /// context.showOptions(options: ["A","B","C"], initialIndex: 1);
  /// ```
  Future<int> showOptions<T extends Object?>({
    int initialIndex = 0,
    List<String>? options,
    String? title,
    String? subtitle,
    OptionDialogContent content = const OptionDialogContent(),
  }) {
    return Dialogs.i.options(
      this,
      options: options,
      initialIndex: initialIndex,
      title: title,
      subtitle: subtitle,
      content: content,
    );
  }

  /// Shows a Options with the provided some options.
  ///
  /// Example:
  /// ```dart
  /// context.showOptionsSheet(options: ["A","B","C"], initialIndex: 1);
  /// ```
  Future<int> showOptionsSheet<T extends Object?>({
    int initialIndex = 0,
    List<String>? options,
    String? title,
    String? subtitle,
    OptionDialogContent content = const OptionDialogContent(),
  }) {
    return Dialogs.i.optionsSheet(
      this,
      options: options,
      initialIndex: initialIndex,
      title: title,
      subtitle: subtitle,
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
