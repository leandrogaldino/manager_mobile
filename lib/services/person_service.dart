import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class PersonService implements Readable<PersonModel>, Writable<PersonModel>, Deletable, Syncronizable {
  final PersonRepository _repository;

  PersonService({required PersonRepository repository}) : _repository = repository;

  @override
  Future<int> delete(dynamic id) async {
    return await _repository.delete(id as int);
  }

  @override
  Future<List<PersonModel>> getAll() async {
    final data = await _repository.getAll();
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
  Future<List<PersonModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _repository.getByLastUpdate(lastUpdate);
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  @override
  Future<int> save(PersonModel model) async {
    final data = model.toMap();
    return await _repository.save(data);
  }

  @override
  Future<SyncronizeResultModel> syncronize(lastSync) async {
    return _repository.syncronize(lastSync);
  }
}
