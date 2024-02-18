part of 'dialogs.dart';

typedef CustomSnackBarBuilder = Widget Function(
  BuildContext context,
  String message,
);

class SnackBarConfig extends DialogConfig {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final Color? background;
  final CustomSnackBarBuilder? builder;

  const SnackBarConfig({
    super.messageStyle,
    this.margin = const EdgeInsets.all(16),
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.borderRadius = 25,
    this.background,
    BoxDecoration? decoration,
  }) : builder = null;

  const SnackBarConfig.builder(CustomSnackBarBuilder this.builder)
      : margin = EdgeInsets.zero,
        padding = EdgeInsets.zero,
        borderRadius = 0,
        background = null,
        super();
}

class _SnackBar extends StatelessWidget {
  final String message;
  final SnackBarConfig config;

  const _SnackBar({
    required this.message,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (config.builder != null) {
      return config.builder!(context, message);
    }
    final theme = Theme.of(context);
    return Container(
      margin: config.margin,
      padding: config.padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(config.borderRadius),
        color: config.background ??
            theme.snackBarTheme.backgroundColor ??
            theme.primaryColor,
      ),
      child: Text(
        message,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: config.messageStyle,
      ),
    );
  }
}
