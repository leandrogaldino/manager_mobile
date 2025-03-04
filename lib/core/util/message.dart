import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Message {
  static void showErrorSnackbar({
    required BuildContext context,
    required String message,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      snackBar: CustomSnackBar.error(
        message: message,
        maxLines: 20,
      ),
      position: position,
    );
  }

  static void showInfoSnackbar({
    required BuildContext context,
    required String message,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      snackBar: CustomSnackBar.info(
        message: message,
        maxLines: 10,
      ),
      position: position,
    );
  }

  static void showSuccessSnackbar({
    required BuildContext context,
    required String message,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      snackBar: CustomSnackBar.success(
        message: message,
        maxLines: 10,
      ),
      position: position,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required CustomSnackBar snackBar,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      snackBar,
      snackBarPosition: position,
    );
  }
}
