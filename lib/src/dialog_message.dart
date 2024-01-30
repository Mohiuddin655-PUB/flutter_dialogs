part of 'dialogs.dart';

class MessageDialogConfig extends DialogConfig {
  const MessageDialogConfig({
    super.message,
    super.messageStyle,
    super.title,
    super.titleStyle,
    String? buttonText,
    TextStyle? buttonTextStyle,
  }) : super(
          positiveButtonText: buttonText,
          positiveButtonTextStyle: buttonTextStyle,
        );

  MessageDialogConfig copy({
    String? buttonText,
    TextStyle? buttonTextStyle,
    String? message,
    TextStyle? messageStyle,
    String? title,
    TextStyle? titleStyle,
  }) {
    return MessageDialogConfig(
      buttonText: buttonText ?? positiveButtonText,
      buttonTextStyle: buttonTextStyle ?? positiveButtonTextStyle,
      message: message ?? this.message,
      messageStyle: messageStyle ?? this.messageStyle,
      title: title ?? this.title,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }
}

class _MessageDialog extends StatefulWidget {
  final MessageDialogConfig config;

  const _MessageDialog({
    super.key,
    required this.config,
  });

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  late MessageDialogConfig config = widget.config;

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

  Widget _button(BuildContext context) {
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
      actions: [_button(context)],
      content: _subtitle(context),
      title: _title(context),
    );
  }
}
