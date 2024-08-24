part of 'dialogs.dart';

typedef CustomMessageDialogBuilder = Widget Function(
  BuildContext context,
  String? title,
  String? message,
);

class MessageDialogConfig extends DialogConfig {
  final CustomMessageDialogBuilder? builder;

  const MessageDialogConfig({
    super.material,
    super.messageStyle,
    super.titleStyle,
    String? buttonText,
    TextStyle? buttonTextStyle,
  })  : builder = null,
        super(
          positiveButtonText: buttonText,
          positiveButtonTextStyle: buttonTextStyle,
        );

  const MessageDialogConfig.builder(
    CustomMessageDialogBuilder this.builder, {
    super.material,
  }) : super();
}

class AndrossyMessageDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final MessageDialogConfig config;
  final int _type;

  const AndrossyMessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.config,
  }) : _type = 0;

  const AndrossyMessageDialog.cupertino({
    super.key,
    required this.title,
    required this.message,
    required this.config,
  }) : _type = 1;

  const AndrossyMessageDialog.material({
    super.key,
    required this.title,
    required this.message,
    required this.config,
  }) : _type = 2;

  @override
  Widget build(BuildContext context) {
    if (_type == 1) {
      return _CupertinoMessageDialog(
        title: title,
        message: message,
        config: config,
      );
    } else if (_type == 2) {
      return _MaterialMessageDialog(
        title: title,
        message: message,
        config: config,
      );
    } else {
      return Platform.isIOS || Platform.isMacOS
          ? _CupertinoMessageDialog(
              title: title,
              message: message,
              config: config,
            )
          : _MaterialMessageDialog(
              title: title,
              message: message,
              config: config,
            );
    }
  }
}

class _MaterialMessageDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final MessageDialogConfig config;

  const _MaterialMessageDialog({
    required this.title,
    required this.message,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (config.builder != null) {
      return config.builder!(context, title, message);
    }
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 12,
              left: 32,
              right: 32,
            ),
            child: Text(
              message ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          DialogButton(
            material: true,
            text: config.positiveButtonText ?? "OK",
            style: config.positiveButtonTextStyle,
            onClick: (_) => Navigator.pop(_, true),
          ),
        ],
      ),
    );
  }
}

class _CupertinoMessageDialog extends StatefulWidget {
  final String? title;
  final String? message;
  final MessageDialogConfig config;

  const _CupertinoMessageDialog({
    required this.title,
    required this.message,
    required this.config,
  });

  @override
  State<_CupertinoMessageDialog> createState() =>
      _CupertinoMessageDialogState();
}

class _CupertinoMessageDialogState extends State<_CupertinoMessageDialog> {
  late MessageDialogConfig config = widget.config;

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
    if (config.builder != null) {
      return config.builder!(context, widget.title, widget.message);
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: CupertinoAlertDialog(
        actions: [_button(context)],
        content: _subtitle(context),
        title: _title(context),
      ),
    );
  }
}
