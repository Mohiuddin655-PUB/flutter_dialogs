import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dialogs.dart';

part 'configs.dart';

// Typedef for building dialog configurations dynamically
typedef DialogConfigBuilder<T extends DialogConfig> = T Function(
  BuildContext context,
);

// Class for managing various types of dialogs and snack bars
class Dialogs {
  final Map<String, dynamic> _tags = {};
  final Map<String, DialogConfigBuilder<DialogConfig>> configs = {};

  DialogConfigBuilder<AlertDialogConfig>? alertDialogConfig;
  DialogConfigBuilder<EditableDialogConfig>? editableDialogConfig;
  DialogConfigBuilder<EditableSheetConfig>? editableSheetConfig;
  DialogConfigBuilder<LoadingDialogConfig>? loadingDialogConfig;
  DialogConfigBuilder<MessageDialogConfig>? messageDialogConfig;
  DialogConfigBuilder<OptionDialogConfig>? optionDialogConfig;
  DialogConfigBuilder<OptionSheetConfig>? optionSheetConfig;
  DialogConfigBuilder<SnackBarConfig>? snackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? errorSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? infoSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? waitingSnackBarConfig;
  DialogConfigBuilder<SnackBarConfig>? warningSnackBarConfig;

  Dialogs._();

  static Dialogs? _i;

  static Dialogs get i => _i ??= Dialogs._();

  // Initialize the dialog configurations
  static Dialogs init({
    DialogConfigBuilder<AlertDialogConfig>? alertDialogConfig,
    DialogConfigBuilder<EditableDialogConfig>? editableDialogConfig,
    DialogConfigBuilder<EditableSheetConfig>? editableSheetConfig,
    DialogConfigBuilder<LoadingDialogConfig>? loadingDialogConfig,
    DialogConfigBuilder<MessageDialogConfig>? messageDialogConfig,
    DialogConfigBuilder<OptionDialogConfig>? optionDialogConfig,
    DialogConfigBuilder<OptionSheetConfig>? optionSheetConfig,
    DialogConfigBuilder<SnackBarConfig>? snackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? errorSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? infoSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? waitingSnackBarConfig,
    DialogConfigBuilder<SnackBarConfig>? warningSnackBarConfig,
    Map<String, DialogConfigBuilder<DialogConfig>> configs = const {},
  }) {
    i.alertDialogConfig = alertDialogConfig ?? i.alertDialogConfig;
    i.editableDialogConfig = editableDialogConfig ?? i.editableDialogConfig;
    i.editableSheetConfig = editableSheetConfig ?? i.editableSheetConfig;
    i.loadingDialogConfig = loadingDialogConfig ?? i.loadingDialogConfig;
    i.messageDialogConfig = messageDialogConfig ?? i.messageDialogConfig;
    i.optionDialogConfig = optionDialogConfig ?? i.optionDialogConfig;
    i.optionSheetConfig = optionSheetConfig ?? i.optionSheetConfig;
    i.snackBarConfig = snackBarConfig ?? i.snackBarConfig;
    i.errorSnackBarConfig = errorSnackBarConfig ?? i.errorSnackBarConfig;
    i.infoSnackBarConfig = infoSnackBarConfig ?? i.infoSnackBarConfig;
    i.waitingSnackBarConfig = waitingSnackBarConfig ?? i.waitingSnackBarConfig;
    i.warningSnackBarConfig = warningSnackBarConfig ?? i.warningSnackBarConfig;
    i.configs.addAll(configs);
    return i;
  }

  Future<T?> _show<T, Content extends DialogContent>({
    required BuildContext context,
    required Content content,
    required DialogConfigBuilder<DialogConfig<Content>> configBuilder,
  }) {
    final config = configBuilder(context);
    return AndrossyDialog.show(
      context: context,
      anchorPoint: config.anchorPoint,
      routeSettings: config.routeSettings,
      traversalEdgeBehavior: config.traversalEdgeBehavior,
      useRootNavigator: config.useRootNavigator,
      useSafeArea: config.useSafeArea,
      animated: config.animated,
      material: config.material,
      barrierDismissible: config.barrierDismissible,
      barrierColor: config.barrierColor,
      barrierBlurSigma: config.barrierBlurSigma,
      barrierLabel: config.barrierLabel,
      curve: config.curve,
      reverseCurve: config.reverseCurve,
      displayDuration: config.displayDuration,
      duration: config.duration,
      reverseDuration: config.reverseDuration,
      position: config.position,
      transitionBuilder: config.transitionBuilder,
      builder: (context) => config.builder(context, content),
      // BOTTOM SHEET PROPERTY
      useModalBottomSheet: config.useModalBottomSheet,
      enableDrag: config.enableDrag,
      showDragHandle: config.showDragHandle,
      isScrollControlled: config.isScrollControlled,
      sheetAnimationStyle: config.sheetAnimationStyle,
      transitionAnimationController: config.transitionAnimationController,
      scrollControlDisabledMaxHeightRatio:
          config.scrollControlDisabledMaxHeightRatio,
      shape: config.shape,
      elevation: config.elevation,
      backgroundColor: config.backgroundColor,
      constraints: config.constraints,
    );
  }

