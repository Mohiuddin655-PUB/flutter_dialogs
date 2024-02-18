import 'package:flutter/material.dart';

import 'dialogs.dart';

extension DialogsHelper on BuildContext {
  Future<bool> showAlert({String? title, String? message}) {
    return Dialogs.i.alert(this, title: title, message: message);
  }

  Future<String> showEditor({String? title, String? text, String? hint}) {
    return Dialogs.i.editor(this, title: title, text: text, hint: hint);
  }

  Future<bool> showLoader([bool status = true]) {
    return Dialogs.i.loader(this, status: status);
  }

  Future<bool> showMessage(String? message, {String? title}) {
    return Dialogs.i.message(this, message, title: title);
  }

  void showSnackBar(String message) {
    Dialogs.i.snackBar(this, message);
  }

  void showErrorSnackBar(String error) {
    Dialogs.i.snackBarError(this, error);
  }

  void showWarningSnackBar(String message) {
    Dialogs.i.snackBarWarning(this, message);
  }
}
