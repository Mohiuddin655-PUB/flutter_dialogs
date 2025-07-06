import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

const Curve _curve = Cubic(0.0, 0.0, 0.2, 1.0);

final Set<_Scope> _scopes = {};

class _Scope {
  final AndrossyDialogState state;

  const _Scope(this.state);

  @override
  int get hashCode => state.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() => "$_Scope#$hashCode";
}

enum AndrossyDialogPosition {
  top(0, -1),
  bottom(0, 1),
  left(-1, 0),
  right(1, 0),
  center(0, 0);

  final double x;
  final double y;

  const AndrossyDialogPosition(this.x, this.y);

  bool get isTop => this == top;

  bool get isBottom => this == bottom;

  bool get isLeft => this == left;

  bool get isRight => this == right;

  bool get isCenter => this == center;

  bool get isHorizontal => isLeft || isRight;

  bool get isVertical => isTop || isBottom;

  Alignment get alignment => Alignment(x, y);

  Tween<Offset> get offset {
    return Tween(begin: Offset(x, y), end: Offset.zero);
  }

  Curve get curve => isCenter ? Curves.easeInOut : _curve;

  Curve get reverseCurve => isCenter ? Curves.easeOut : _curve;

  Duration get duration => Duration(milliseconds: isCenter ? 150 : 250);

  Duration get reverseDuration => Duration(milliseconds: isCenter ? 150 : 200);
}

typedef AndrossyDialogBuilder = Widget Function(BuildContext context);

typedef AndrossyDialogTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

class AndrossyDialog extends StatefulWidget {
  final bool _animated;
  final Duration? displayDuration;
  final bool barrierDismissible;
  final Color? barrierColor;
  final double barrierBlurSigma;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? curve;
  final Curve? reverseCurve;
  final AndrossyDialogPosition position;
  final AndrossyDialogTransitionBuilder? transitionBuilder;
  final AndrossyDialogBuilder builder;
  final ValueChanged<Object?>? onDismiss;

  const AndrossyDialog._({
    super.key,
    bool animated = false,
    this.displayDuration,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierBlurSigma = 5.0,
    this.curve,
    this.reverseCurve,
    this.duration,
    this.reverseDuration,
    this.position = AndrossyDialogPosition.bottom,
    this.transitionBuilder,
    required this.builder,
    this.onDismiss,
  }) : _animated = animated;

  const AndrossyDialog({
    Key? key,
    bool barrierDismissible = true,
    Color? barrierColor,
    double barrierBlurSigma = 5,
    Duration? displayDuration,
    ValueChanged<Object?>? onDismiss,
    required AndrossyDialogBuilder builder,
  }) : this._(
          key: key,
          barrierBlurSigma: barrierBlurSigma,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          displayDuration: displayDuration,
          builder: builder,
          onDismiss: onDismiss,
        );

  const AndrossyDialog.animated({
    Key? key,
    bool barrierDismissible = true,
    Color? barrierColor,
    double barrierBlurSigma = 5,
    Duration? displayDuration,
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
    ValueChanged<Object?>? onDismiss,
    AndrossyDialogPosition position = AndrossyDialogPosition.center,
    AndrossyDialogTransitionBuilder? transitionBuilder,
    required AndrossyDialogBuilder builder,
  }) : this._(
          key: key,
          animated: true,
          barrierBlurSigma: barrierBlurSigma,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          builder: builder,
          curve: curve,
          displayDuration: displayDuration,
          duration: duration,
          position: position,
          reverseCurve: reverseCurve,
          reverseDuration: reverseDuration,
          transitionBuilder: transitionBuilder,
          onDismiss: onDismiss,
        );

