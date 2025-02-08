import 'package:flutter/material.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianPickerTileWidget extends StatelessWidget {
  const TechnicianPickerTileWidget({
    super.key,
    required this.technician,
    required this.onTechnicianSelected,
  });

  final PersonModel technician;
  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          technician.shortName,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.surface,
              ),
        ),
        onTap: () {
          onTechnicianSelected(technician);
        },
      ),
    );
  }
}