  void dismiss([Object? result]) {
    AndrossyDialog.dismiss(result);
  }

  Future<T?> show<T>(
    BuildContext context,
    String name, {
    DialogContent content = const DialogContent(id: "custom"),
  }) {
    final configBuilder = configs[name];
    if (configBuilder == null) {
      final names = name.split("_").join(" ");
      final first = names.characters.firstOrNull?.toUpperCase() ?? "";
      final last = names.substring(1);
      throw UnimplementedError(
        "$first$last dialog config not initialized yet!",
      );
    }
    return _show(
      context: context,
      content: content.copy(id: content.id == "dialog" ? "custom" : null),
      configBuilder: configBuilder,
    );
  }

  /// Shows an alert dialog.
  ///
  /// Example:
  /// ```dart
  /// await Dialogs.i.alert(context, title: "Alert", message: "This is an alert message");
  /// ```
  Future<bool> alert(
    BuildContext context, {
    String? title,
    String? message,
    String? positiveButtonText,
    String? negativeButtonText,
    AlertDialogContent content = const AlertDialogContent(),
  }) {
    if (alertDialogConfig == null) {
      throw UnimplementedError("Alert dialog config not initialized yet!");
    }
    return _show(
      context: context,
      configBuilder: alertDialogConfig!,
      content: content.copy(
        titleText: title,
        bodyText: message,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
      ),
    ).onError((_, __) => null).then((value) => value is bool ? value : false);
  }

  /// Shows an editable dialog for input.
  ///
  /// Example:
  /// ```dart
  /// String result = await Dialogs.i.editor(context, content: EditableDialogInfo(title: "Edit", text: "Initial text", hint: "Enter text"));
  /// ```
  Future<String?> editor(
    BuildContext context, {
    String? title,
    String? subtitle,
    String? hint,
    String? text,
    EditableDialogContent content = const EditableDialogContent(),
  }) {
    if (editableDialogConfig == null) {
      throw UnimplementedError("Editable dialog config not initialized yet!");
    }
    return _show(
      context: context,
      configBuilder: editableDialogConfig!,
      content: content.copy(
        titleText: title,
        bodyText: subtitle,
        text: text,
        hint: hint,
      ),
    ).onError((_, __) => text).then((value) => value is String ? value : text);
  }

  /// Shows an editable sheet for input.
  ///
  /// Example:
  /// ```dart
  /// String result = await Dialogs.i.editorSheet(context, content: EditableDialogInfo(title: "Edit", text: "Initial text", hint: "Enter text"));
  /// ```
  Future<String?> editorSheet(
    BuildContext context, {
    String? title,
    String? subtitle,
    String? hint,
    String? text,
    EditableDialogContent content = const EditableDialogContent(),
  }) {
    if (editableSheetConfig == null) {
      throw UnimplementedError("Editable sheet config not initialized yet!");
    }
    return _show(
      context: context,
      configBuilder: editableSheetConfig!,
      content: content.copy(
        id: "${content.id}_sheet",
        titleText: title,
        bodyText: subtitle,
        text: text,
        hint: hint,
      ),
    ).onError((_, __) => text).then((value) => value is String ? value : text);
  }

  /// Checks if loader mode is active.
  ///
  /// Example:
  /// ```dart
  /// bool isLoading = Dialogs.i.isLoaderMode;
  /// ```
  bool isLoadingMode(String id) => _tags[id] ?? false;

  /// Shows or hides a loader dialog.
  ///
  /// Example:
  /// ```dart
  /// bool showLoader = true; // Set to false to hide loader
  /// await Dialogs.i.loader(context, status: showLoader);
  /// ```
  Future<bool> loader(
    BuildContext context, {
    bool status = true,
    LoadingDialogContent content = const LoadingDialogContent(),
  }) {
    if (loadingDialogConfig == null) {
      throw UnimplementedError("Loading dialog config not initialized yet!");
    }
    if (isLoadingMode(content.id) && status) return Future.value(false);
    if (!isLoadingMode(content.id) && !status) return Future.value(false);
    if (status) {
      _tags[content.id] = true;
      return _show(
        context: context,
        content: content,
        configBuilder: loadingDialogConfig!,
      ).onError((_, __) => null).then((value) {
        _tags.remove(content.id);
        return value is bool ? value : false;
      });
    } else {
      if (isLoadingMode(content.id)) dismiss(true);
      return Future.value(false);
    }
  }