  static Future<T?> show<T>({
    required BuildContext context,
    required AndrossyDialogBuilder builder,
    bool material = true,
    bool animated = true,
    bool barrierDismissible = true,
    double barrierBlurSigma = 5.0,
    Color? barrierColor,
    String? barrierLabel,
    Curve? curve,
    Curve? reverseCurve,
    Duration? duration,
    Duration? reverseDuration,
    Duration? displayDuration,
    bool useSafeArea = false,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    AndrossyDialogPosition position = AndrossyDialogPosition.center,
    AndrossyDialogTransitionBuilder? transitionBuilder,
    TraversalEdgeBehavior? traversalEdgeBehavior,

    // BOTTOM SHEET PROPERTY
    bool useModalBottomSheet = false,
    bool enableDrag = false,
    bool showDragHandle = false,
    bool isScrollControlled = false,
    AnimationStyle? sheetAnimationStyle,
    AnimationController? transitionAnimationController,
    double scrollControlDisabledMaxHeightRatio = 9.0 / 16.0,
    ShapeBorder? shape,
    double? elevation,
    Color? backgroundColor,
    BoxConstraints? constraints,
    ValueChanged<Object?>? onDismiss,
  }) {
    final child = AndrossyDialog._(
      animated: animated,
      displayDuration: displayDuration,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierBlurSigma: barrierBlurSigma,
      curve: curve,
      reverseCurve: reverseCurve,
      duration: duration,
      reverseDuration: reverseDuration,
      position: position,
      transitionBuilder: transitionBuilder,
      builder: builder,
      onDismiss: onDismiss,
    );

    if (useModalBottomSheet) {
      return showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor ?? Colors.transparent,
        barrierColor: Colors.transparent,
        barrierLabel: barrierLabel,
        constraints: constraints,
        clipBehavior: Clip.antiAlias,
        elevation: elevation,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        isDismissible: barrierDismissible,
        showDragHandle: showDragHandle,
        scrollControlDisabledMaxHeightRatio:
            scrollControlDisabledMaxHeightRatio,
        shape: shape,
        sheetAnimationStyle: sheetAnimationStyle,
        transitionAnimationController: transitionAnimationController,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        builder: (_) => child,
      ).onError((_, __) => null).then((v) => v is T ? v : null);
    }
    if (material) {
      return showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
        builder: (_) => child,
      ).onError((_, __) => null).then((v) => v is T ? v : null);
    }
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: barrierLabel,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      builder: (_) => child,
    ).onError((_, __) => null).then((v) => v is T ? v : null);
  }

  static Future<void> dismiss({
    bool? force,
    Object? result,
  }) async {
    var scope = _scopes.lastOrNull;
    if (scope == null) {
      await Future.delayed(Duration(milliseconds: 50));
      scope = _scopes.lastOrNull;
    }
    if (scope == null) return;
    await scope.state.dismiss(
      result: result,
      force: force ?? scope.state.controller.isAnimating,
    );
  }

  @override
  State<AndrossyDialog> createState() => AndrossyDialogState();
}

