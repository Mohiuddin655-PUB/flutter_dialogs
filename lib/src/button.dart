import 'package:flutter/material.dart';

typedef OnDialogButtonClick = void Function(BuildContext context);

class DialogButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Widget? child;
  final EdgeInsets padding;
  final OnDialogButtonClick? onClick;

  const DialogButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    this.text = "OK",
    this.style,
    this.child,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: GestureDetector(
        onTap: onClick != null ? () => onClick?.call(context) : null,
        child: Container(
          alignment: Alignment.center,
          padding: padding,
          color: Colors.transparent,
          child: child ??
              Text(
                text,
                style: style ??
                    const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
        ),
      ),
    );
  }
}
