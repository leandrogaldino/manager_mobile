import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/compressor_picker/compressor_picker_dialog.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';

class CompressorPicker {
  static Future<PersonCompressorModel?> pick({
    required BuildContext context,
  }) async {
    PersonCompressorModel? compressor;

    if (!context.mounted) return null;
    compressor = await showDialog<PersonCompressorModel>(
      context: context,
      builder: (BuildContext context) {
        return CompressorPickerDialog();
      },
    );
    return compressor;
  }
}
