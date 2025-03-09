import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/person_service.dart';

class DataController {
  DataController({required this.personService, required this.compressorService});
  final PersonService personService;
  final CompressorService compressorService;

  List<CompressorModel> _compressors = [];
  List<CompressorModel> get compressors => _compressors;
  Future<void> fetchCompressors() async {
    _compressors = await compressorService.getVisibles();
  }

  List<PersonModel> _technicians = [];
  List<PersonModel> get technicians => _technicians;
  Future<void> fetchTechnicians() async {
    _technicians = await personService.getTechnicians();
    _technicians = _technicians.where((person) => person.visible == true).toList();
    technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
  }
}
