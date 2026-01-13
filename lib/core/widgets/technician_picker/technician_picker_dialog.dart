import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/compressor_picker/compressor_picker_widget.dart';
import 'package:manager_mobile/core/widgets/technician_picker/technician_picker_widget.dart';

class TechnicianPickerDialog extends StatelessWidget {
  const TechnicianPickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          'Escolha o Técnico',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: TechnicianPickerWidget(
          onTechnicianSelected: (compressor) {
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