class AndrossyDialogState extends State<AndrossyDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  bool get isBarrierAnimationMode => widget._animated;

  bool get isDisposeTimerMode {
    return widget.displayDuration != null &&
        widget.displayDuration != Duration.zero;
  }

  final _childKey = GlobalKey(debugLabel: 'Androssy Dialog');

  Size childDimension = Size.zero;

  void _childHeight() {
    final box = _childKey.currentContext?.findRenderObject();
    if (box is RenderBox) {
      childDimension = box.size;
    }
  }

  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    if (isBarrierAnimationMode) {
      _init();
      controller.forward();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scopes.add(_Scope(this));
      _childHeight();
      _startDragging();
    });
  }

  @override
  void didUpdateWidget(covariant AndrossyDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._animated != oldWidget._animated ||
        widget.duration != oldWidget.duration ||
        widget.reverseDuration != oldWidget.reverseDuration ||
        widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve ||
        widget.position.duration != oldWidget.position.duration ||
        widget.position.reverseDuration != oldWidget.position.reverseDuration ||
        widget.position.curve != oldWidget.position.curve ||
        widget.position.reverseCurve != oldWidget.position.reverseCurve) {
      _init();
    }
  }

  void _init() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? widget.position.duration,
      reverseDuration:
          widget.reverseDuration ?? widget.position.reverseDuration,
    );
    _defaultAnimation();
  }

  void _defaultAnimation({
    Curve? curve,
    Curve? reverseCurve,
  }) {
    animation = CurvedAnimation(
      parent: controller,
      curve: curve ?? widget.curve ?? widget.position.curve,
      reverseCurve:
          reverseCurve ?? widget.reverseCurve ?? widget.position.reverseCurve,
    );
  }

  void _dragAnimation() {
    _defaultAnimation(
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );
  }

  @override
  void dispose() {
    if (isBarrierAnimationMode) {
      _dismissTimer?.cancel();
      controller.dispose();
    }
    _scopes.remove(_Scope(this));
    super.dispose();
  }

  void _startDragging() {
    if (isDisposeTimerMode) {
      setState(_dragAnimation);
      _dismissTimer = Timer(
        widget.displayDuration! + (widget.duration ?? Duration.zero),
        dismiss,
      );
    }
  }

  void _cancelDragging() {
    if (_dismissTimer != null) {
      setState(_defaultAnimation);
      _dismissTimer?.cancel();
    }
  }

  void _dismiss(Object? result) {
    if (widget.onDismiss != null) {
      widget.onDismiss!(result);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  Future<void> dismiss({Object? result, bool force = false}) async {
    if (!mounted) return;
    if (isBarrierAnimationMode) {
      if (!force) {
        await controller.reverse();
      } else {
        controller.stop();
      }
    }
    _dismiss(result);
  }

  Widget _child(BuildContext context) {
    final position = widget.position;

    Widget child = Material(
      key: _childKey,
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: widget.builder(context),
    );

    if (!position.isCenter) {
      child = _Dragging(
        position: position,
        controller: controller,
        dimension: childDimension,
        dragStart: _cancelDragging,
        dragEnd: _startDragging,
        child: child,
      );
    }

    if (widget.transitionBuilder != null) {
      child = widget.transitionBuilder!(context, animation, child);
    } else {
      if (position == AndrossyDialogPosition.center) {
        if (animation.status != AnimationStatus.reverse) {
          child = ScaleTransition(
            scale: animation.drive(Tween<double>(begin: 1.3, end: 1.0).chain(
              CurveTween(curve: Curves.linearToEaseOut),
            )),
            child: child,
          );
        }
        child = Opacity(
          opacity: animation.value,
          child: child,
        );
      } else {
        child = SlideTransition(
          position: position.offset.animate(animation),
          child: child,
        );
      }
    }

    return child;
  }

  Widget _barrier(BuildContext context, double value) {
    final theme = Theme.of(context);

    Widget child = Opacity(
      opacity: value,
      child: Container(
        color: (widget.barrierColor ??
            (theme.platform != TargetPlatform.iOS ||
                    theme.platform != TargetPlatform.macOS
                ? CupertinoDynamicColor.resolve(
                    kCupertinoModalBarrierColor, context)
                : Colors.black38)),
      ),
    );

    if (widget.barrierBlurSigma > 0) {
      child = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: widget.barrierBlurSigma * value,
          sigmaX: widget.barrierBlurSigma * value,
        ),
        child: child,
      );
    }

    if (widget.barrierDismissible) {
      child = GestureDetector(
        onTap: dismiss,
        child: child,
      );
    }

    return child;
  }

  Widget _root(BuildContext context) {
    return Stack(
      alignment: widget.position.alignment,
      children: [
        _barrier(context, animation.value),
        _child(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isBarrierAnimationMode) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => _root(context),
      );
    }
    return _root(context);
  }
}

class _Dragging extends StatelessWidget {
  final Size dimension;
  final AnimationController controller;
  final AndrossyDialogPosition position;
  final VoidCallback dragStart;
  final VoidCallback dragEnd;
  final Widget child;

  const _Dragging({
    required this.position,
    required this.dimension,
    required this.controller,
    required this.child,
    required this.dragStart,
    required this.dragEnd,
  });

  bool get _dismissUnderway => controller.status == AnimationStatus.reverse;

  void _start(DragStartDetails details) {
    dragStart();
  }

  void _update(DragUpdateDetails details) {
    if (_dismissUnderway) return;
    final value = details.primaryDelta!;
    switch (position) {
      case AndrossyDialogPosition.top:
        controller.value += value / dimension.height;
        break;
      case AndrossyDialogPosition.bottom:
        controller.value -= value / dimension.height;
        break;
      case AndrossyDialogPosition.left:
        controller.value += value / dimension.width;
        break;
      case AndrossyDialogPosition.right:
        controller.value -= value / dimension.width;
        break;

      default:
    }
  }

  void _end(DragEndDetails details) {
    if (_dismissUnderway) return;
    dragEnd();
    final x = details.velocity.pixelsPerSecond;
    final velocity = position.isVertical ? x.dy : x.dx;
    if (velocity > _minFlingVelocity) {
      final flingVelocity = -velocity / dimension.height;
      if (controller.value > 0.0) {
        controller.fling(velocity: flingVelocity);
      }
    } else if (controller.value < _closeProgressThreshold) {
      if (controller.value > 0.0) {
        controller.fling(velocity: -1.0);
      }
    } else {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: position.isVertical ? _start : null,
      onVerticalDragUpdate: position.isVertical ? _update : null,
      onVerticalDragEnd: position.isVertical ? _end : null,
      onHorizontalDragStart: position.isHorizontal ? _start : null,
      onHorizontalDragUpdate: position.isHorizontal ? _update : null,
      onHorizontalDragEnd: position.isHorizontal ? _end : null,
      child: child,
    );
  }
}
