import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';

class FilterService {
  String text = '';
  DateTimeRange? dateRange;

  FilteredResult applyFilters({
    required List<VisitScheduleModel> visitSchedules,
    required List<EvaluationModel> evaluations,
  }) {
    var filteredVisits = visitSchedules;
    var filteredEvals = evaluations;

    // Filtra pelo texto
    if (text.isNotEmpty) {
      final t = text.toLowerCase();
      filteredVisits = filteredVisits.where((v) =>
        v.customer.shortName.toLowerCase().contains(t) ||
        v.compressor.compressor.name.toLowerCase().contains(t) ||
        v.compressor.serialNumber.toLowerCase().contains(t) ||
        v.compressor.patrimony.toLowerCase().contains(t) ||
        v.compressor.sector.toLowerCase().contains(t) ||
        v.technician.shortName.toLowerCase().contains(t)
      ).toList();

      filteredEvals = filteredEvals.where((e) =>
        e.compressor!.person.shortName.toLowerCase().contains(t) ||
        e.compressor!.compressor.name.toLowerCase().contains(t) ||
        e.compressor!.serialNumber.toLowerCase().contains(t) ||
        e.compressor!.patrimony.toLowerCase().contains(t) ||
        e.compressor!.sector.toLowerCase().contains(t) ||
        e.technicians.any((tn) => tn.technician.shortName.toLowerCase().contains(t))
      ).toList();
    }

    // Filtra por data
    if (dateRange != null) {
      filteredVisits = filteredVisits.where((v) =>
        !v.scheduleDate.isBefore(dateRange!.start) &&
        !v.scheduleDate.isAfter(dateRange!.end)
      ).toList();

      filteredEvals = filteredEvals.where((e) =>
        !e.creationDate!.isBefore(dateRange!.start) &&
        !e.creationDate!.isAfter(dateRange!.end)
      ).toList();
    }

    return FilteredResult(filteredVisits, filteredEvals);
  }
}

class FilteredResult {
  final List<VisitScheduleModel> visitSchedules;
  final List<EvaluationModel> evaluations;
  FilteredResult(this.visitSchedules, this.evaluations);
}
