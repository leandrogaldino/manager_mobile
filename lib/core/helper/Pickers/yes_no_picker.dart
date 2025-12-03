import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/yes_no_picker_dialog.dart';

class YesNoPicker {
  static Future<bool?> pick({
    required BuildContext context,
    required String question,
  }) async {
    bool? isYes;

    if (!context.mounted) return null;
    isYes = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return YesNoPickerDialog(question: question);
      },
    );

    return isYes;
  }
}
