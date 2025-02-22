import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class PersonService implements Readable<PersonModel>, Syncronizable {
  final PersonRepository _repository;

  PersonService({required PersonRepository repository}) : _repository = repository;

  @override
  Future<List<PersonModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<List<PersonModel>> getCustomers() async {
    final data = await _repository.getCustomers();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<List<PersonModel>> getTechnicians() async {
    final data = await _repository.getTechnicians();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  @override
  Future<PersonModel> getById(dynamic id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return PersonModel.fromMap(data);
    } else {
      throw ServiceException('Pessoa com o id $id não encontrada.');
    }
  }

  @override
  Future<void> syncronize(lastSync) async {
    await _repository.syncronize(lastSync);
  }
}
