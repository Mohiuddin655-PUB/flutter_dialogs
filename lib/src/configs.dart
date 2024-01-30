part of 'dialogs.dart';

abstract class DialogConfig {
  final String? positiveButtonText;
  final TextStyle? positiveButtonTextStyle;
  final String? negativeButtonText;
  final TextStyle? negativeButtonTextStyle;
  final String? title;
  final TextStyle? titleStyle;
  final String? message;
  final TextStyle? messageStyle;

  const DialogConfig({
    this.positiveButtonText,
    this.positiveButtonTextStyle,
    this.negativeButtonText,
    this.negativeButtonTextStyle,
    this.title,
    this.titleStyle,
    this.message,
    this.messageStyle,
  });
}
