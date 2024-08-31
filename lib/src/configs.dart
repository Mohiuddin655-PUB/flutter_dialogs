part of 'dialogs.dart';

typedef AndrossyDialogBuilder<T extends DialogContent> = Widget Function(
  BuildContext context,
  T content,
);

class DialogContent {
  final String id;
  final String? title;
  final String? body;
  final Object? args;

  const DialogContent({
    this.id = "dialog",
    this.title,
    this.body,
    this.args,
  });

  DialogContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
  }) {
    return DialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
    );
  }
}

class DialogConfig<T extends DialogContent> {
  final AndrossyDialogBuilder<T> builder;

  // EXTRA
  final bool useRootNavigator;
  final bool useSafeArea;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
  final String? barrierLabel;
  final bool material;

  // BASE
  final bool animated;
  final bool barrierDismissible;
  final Color? barrierColor;
  final double barrierBlurSigma;
  final Duration? displayDuration;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? curve;
  final Curve? reverseCurve;
  final AndrossyDialogPosition position;
  final AndrossyDialogTransitionBuilder? transitionBuilder;

  const DialogConfig({
    required this.builder,
    // ROUTE PROPERTIES
    this.useSafeArea = false,
    this.useRootNavigator = true,
    this.routeSettings,
    this.anchorPoint,
    this.traversalEdgeBehavior,
    this.barrierLabel,
    this.material = true,
    // DIALOG PROPERTIES
    this.animated = true,
    this.displayDuration,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierBlurSigma = 5.0,
    this.curve,
    this.reverseCurve,
    this.duration,
    this.reverseDuration,
    this.position = AndrossyDialogPosition.center,
    this.transitionBuilder,
  });
}

class AlertDialogContent extends DialogContent {
  final String? positiveButtonText;
  final TextStyle? positiveButtonTextStyle;
  final String? negativeButtonText;
  final TextStyle? negativeButtonTextStyle;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const AlertDialogContent({
    super.id = "alert",
    super.title,
    super.body,
    super.args,
    this.positiveButtonText,
    this.positiveButtonTextStyle,
    this.negativeButtonText,
    this.negativeButtonTextStyle,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  AlertDialogContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
    String? positiveButtonText,
    TextStyle? positiveButtonTextStyle,
    String? negativeButtonText,
    TextStyle? negativeButtonTextStyle,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    return AlertDialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
      positiveButtonText: positiveButtonText ?? this.positiveButtonText,
      positiveButtonTextStyle:
          positiveButtonTextStyle ?? this.positiveButtonTextStyle,
      negativeButtonText: negativeButtonText ?? this.negativeButtonText,
      negativeButtonTextStyle:
          negativeButtonTextStyle ?? this.negativeButtonTextStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
    );
  }
}

class AlertDialogConfig extends DialogConfig<AlertDialogContent> {
  const AlertDialogConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 5.0,
    super.curve,
    super.reverseCurve,
    super.duration,
    super.reverseDuration,
    super.position = AndrossyDialogPosition.center,
    super.transitionBuilder,
  });
}

class LoadingDialogContent extends DialogContent {
  const LoadingDialogContent({
    super.id = "loading",
    super.title,
    super.body,
    super.args,
  });

  @override
  LoadingDialogContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
  }) {
    return LoadingDialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
    );
  }
}

class LoadingDialogConfig extends DialogConfig<LoadingDialogContent> {
  const LoadingDialogConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 5.0,
    super.curve,
    super.reverseCurve,
    super.duration,
    super.reverseDuration,
    super.position = AndrossyDialogPosition.center,
    super.transitionBuilder,
  });
}

class MessageDialogContent extends DialogContent {
  const MessageDialogContent({
    super.id = "message",
    super.title,
    super.args,
    super.body,
  });

  @override
  MessageDialogContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
  }) {
    return MessageDialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
    );
  }
}

class MessageDialogConfig extends DialogConfig<MessageDialogContent> {
  const MessageDialogConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 5.0,
    super.curve,
    super.reverseCurve,
    super.displayDuration,
    super.duration,
    super.reverseDuration,
    super.position = AndrossyDialogPosition.center,
    super.transitionBuilder,
  });
}

class EditableDialogContent extends DialogContent {
  final String? text;
  final String? hint;

  const EditableDialogContent({
    super.id = "editable",
    super.title,
    super.body,
    super.args,
    this.text,
    this.hint,
  });

  @override
  EditableDialogContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
    String? hint,
    String? text,
  }) {
    return EditableDialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
      hint: hint ?? this.hint,
      text: text ?? this.text,
    );
  }
}

class EditableDialogConfig extends DialogConfig<EditableDialogContent> {
  const EditableDialogConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 5.0,
    super.curve,
    super.reverseCurve,
    super.duration,
    super.reverseDuration,
    super.position = AndrossyDialogPosition.center,
    super.transitionBuilder,
  });
}

class OptionDialogContent<T extends Object?> extends DialogContent {
  final int initialIndex;
  final List<T> options;

  const OptionDialogContent({
    super.id = "option",
    super.title,
    super.body,
    super.args,
    this.initialIndex = 0,
    this.options = const [],
  });

  @override
  OptionDialogContent copy({
    String? id,
    String? title,
    String? body,
    int? initialIndex,
    List<T>? options,
    Object? args,
  }) {
    return OptionDialogContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
      initialIndex: initialIndex ?? this.initialIndex,
      options: options ?? this.options,
    );
  }
}

class OptionDialogConfig extends DialogConfig<OptionDialogContent> {
  const OptionDialogConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 5.0,
    super.curve,
    super.reverseCurve,
    super.duration,
    super.reverseDuration,
    super.position = AndrossyDialogPosition.center,
    super.transitionBuilder,
  });
}

class SnackBarContent extends DialogContent {
  const SnackBarContent({
    super.id = "snack_bar",
    super.title,
    super.args,
    super.body,
  });

  @override
  SnackBarContent copy({
    String? id,
    String? title,
    String? body,
    Object? args,
  }) {
    return SnackBarContent(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      args: args ?? this.args,
    );
  }
}

class SnackBarConfig extends DialogConfig<SnackBarContent> {
  const SnackBarConfig({
    required super.builder,
    super.useSafeArea = false,
    super.useRootNavigator = true,
    super.routeSettings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.barrierLabel,
    super.material = true,
    // DIALOG PROPERTIES
    super.animated = true,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierBlurSigma = 2.0,
    super.curve = Curves.easeInOutQuart,
    super.reverseCurve = const Interval(0.72, 1.0, curve: Curves.fastOutSlowIn),
    super.displayDuration = const Duration(milliseconds: 4000),
    super.duration = const Duration(milliseconds: 250),
    super.reverseDuration = const Duration(milliseconds: 250),
    super.position = AndrossyDialogPosition.bottom,
    super.transitionBuilder,
  });
}
