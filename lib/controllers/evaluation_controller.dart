import 'package:flutter/material.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class EvaluationController extends ChangeNotifier {
  final PersonService personService;

  List<PersonModel> _customers = [];
  EvaluationController({required this.personService});
  List<PersonModel> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await personService.getAll();
    _customers = _customers.where((person) => person.isCustomer && person.statusId == 0).toList();
    notifyListeners();
  }

  PersonModel? _selectedCustomer;
  PersonModel? get selectedCustomer => _selectedCustomer;
  void setSelectedCustomer(PersonModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }
}
