import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';

abstract class HomeState {}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateConnection extends HomeState {
  final String infoMessage;

  HomeStateConnection({required this.infoMessage});
}

class HomeStateError extends HomeState {
  final String errorMessage;
  HomeStateError(this.errorMessage);
}

class HomeStateSuccess extends HomeState {
  final PagedListController<VisitScheduleModel> schedules;
  final PagedListController<EvaluationModel> evaluations;

  HomeStateSuccess(this.schedules, this.evaluations);
}
