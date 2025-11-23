import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class CompressorPickerWidget extends StatefulWidget {
  const CompressorPickerWidget({
    super.key,
    required this.onCompressorSelected,
  });
  final ValueChanged<PersonCompressorModel> onCompressorSelected;

  @override
  State<CompressorPickerWidget> createState() => _CompressorPickerWidgetState();
}

class _CompressorPickerWidgetState extends State<CompressorPickerWidget> {
  late final TextEditingController _customerOrCompressorEC;
  late final DataService _dataService;
  late List<PersonCompressorModel> filteredCompressors;

  @override
  void initState() {
    super.initState();
    _customerOrCompressorEC = TextEditingController();
    _dataService = Locator.get<DataService>();
    filteredCompressors = _dataService.compressors;
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
              filteredCompressors = _dataService.compressors.where((compressor) {
                return compressor.compressor.name.toLowerCase().contains(value) ||
                    compressor.serialNumber.toLowerCase().contains(value) ||
                    compressor.sector.toLowerCase().contains(value) ||
                    compressor.person.shortName.toLowerCase().contains(value) ||
                    compressor.person.document.toLowerCase().contains(value);
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
                  title: Text(filteredCompressors[index].compressor.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Offstage(
                        offstage: filteredCompressors[index].serialNumber == '',
                        child: Text(filteredCompressors[index].serialNumber),
                      ),
                      Text(filteredCompressors[index].person.shortName),
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
