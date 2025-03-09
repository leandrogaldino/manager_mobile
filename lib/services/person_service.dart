import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class PersonService implements Readable<PersonModel>, Syncronizable {
  final PersonRepository _personRepository;

  PersonService({required PersonRepository personRepository}) : _personRepository = personRepository;

  @override
  Future<List<PersonModel>> getAll() async {
    final data = await _personRepository.getAll();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<List<PersonModel>> getCustomers() async {
    final data = await _personRepository.getCustomers();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<List<PersonModel>> getTechnicians() async {
    final data = await _personRepository.getTechnicians();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  @override
  Future<PersonModel> getById(dynamic id) async {
    final data = await _personRepository.getById(id);
    if (data.isNotEmpty) {
      return PersonModel.fromMap(data);
    } else {
      throw ServiceException('PER006', 'Pessoa com o id $id não encontrada.');
    }
  }

  @override
  Future<void> synchronize(lastSync) async {
    await _personRepository.synchronize(lastSync);
  }
}
