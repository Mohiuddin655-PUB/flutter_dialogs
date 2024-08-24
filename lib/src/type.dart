part of 'dialogs.dart';

enum DialogType {
  alert,
  editor,
  loader,
  message,
  snackBar,
  snackBarError,
  snackBarInfo,
  snackBarWaiting,
  snackBarWarning;

  bool get isAlert => this == alert;

  bool get isEditor => this == editor;

  bool get isLoader => this == loader;

  bool get isMessage => this == message;

  bool get isSnackBar => this == snackBar;

  bool get isErrorSnackBar => this == snackBarError;

  bool get isInfoSnackBar => this == snackBarInfo;

  bool get isWaitingSnackBar => this == snackBarWaiting;

  bool get isWarningSnackBar => this == snackBarWarning;
}
