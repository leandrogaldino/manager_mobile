import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/compressor_picker/compressor_picker_widget.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class CompressorPickerDialog extends StatelessWidget {
  const CompressorPickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DataService dataService = Locator.get<DataService>();
    List<PersonCompressorModel> compressors = dataService.compressors;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          'Escolha o Compressor',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: (compressors.length > 5) ? 330 : (compressors.length * 66),
        child: CompressorPickerWidget(
          onCompressorSelected: (compressor) {
            Navigator.pop(context, compressor);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
