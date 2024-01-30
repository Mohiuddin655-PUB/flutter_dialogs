part of 'dialogs.dart';

class EditableDialogConfig extends DialogConfig {
  final TextEditingController? controller;
  final String? hint;
  final TextStyle? hintStyle;
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;

  const EditableDialogConfig({
    super.title,
    super.titleStyle,
    this.controller,
    this.hint,
    this.hintStyle,
    this.text,
    this.textAlign,
    this.style,
    String? buttonText,
    TextStyle? buttonTextStyle,
  }) : super(
          positiveButtonText: buttonText,
          positiveButtonTextStyle: buttonTextStyle,
        );

  EditableDialogConfig copy({
    TextEditingController? controller,
    String? buttonText,
    TextStyle? buttonTextStyle,
    String? title,
    TextStyle? titleStyle,
    String? hint,
    TextStyle? hintStyle,
    String? text,
    TextAlign? textAlign,
    TextStyle? textStyle,
  }) {
    return EditableDialogConfig(
      controller: controller ?? this.controller,
      buttonText: buttonText ?? positiveButtonText,
      buttonTextStyle: buttonTextStyle ?? positiveButtonTextStyle,
      title: title ?? this.title,
      titleStyle: titleStyle ?? this.titleStyle,
      hint: hint ?? this.hint,
      hintStyle: hintStyle ?? this.hintStyle,
      text: text ?? this.text,
      textAlign: textAlign ?? this.textAlign,
      style: textStyle ?? style,
    );
  }
}

class _EditableDialog extends StatefulWidget {
  final EditableDialogConfig config;

  const _EditableDialog({
    super.key,
    required this.config,
  });

  @override
  State<_EditableDialog> createState() => _EditableDialogState();
}

class _EditableDialogState extends State<_EditableDialog> {
  late EditableDialogConfig config = widget.config;
  late TextEditingController _editor;

  @override
  void initState() {
    _editor = config.controller ?? TextEditingController();
    _editor.text = config.text ?? "";
    super.initState();
  }

  @override
  void dispose() {
    if (config.controller == null) _editor.dispose();
    super.dispose();
  }

  Widget _positiveButton(BuildContext context) {
    final label = widget.config.positiveButtonText ?? "SUBMIT";
    return DialogButton(
      text: label,
      style: config.positiveButtonTextStyle,
      onClick: (_) => Navigator.pop(_, _editor.text),
    );
  }

  Widget? _title(BuildContext context) {
    final data = config.title ?? "";
    final isValid = data.isNotEmpty;
    if (!isValid) return null;
    return Text(data, style: config.titleStyle);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: CupertinoAlertDialog(
        actions: [_positiveButton(context)],
        title: _title(context),
        content: Material(
          color: Colors.transparent,
          child: TextField(
            controller: _editor,
            autofocus: true,
            textAlign: config.textAlign ?? TextAlign.center,
            style: config.style,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 16),
              isDense: false,
              isCollapsed: true,
              hintText: config.hint ?? "Type here...",
              hintStyle: config.hintStyle,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
