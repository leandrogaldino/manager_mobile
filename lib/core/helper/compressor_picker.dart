import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/compressor_picker/compressor_picker_dialog.dart';
import 'package:manager_mobile/models/compressor_model.dart';

class CompressorPicker {
  static Future<CompressorModel?> pick({
    required BuildContext context,
  }) async {
    CompressorModel? compressor;

    if (!context.mounted) return null;
    compressor = await showDialog<CompressorModel>(
      context: context,
      builder: (BuildContext context) {
        return CompressorPickerDialog();
      },
    );

    return compressor;
  }
}