  /// Shows a message dialog.
  ///
  /// Example:
  /// ```dart
  /// await Dialogs.i.message(context, "This is a message", title: "Message");
  /// ```
  Future<bool> message(
    BuildContext context,
    String? message, {
    String? title,
    MessageDialogContent content = const MessageDialogContent(),
  }) {
    if (messageDialogConfig == null) {
      throw UnimplementedError("Message dialog config not initialized yet!");
    }
    final oldMessage = _tags[content.id];
    if (message != oldMessage) {
      _tags[content.id] = message;
      return _show(
        context: context,
        content: content.copy(bodyText: message, titleText: title),
        configBuilder: messageDialogConfig!,
      ).onError((_, __) => null).then((value) {
        _tags.remove(content.id);
        return value is bool ? value : false;
      });
    } else {
      return Future.value(false);
    }
  }

  Future<int> options(
    BuildContext context, {
    int initialIndex = 0,
    List<String>? options,
    String? title,
    String? subtitle,
    OptionDialogContent content = const OptionDialogContent(),
  }) {
    if (optionDialogConfig == null) {
      throw UnimplementedError("Option dialog config not initialized yet!");
    }
    return _show(
      context: context,
      content: content.copy(
        options: options,
        initialIndex: initialIndex,
        titleText: title,
        bodyText: subtitle,
      ),
      configBuilder: optionDialogConfig!,
    ).onError((_, __) => initialIndex).then((value) {
      return value is int ? value : initialIndex;
    });
  }

  Future<int> optionsSheet(
    BuildContext context, {
    int initialIndex = 0,
    List<String>? options,
    String? title,
    String? subtitle,
    OptionDialogContent content = const OptionDialogContent(),
  }) {
    if (optionSheetConfig == null) {
      throw UnimplementedError("Option sheet config not initialized yet!");
    }
    return _show(
      context: context,
      content: content.copy(
        id: "${content.id}_sheet",
        options: options,
        initialIndex: initialIndex,
        titleText: title,
        bodyText: subtitle,
      ),
      configBuilder: optionSheetConfig!,
    ).onError((_, __) => initialIndex).then((value) {
      return value is int ? value : initialIndex;
    });
  }

  /// Private function to show a custom SnackBar.
  Future<bool> _snackBar(
    BuildContext context,
    SnackBarContent content,
    DialogConfigBuilder<SnackBarConfig>? configBuilder,
  ) {
    if (configBuilder == null) {
      final names = content.id.split("_").join(" ");
      final first = names.characters.firstOrNull?.toUpperCase() ?? "";
      final last = names.substring(1);
      throw UnimplementedError(
        "$first$last config not initialized yet!",
      );
    }
    final oldMessage = _tags[content.id];
    if (content.bodyText != oldMessage) {
      _tags[content.id] = content.bodyText;
      return _show(
        context: context,
        content: content,
        configBuilder: configBuilder,
      ).onError((_, __) => null).then((value) {
        _tags.remove(content.id);
        return value is bool ? value : false;
      });
    } else {
      return Future.value(false);
    }
  }

  /// Shows a snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBar(context, "This is a snack bar message");
  /// ```
  Future<bool> snackBar(
    BuildContext context,
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(),
  }) {
    return _snackBar(
      context,
      content.copy(titleText: title, bodyText: message),
      snackBarConfig,
    );
  }

  /// Shows an error-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarError(context, "An error occurred");
  /// ```
  Future<bool> snackBarError(
    BuildContext context,
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "error_snack_bar"),
  }) {
    return _snackBar(
      context,
      content.copy(
        id: content.id == "snack_bar" ? "error_snack_bar" : null,
        titleText: title,
        bodyText: message,
      ),
      errorSnackBarConfig,
    );
  }

  /// Shows a info-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarInfo(context, "Warning: Something went wrong");
  /// ```
  Future<bool> snackBarInfo(
    BuildContext context,
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "info_snack_bar"),
  }) {
    return _snackBar(
      context,
      content.copy(
        id: content.id == "snack_bar" ? "info_snack_bar" : null,
        titleText: title,
        bodyText: message,
      ),
      infoSnackBarConfig,
    );
  }

  /// Shows a waiting-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarWaiting(context, "Warning: Something went wrong");
  /// ```
  Future<bool> snackBarWaiting(
    BuildContext context,
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "waiting_snack_bar"),
  }) {
    return _snackBar(
      context,
      content.copy(
        id: content.id == "snack_bar" ? "waiting_snack_bar" : null,
        titleText: title,
        bodyText: message,
      ),
      waitingSnackBarConfig,
    );
  }

  /// Shows a warning-themed snack bar with the specified message.
  ///
  /// Example:
  /// ```dart
  /// Dialogs.i.snackBarWarning(context, "Warning: Something went wrong");
  /// ```
  Future<bool> snackBarWarning(
    BuildContext context,
    String message, {
    String? title,
    SnackBarContent content = const SnackBarContent(id: "warning_snack_bar"),
  }) {
    return _snackBar(
      context,
      content.copy(
        id: content.id == "snack_bar" ? "warning_snack_bar" : null,
        titleText: title,
        bodyText: message,
      ),
      warningSnackBarConfig,
    );
  }
}
