part of 'dialogs.dart';

class AlertDialogConfig extends DialogConfig {
  const AlertDialogConfig({
    super.negativeButtonText,
    super.negativeButtonTextStyle,
    super.positiveButtonText,
    super.positiveButtonTextStyle,
    super.message,
    super.messageStyle,
    super.title,
    super.titleStyle,
  });

  AlertDialogConfig copy({
    String? negativeButtonText,
    TextStyle? negativeButtonTextStyle,
    String? positiveButtonText,
    TextStyle? positiveButtonTextStyle,
    String? message,
    TextStyle? messageStyle,
    String? title,
    TextStyle? titleStyle,
  }) {
    return AlertDialogConfig(
      negativeButtonText: negativeButtonText ?? this.negativeButtonText,
      negativeButtonTextStyle:
          negativeButtonTextStyle ?? this.negativeButtonTextStyle,
      positiveButtonText: positiveButtonText ?? this.positiveButtonText,
      positiveButtonTextStyle:
          positiveButtonTextStyle ?? this.positiveButtonTextStyle,
      message: message ?? this.message,
      messageStyle: messageStyle ?? this.messageStyle,
      title: title ?? this.title,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }
}

class _AlertDialog extends StatefulWidget {
  final AlertDialogConfig config;

  const _AlertDialog({
    super.key,
    required this.config,
  });

  @override
  State<_AlertDialog> createState() => _AlertDialogState();
}

class _AlertDialogState extends State<_AlertDialog> {
  late AlertDialogConfig config = widget.config;

  Widget? _title(BuildContext context) {
    final data = config.title ?? "";
    final isValid = data.isNotEmpty;
    if (!isValid) return null;
    return Text(data, style: config.titleStyle);
  }

  Widget? _subtitle(BuildContext context) {
    final value = config.message ?? "";
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
    return CupertinoAlertDialog(
      actions: [_negativeButton(context), _positiveButton(context)],
      content: _subtitle(context),
      title: _title(context),
    );
  }
}
