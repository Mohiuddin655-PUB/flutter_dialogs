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
  final Widget child;

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
    required this.child,
  }) : _animated = animated;

  const AndrossyDialog({
    Key? key,
    bool barrierDismissible = true,
    Color? barrierColor,
    double barrierBlurSigma = 5,
    Duration? displayDuration,
    required Widget child,
  }) : this._(
          key: key,
          barrierBlurSigma: barrierBlurSigma,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          displayDuration: displayDuration,
          child: child,
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
    AndrossyDialogPosition position = AndrossyDialogPosition.center,
    AndrossyDialogTransitionBuilder? transitionBuilder,
    required Widget child,
  }) : this._(
          key: key,
          animated: true,
          barrierBlurSigma: barrierBlurSigma,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          child: child,
          curve: curve,
          displayDuration: displayDuration,
          duration: duration,
          position: position,
          reverseCurve: reverseCurve,
          reverseDuration: reverseDuration,
          transitionBuilder: transitionBuilder,
        );

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool animated = true,
    Duration? autoDisposeDuration,
    bool barrierDismissible = true,
    double barrierBlurSigma = 5.0,
    Color? barrierColor,
    String? barrierLabel,
    Curve? barrierAnimationCurve,
    Curve? barrierReserveAnimationCurve,
    Duration? duration,
    Duration? reserveDuration,
    bool useSafeArea = false,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    AndrossyDialogPosition position = AndrossyDialogPosition.center,
    AndrossyDialogTransitionBuilder? transitionBuilder,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
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
      builder: (context) {
        return AndrossyDialog._(
          animated: animated,
          displayDuration: autoDisposeDuration,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierBlurSigma: barrierBlurSigma,
          curve: barrierAnimationCurve,
          reverseCurve: barrierReserveAnimationCurve,
          duration: duration,
          reverseDuration: reserveDuration,
          position: position,
          transitionBuilder: transitionBuilder,
          child: content,
        );
      },
    );
  }

  static void dismiss() => _scopes.lastOrNull?.state.dismiss();

  @override
  State<AndrossyDialog> createState() => AndrossyDialogState();
}

class AndrossyDialogState extends State<AndrossyDialog>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? widget.position.duration,
    reverseDuration: widget.reverseDuration ?? widget.position.reverseDuration,
  );

  late Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: widget.curve ?? widget.position.curve,
    reverseCurve: widget.reverseCurve,
  );

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
    if (!widget.position.isCenter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scopes.add(_Scope(this));
        _childHeight();
      });
    }
    if (isBarrierAnimationMode) {
      controller.forward();
      controller.addStatusListener(_status);
    }
    _startDisplayTimer();
  }

  @override
  void dispose() {
    if (isBarrierAnimationMode) {
      controller.removeStatusListener(_status);
      _dismissTimer?.cancel();
      controller.dispose();
    }
    _scopes.remove(_Scope(this));
    super.dispose();
  }

  void _startDisplayTimer() {
    if (isDisposeTimerMode) {
      _dismissTimer = Timer(
        widget.displayDuration! + (widget.duration ?? Duration.zero),
        dismiss,
      );
    }
  }

  void _cancelDisplayTimer() {
    if (_dismissTimer != null) {
      _dismissTimer?.cancel();
    }
  }

  void _status(AnimationStatus status) {
    if (status.isDismissed) {
      Navigator.pop(context);
    }
  }

  void dismiss() {
    if (!mounted) return;
    if (isBarrierAnimationMode) {
      controller.reverse();
    } else {
      Navigator.pop(context);
    }
  }

  Widget _child(BuildContext context) {
    final position = widget.position;

    Widget child = Material(
      key: _childKey,
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: widget.child,
    );

    if (!position.isCenter) {
      child = _Dragging(
        position: position,
        controller: controller,
        dimension: childDimension,
        dragStart: _cancelDisplayTimer,
        dragEnd: _startDisplayTimer,
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
