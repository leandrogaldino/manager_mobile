import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class CompressorModel {
  final int id;
  final int compressorId;
  final String compressorName;
  final DateTime lastUpdate;
  final PersonModel owner;
  final String serialNumber;
  final List<CoalescentModel> coalescents;

  CompressorModel({required this.id, required this.compressorId, required this.compressorName, required this.lastUpdate, required this.owner, required this.serialNumber, required this.coalescents});
}
