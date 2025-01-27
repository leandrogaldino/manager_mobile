import 'package:flutter/material.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/home/widgets/technician_chose/technician_chose_tile_widget.dart';

class TechnicianChoseListWidget extends StatelessWidget {
  const TechnicianChoseListWidget({
    super.key,
    required this.technicians,
  });
  final List<PersonModel> technicians;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: technicians.length,
      itemBuilder: (context, index) {
        return TechnicianChoseTileWidget(technician: technicians[index]);
      },
    );
  }
}
