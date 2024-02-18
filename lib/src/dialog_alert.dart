part of 'dialogs.dart';

typedef CustomAlertDialogBuilder = Widget Function(
  BuildContext context,
  String? title,
  String? message,
);

class AlertDialogConfig extends DialogConfig {
  final CustomAlertDialogBuilder? builder;

  const AlertDialogConfig({
    super.material,
    super.negativeButtonText,
    super.negativeButtonTextStyle,
    super.positiveButtonText,
    super.positiveButtonTextStyle,
    super.messageStyle,
    super.titleStyle,
  }) : builder = null;

  const AlertDialogConfig.builder(
    CustomAlertDialogBuilder this.builder, {
    super.material,
  }) : super();
}

class _AlertDialog extends StatefulWidget {
  final String? title;
  final String? message;
  final AlertDialogConfig config;

  const _AlertDialog({
    required this.config,
    required this.title,
    required this.message,
  });

  @override
  State<_AlertDialog> createState() => _AlertDialogState();
}

class _AlertDialogState extends State<_AlertDialog> {
  late AlertDialogConfig config = widget.config;

  Widget? _title(BuildContext context) {
    final data = widget.title ?? "";
    final isValid = data.isNotEmpty;
    if (!isValid) return null;
    return Text(data, style: config.titleStyle);
  }

  Widget? _subtitle(BuildContext context) {
    final value = widget.message ?? "";
    final isValid = value.isNotEmpty;
    if (!isValid) return null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        style: config.messageStyle ?? Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _negativeButton(BuildContext context) {
    final label = widget.config.negativeButtonText ?? "CANCEL";
    return DialogButton(
      text: label,
      style: config.negativeButtonTextStyle,
      onClick: (_) => Navigator.pop(_, false),
    );
  }

  Widget _positiveButton(BuildContext context) {
    final label = widget.config.positiveButtonText ?? "OK";
    return DialogButton(
      text: label,
      style: config.positiveButtonTextStyle,
      onClick: (_) => Navigator.pop(_, true),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (config.builder != null) {
      return config.builder!(context, widget.title, widget.message);
    }
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: CupertinoAlertDialog(
        actions: [_negativeButton(context), _positiveButton(context)],
        content: _subtitle(context),
        title: _title(context),
      ),
    );
  }
}
