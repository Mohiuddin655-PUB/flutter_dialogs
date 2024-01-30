part of 'dialogs.dart';

enum DialogType {
  alert,
  editor,
  loading,
  message;

  bool get isAlert => this == alert;

  bool get isEditor => this == editor;

  bool get isLoading => this == loading;

  bool get isMessage => this == message;
}
