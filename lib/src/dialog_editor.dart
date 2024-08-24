part of 'dialogs.dart';

typedef CustomEditorDialogBuilder = Widget Function(BuildContext context);

class EditableDialogConfig extends DialogConfig {
  final CustomEditorDialogBuilder? builder;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const EditableDialogConfig({
    super.material,
    super.titleStyle,
    this.controller,
    this.hintStyle,
    this.textAlign,
    this.textStyle,
    String? buttonText,
    TextStyle? buttonTextStyle,
  })  : builder = null,
        super(
          positiveButtonText: buttonText,
          positiveButtonTextStyle: buttonTextStyle,
        );

  const EditableDialogConfig.builder(
    CustomEditorDialogBuilder this.builder, {
    super.material,
  })  : controller = null,
        hintStyle = null,
        textStyle = null,
        textAlign = null,
        super();
}

class AndrossyEditableDialog extends StatefulWidget {
  final String? title;
  final String? text;
  final String? hint;
  final EditableDialogConfig config;

  const AndrossyEditableDialog({
    super.key,
    required this.config,
    this.title,
    this.text,
    this.hint,
  });

  @override
  State<AndrossyEditableDialog> createState() => _AndrossyEditableDialogState();
}

class _AndrossyEditableDialogState extends State<AndrossyEditableDialog> {
  late EditableDialogConfig config = widget.config;
  late TextEditingController _editor;

  @override
  void initState() {
    _editor = config.controller ?? TextEditingController();
    _editor.text = widget.text ?? "";
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
    final data = widget.title ?? "";
    final isValid = data.isNotEmpty;
    if (!isValid) return null;
    return Text(data, style: config.titleStyle);
  }

  @override
  Widget build(BuildContext context) {
    if (config.builder != null) {
      return config.builder!(context);
    }
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
            style: config.textStyle,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 16),
              isDense: false,
              isCollapsed: true,
              hintText: widget.hint ?? "Type here...",
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
