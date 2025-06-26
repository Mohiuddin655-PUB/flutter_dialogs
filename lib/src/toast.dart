import 'package:flutter/material.dart';

typedef ToastBuilder = Widget Function(
  BuildContext context,
  String msg,
  Object? args,
);

/// ```dart
/// void initToast() {
///   Toast.alignment = Alignment(0, 0.9);
///   Toast.duration = Duration(seconds: 5);
///   Toast.builder = (context, msg, args) {
///     return Container(
///       decoration: BoxDecoration(
///         color: Colors.black87,
///         borderRadius: BorderRadius.circular(8),
///         border: Border.all(color: Colors.red, width: 2),
///       ),
///       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
///       child: Column(
///         mainAxisSize: MainAxisSize.min,
///         children: [
///           Text(msg, style: TextStyle(color: Colors.white, fontSize: 16)),
///           if (args != null)
///             Text(
///               args.toString(),
///               style: TextStyle(color: Colors.white, fontSize: 12),
///             ),
///         ],
///       ),
///     );
///   };
/// }
/// ```
class Toast {
  Toast._();

  static Toast? _i;

  static Toast get i => _i ??= Toast._();

  Alignment _alignment = const Alignment(0, 0.9);

  /// ```
  /// Toast.alignment = Alignment(0, 0.9);
  static set alignment(Alignment value) => i._alignment = value;

  ToastBuilder? _builder;

  /// ```
  /// Toast.builder = (context, msg, args) {
  ///   return Container(
  ///     decoration: BoxDecoration(
  ///       color: Colors.black87,
  ///       borderRadius: BorderRadius.circular(8),
  ///       border: Border.all(color: Colors.red, width: 2),
  ///     ),
  ///     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ///     child: Column(
  ///       mainAxisSize: MainAxisSize.min,
  ///       children: [
  ///         Text(msg, style: TextStyle(color: Colors.white, fontSize: 16)),
  ///         if (args != null)
  ///           Text(
  ///             args.toString(),
  ///             style: TextStyle(color: Colors.white, fontSize: 12),
  ///           ),
  ///       ],
  ///     ),
  ///   );
  /// };
  static set builder(ToastBuilder value) => i._builder = value;

  Widget _build(BuildContext context, String msg, Object? args) {
    if (_builder != null) return _builder!(context, msg, args);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _darkMode ? Colors.white70 : Colors.black87,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        msg,
        style: TextStyle(
          color: _darkMode ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  BuildContext? _context;

  /// ```
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   WidgetsBinding.instance.addPostFrameCallback((_){
  ///     Toast.context = context;
  ///   });
  /// }
  ///
  /// Or,
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   Toast.context = context;
  ///   ...
  /// }
  static set context(BuildContext? value) => i._context = value;

  static BuildContext get context {
    if (i._context != null) return i._context!;
    throw UnimplementedError("Context is required!");
  }

  BuildContext? get contextOrNull => _context;

  bool _darkMode = false;

  /// ```
  /// Toast.darkMode = true/false; // Depend on theme
  ///
  /// Or,
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   Toast.darkMode = Theme.of(context).brightness == Brightness.dark;
  ///   ...
  /// }
  static set darkMode(bool value) => i._darkMode = value;

  static bool get isDarkMode => i._darkMode;

  Duration _duration = Duration(seconds: 3);

  /// ```
  /// Toast.duration = Duration(seconds: 5);
  static set duration(Duration value) => i._duration = value;

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
  static void show(
    String msg, {
    BuildContext? context,
    Duration? duration,
    Alignment? alignment,
    Object? args,
    Widget? custom,
  }) {
    context ??= Toast.context;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        duration: duration ?? i._duration,
        onDismiss: entry.remove,
        child: Align(
          alignment: alignment ?? i._alignment,
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: custom ?? i._build(context, msg, args),
          ),
        ),
      ),
    );
    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onDismiss;
  final Widget child;

  const _ToastWidget({
    required this.duration,
    required this.onDismiss,
    required this.child,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Future.delayed(widget.duration, () async {
      await _controller.reverse();
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}
