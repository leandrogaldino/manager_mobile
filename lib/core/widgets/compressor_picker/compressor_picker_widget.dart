import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/compressor_model.dart';

class CompressorPickerWidget extends StatefulWidget {
  const CompressorPickerWidget({
    super.key,
    required this.onCompressorSelected,
  });
  final ValueChanged<CompressorModel> onCompressorSelected;

  @override
  State<CompressorPickerWidget> createState() => _CompressorPickerWidgetState();
}

class _CompressorPickerWidgetState extends State<CompressorPickerWidget> {
  late final TextEditingController _customerOrCompressorEC;
  late final DataController _dataController;
  late List<CompressorModel> filteredCompressors;

  @override
  void initState() {
    super.initState();
    _customerOrCompressorEC = TextEditingController();
    _dataController = Locator.get<DataController>();
    filteredCompressors = _dataController.compressors;
  }

  @override
  void dispose() {
    _customerOrCompressorEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _customerOrCompressorEC,
          decoration: InputDecoration(labelText: 'Cliente/Compressor'),
          onChanged: (value) {
            setState(() {
              filteredCompressors = _dataController.compressors.where((compressor) {
                return compressor.compressorName.toLowerCase().contains(value) ||
                    compressor.serialNumber.toLowerCase().contains(value) ||
                    compressor.sector.toLowerCase().contains(value) ||
                    compressor.owner.shortName.toLowerCase().contains(value) ||
                    compressor.owner.document.toLowerCase().contains(value);
              }).toList();
            });
          },
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: filteredCompressors.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredCompressors[index].compressorName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Offstage(
                        offstage: filteredCompressors[index].serialNumber == '',
                        child: Text(filteredCompressors[index].serialNumber),
                      ),
                      Text(filteredCompressors[index].owner.shortName),
                      Offstage(
                        offstage: filteredCompressors[index].sector == '',
                        child: Text(filteredCompressors[index].sector),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                  onTap: () {
                    widget.onCompressorSelected(filteredCompressors[index]);
                  },
                );
              }),
        )
      ],
    );
  }
}
