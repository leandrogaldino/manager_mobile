import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class TypeAheadCompressorTileWidget extends StatelessWidget {
  const TypeAheadCompressorTileWidget({super.key, required this.customer, required this.compressor});

  final PersonModel customer;
  final CompressorModel compressor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(compressor.compressorName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: compressor.serialNumber == '',
            child: Text(compressor.serialNumber),
          ),
          Text(customer.shortName.length > 12 ? '${customer.shortName.substring(0, 12)}...' : customer.shortName),
          Offstage(
            offstage: compressor.sector == '',
            child: Text(compressor.sector.length > 12 ? '${compressor.sector.substring(0, 12)}...' : compressor.sector),
          ),
        ],
      ),
    );
  }
}
