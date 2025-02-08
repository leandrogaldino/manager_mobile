import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/compressor_picker/compressor_picker_widget.dart';
import 'package:manager_mobile/models/compressor_model.dart';

class CompressorPickerDialog extends StatelessWidget {
  const CompressorPickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PersonController personController = Locator.get<PersonController>();
    List<CompressorModel> compressors = personController.customers.expand((customer) => customer.compressors).toList();
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
