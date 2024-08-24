import 'dart:async';

import 'package:flutter/material.dart';

typedef AndrossyOverlaySnackBarBuilder = Widget Function(
  BuildContext context,
  Animation controller,
);

enum AndrossyOverlaySnackBarDismissType { swipe, none }

enum AndrossyOverlaySnackBarPosition {
  top,
  bottom;

  bool get isTop => this == top;

  bool get isBottom => this == bottom;
}

class AndrossyOverlaySnackBar extends StatefulWidget {
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Duration displayDuration;
  final bool persistent;
  final EdgeInsets padding;
  final Curve curve;
  final Curve reverseCurve;
  final AndrossyOverlaySnackBarDismissType dismissType;
  final List<DismissDirection> dismissDirections;
  final Offset offset;
  final VoidCallback? onDismissed;
  final AndrossyOverlaySnackBarBuilder builder;
  final AndrossyOverlaySnackBarPosition position;

  const AndrossyOverlaySnackBar({
    super.key,
    required this.builder,
    this.onDismissed,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.reverseAnimationDuration = const Duration(milliseconds: 550),
    this.displayDuration = const Duration(milliseconds: 3000),
    this.padding = const EdgeInsets.all(16),
    this.curve = Curves.elasticOut,
    this.reverseCurve = Curves.linearToEaseOut,
    this.dismissDirections = const [DismissDirection.up],
    this.offset = const Offset(0, -1),
    this.persistent = false,
    this.dismissType = AndrossyOverlaySnackBarDismissType.swipe,
    this.position = AndrossyOverlaySnackBarPosition.top,
  });

  static void show(
    BuildContext context, {
    required AndrossyOverlaySnackBarBuilder builder,
    Duration animationDuration = const Duration(milliseconds: 1200),
    Duration reverseAnimationDuration = const Duration(milliseconds: 550),
    Duration displayDuration = const Duration(milliseconds: 3000),
    EdgeInsets padding = const EdgeInsets.all(16),
    Curve curve = Curves.elasticOut,
    Curve reverseCurve = Curves.linearToEaseOut,
    List<DismissDirection> dismissDirections = const [DismissDirection.up],
    Offset offset = const Offset(0, -1),
    bool persistent = false,
    ControllerCallback? onAnimationControllerInit,
    VoidCallback? onDismissed,
    AndrossyOverlaySnackBarDismissType dismissType =
        AndrossyOverlaySnackBarDismissType.swipe,
    AndrossyOverlaySnackBarPosition position =
        AndrossyOverlaySnackBarPosition.top,
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => AndrossyOverlaySnackBar(
        animationDuration: animationDuration,
        reverseAnimationDuration: reverseAnimationDuration,
        displayDuration: displayDuration,
        padding: padding,
        position: position,
        curve: curve,
        reverseCurve: reverseCurve,
        dismissDirections: dismissDirections,
        offset: offset,
        persistent: persistent,
        dismissType: dismissType,
        onDismissed: () {
          if (onDismissed != null) onDismissed();
          overlayEntry.remove();
        },
        builder: builder,
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  State<AndrossyOverlaySnackBar> createState() =>
      _AndrossyOverlaySnackBarState();
}

class _AndrossyOverlaySnackBarState extends State<AndrossyOverlaySnackBar>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _offsetAnimation;
  late final AnimationController _animationController;

  Timer? _timer;

  late final _offsetTween = widget.position.isTop
      ? Tween(begin: widget.offset, end: Offset.zero)
      : Tween(end: widget.offset, begin: Offset.zero);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !widget.persistent) {
        _timer = Timer(widget.displayDuration, () {
          if (mounted) {
            _animationController.reverse();
          }
        });
      }
      if (status == AnimationStatus.dismissed) {
        _timer?.cancel();
        if (widget.onDismissed != null) widget.onDismissed!();
      }
    });

    _offsetAnimation = _offsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    );
    if (mounted) {
      _animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.isTop ? widget.padding.top : null,
      bottom: widget.position.isBottom ? widget.padding.bottom : null,
      left: widget.padding.left,
      right: widget.padding.right,
      child: SlideTransition(
        position: _offsetAnimation,
        child: SafeArea(
          child: _child(context),
        ),
      ),
    );
  }

  Widget _child(BuildContext context) {
    Widget child = widget.builder(context, _animationController.view);
    switch (widget.dismissType) {
      case AndrossyOverlaySnackBarDismissType.swipe:
        for (final direction in widget.dismissDirections) {
          child = Dismissible(
            direction: direction,
            key: UniqueKey(),
            dismissThresholds: const {DismissDirection.up: 0.2},
            confirmDismiss: (direction) async {
              if (!widget.persistent && mounted) {
                if (direction == DismissDirection.down) {
                  await _animationController.reverse();
                } else {
                  _animationController.reset();
                }
              }
              return false;
            },
            child: child,
          );
        }
        return child;
      case AndrossyOverlaySnackBarDismissType.none:
        return child;
    }
  }
}
