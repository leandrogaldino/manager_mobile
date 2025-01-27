import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/preferences.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianChoseTileWidget extends StatefulWidget {
  const TechnicianChoseTileWidget({
    super.key,
    required this.technician,
  });

  final PersonModel technician;

  @override
  State<TechnicianChoseTileWidget> createState() => _TechnicianChoseTileWidgetState();
}

class _TechnicianChoseTileWidgetState extends State<TechnicianChoseTileWidget> {
  late final Preferences preferences;

  @override
  void initState() {
    super.initState();
    preferences = Locator.get<Preferences>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          widget.technician.shortName,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
        ),
        onTap: () async {
          await preferences.setLoggedTechnicianId(widget.technician.id);
        },
      ),
    );
  }
}
