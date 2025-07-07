import 'dart:ui';

import 'package:flutter/material.dart';

typedef LoaderBuilder = Widget Function(
  BuildContext context,
  Object? args,
);

class Loader {
  Loader._();

  static Loader? _i;

  static Loader get i => _i ??= Loader._();

  static void init({
    Alignment? alignment,
    bool? barrierDismissible,
    Color? barrierColor,
    double? barrierBlurSigma,
    Curve? curve,
    Curve? reverseCurve,
    Duration? duration,
    Duration? reverseDuration,
    LoaderWidgetBuilder? builder,
    LoaderTransitionBuilder? transitionBuilder,
  }) {
    i._alignment = alignment ?? i._alignment;
    i._barrierDismissible = barrierDismissible ?? i._barrierDismissible;
    i._barrierColor = barrierColor ?? i._barrierColor;
    i._barrierBlurSigma = barrierBlurSigma ?? i._barrierBlurSigma;
    i._curve = curve ?? i._curve;
    i._reverseCurve = reverseCurve ?? i._reverseCurve;
    i._duration = duration ?? i._duration;
    i._reverseDuration = reverseDuration ?? i._reverseDuration;
    i._builder = builder ?? i._builder;
    i._transitionBuilder = transitionBuilder ?? i._transitionBuilder;
  }

  BuildContext? _context;

  static set context(BuildContext? value) => i._context = value;

  static BuildContext get context {
    if (i._context != null) return i._context!;
    throw UnimplementedError("Context is required!");
  }

  BuildContext? get contextOrNull => _context;

  Alignment _alignment = const Alignment(0, 0);

  static set alignment(Alignment value) => i._alignment = value;

  bool _darkMode = true;

  static set darkMode(bool value) => i._darkMode = value;

  static bool get isDarkMode => i._darkMode;

  Color? _barrierColor;

  static set barrierColor(Color? value) => i._barrierColor = value;

  bool _barrierDismissible = false;

  static set barrierDismissible(bool value) => i._barrierDismissible = value;

  double _barrierBlurSigma = 5;

  static set barrierBlurSigma(double value) => i._barrierBlurSigma = value;

  Color? _barrierColorDark;

  static set barrierColorDark(Color? value) => i._barrierColorDark = value;

  Color get _themedBarrierColor {
    return _darkMode
        ? _barrierColorDark ?? Colors.white70
        : _barrierColor ?? Colors.black54;
  }

  Curve _curve = Cubic(0.0, 0.0, 0.2, 1.0);

  static set curve(Curve value) => i._curve = value;

  Curve? _reverseCurve;

  static set reverseCurve(Curve? value) => i._reverseCurve = value;

  Duration _duration = Duration(milliseconds: 300);

  static set duration(Duration value) => i._duration = value;

  Duration? _reverseDuration;

  static set reverseDuration(Duration? value) => i._reverseDuration = value;

  LoaderWidgetBuilder? _builder;

  static set builder(LoaderWidgetBuilder value) => i._builder = value;

  LoaderTransitionBuilder? _transitionBuilder;

  static set transitionBuilder(LoaderTransitionBuilder value) {
    i._transitionBuilder = value;
  }

  Widget _build(BuildContext context, Object? args) {
    if (_builder != null) return _builder!(context, args);

    const dimension = 120.0;
    const loaderDimension = dimension * 0.45;
    const radius = loaderDimension * 0.07;
    final background = _darkMode ? Colors.grey.shade800 : Colors.white;
    final color = _darkMode ? Colors.white : Colors.black;
    final primary = Theme.of(context).primaryColor;

    return Container(
      width: dimension,
      height: dimension,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 100,
          ),
        ],
        borderRadius: BorderRadius.circular(dimension * 0.2),
      ),
      child: Container(
        width: loaderDimension,
        height: loaderDimension,
        padding: const EdgeInsets.all(dimension * 0.025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primary.withValues(alpha: 0.1),
            width: radius,
          ),
        ),
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: radius,
          color: primary,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  static OverlayEntry? _entry;
  static final _key = GlobalKey<_LoaderWidgetState>();

  static bool get isShowing => _entry != null;

  static void show({
    BuildContext? context,
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
    if (isShowing) return;
    context ??= Loader.context;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _entry = OverlayEntry(
      builder: (context) {
        return _LoaderWidget(
          key: _key,
          alignment: alignment ?? i._alignment,
          barrierDismissible: barrierDismissible ?? i._barrierDismissible,
          barrierColor: barrierColor ?? i._themedBarrierColor,
          barrierBlurSigma: barrierBlurSigma ?? i._barrierBlurSigma,
          curve: curve ?? i._curve,
          reverseCurve: reverseCurve ?? i._reverseCurve,
          duration: duration ?? i._duration,
          reverseDuration: reverseDuration ?? i._reverseDuration,
          transitionBuilder: transitionBuilder ?? i._transitionBuilder,
          builder: builder ?? (context) => i._build(context, args),
          onDismiss: () {
            _entry?.remove();
            _entry = null;
          },
        );
      },
    );
    overlay.insert(_entry!);
  }

  /// Hide the overlay with a fade‑out (noop if none is showing).
  static Future<void> hide([bool force = false]) async {
    if (_entry == null) return;
    await _key.currentState?.dismiss(force);
  }
}

typedef LoaderWidgetBuilder = Widget Function(
  BuildContext context,
  Object? args,
);

typedef LoaderTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> anim,
  Widget? child,
);

class _LoaderWidget extends StatefulWidget {
  final Alignment alignment;
  final bool barrierDismissible;
  final Color barrierColor;
  final double barrierBlurSigma;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;
  final WidgetBuilder builder;
  final LoaderTransitionBuilder? transitionBuilder;
  final VoidCallback onDismiss;

  const _LoaderWidget({
    super.key,
    this.alignment = Alignment.center,
    this.barrierDismissible = false,
    required this.barrierColor,
    this.barrierBlurSigma = 5.0,
    required this.curve,
    this.reverseCurve,
    this.duration,
    this.reverseDuration,
    required this.builder,
    this.transitionBuilder,
    required this.onDismiss,
  });

  @override
  State<_LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<_LoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  void _init() {
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );
    _anim = CurvedAnimation(
      parent: _ctrl,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );
  }

  Future<void> dismiss([bool force = false]) async {
    if (force) {
      _ctrl.stop();
    } else {
      await _ctrl.reverse();
    }
    widget.onDismiss();
  }

  @override
  void initState() {
    super.initState();
    _init();
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant _LoaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration ||
        widget.reverseDuration != oldWidget.reverseDuration ||
        widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve) {
      _init();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Stack(
          alignment: widget.alignment,
          children: [_barrier(), _child()],
        );
      },
    );
  }

  Widget _barrier() {
    Widget child = Opacity(
      opacity: _anim.value,
      child: ModalBarrier(
        color: widget.barrierColor,
        dismissible: widget.barrierDismissible,
        onDismiss: dismiss,
      ),
    );
    if (widget.barrierBlurSigma > 0) {
      child = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: widget.barrierBlurSigma * _anim.value,
          sigmaX: widget.barrierBlurSigma * _anim.value,
        ),
        child: child,
      );
    }

    return child;
  }

  Widget _child() {
    Widget child = Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: widget.builder(context),
    );

    if (widget.transitionBuilder != null) {
      child = widget.transitionBuilder!(context, _anim, child);
    } else {
      child = Opacity(
        opacity: _anim.value,
        child: Transform.scale(
          scale: _anim.value,
          child: child,
        ),
      );
    }

    return child;
  }
}
