import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';

abstract class HomeState {}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateInfo extends HomeState {
  final String infoMessage;

  HomeStateInfo({required this.infoMessage});
}

class HomeStateError extends HomeState {
  final String errorMessage;
  HomeStateError(this.errorMessage);
}

class HomeStateSuccess extends HomeState {
  final List<VisitScheduleModel> schedules;
  final List<EvaluationModel> evaluations;

  HomeStateSuccess(this.schedules, this.evaluations);
}
