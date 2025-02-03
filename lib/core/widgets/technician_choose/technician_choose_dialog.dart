import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/technician_choose/technician_choose_list_widget.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianChooseDialog extends StatelessWidget {
  final List<PersonModel> technicians;

  const TechnicianChooseDialog({
    super.key,
    required this.technicians,
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
        height: (technicians.length > 5) ? 330 : (technicians.length * 66),
        child: TechnicianChooseListWidget(
          technicians: technicians,
          onTechnicianSelected: (PersonModel selectedTechnician) {
            Navigator.pop(context, selectedTechnician);
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
