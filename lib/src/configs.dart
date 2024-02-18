part of 'dialogs.dart';

abstract class DialogConfig {
  final bool material;
  final String? positiveButtonText;
  final TextStyle? positiveButtonTextStyle;
  final String? negativeButtonText;
  final TextStyle? negativeButtonTextStyle;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const DialogConfig({
    this.material = false,
    this.positiveButtonText,
    this.positiveButtonTextStyle,
    this.negativeButtonText,
    this.negativeButtonTextStyle,
    this.titleStyle,
    this.messageStyle,
  });
}
