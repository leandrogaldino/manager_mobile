import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/oil_types.dart';
import 'package:manager_mobile/pages/evaluation/enums/part_types.dart';

class EvaluationValidators {
  EvaluationValidators._();

  static FormFieldValidator hasCustomer(PersonModel? customer, String message) {
    return (value) {
      if (customer == null) return message;
      return null;
    };
  }

  static FormFieldValidator hasCompressor(PersonModel? customer, CompressorModel? compressor, String message) {
    return (value) {
      if (customer == null) return null;
      if (compressor == null) return message;
      return null;
    };
  }

  static FormFieldValidator requiredCompressor(PersonModel? customer, CompressorModel? compressor, String message) {
    return (value) {
      if (customer == null) return null;
      if (value == '') return message;
      return null;
    };
  }

  static FormFieldValidator validPartTimeRange(OilTypes oilType, PartTypes partType) {
    return (value) {
      if (int.tryParse(value) == null) return 'Valor inválido';
      int hours = int.parse(value == '' ? '0' : value);
      switch (oilType) {
        case OilTypes.mineral:
          if (partType == PartTypes.airFilter && hours > 1000) return 'Máximo: 1000';
          if (partType == PartTypes.oilFilter && hours > 1000) return 'Máximo: 1000';
          if (partType == PartTypes.separator && hours > 3000) return 'Máximo: 3000';
          if (partType == PartTypes.oil && hours > 1000) return 'Máximo: 1000';
          return null;
        case OilTypes.semiSynthetic:
          if (partType == PartTypes.airFilter && hours > 2000) return 'Máximo: 2000';
          if (partType == PartTypes.oilFilter && hours > 2000) return 'Máximo: 2000';
          if (partType == PartTypes.separator && hours > 4000) return 'Máximo: 4000';
          if (partType == PartTypes.oil && hours > 4000) return 'Máximo: 4000';
          return null;
        case OilTypes.synthetic:
          if (partType == PartTypes.airFilter && hours > 2000) return 'Máximo: 2000';
          if (partType == PartTypes.oilFilter && hours > 2000) return 'Máximo: 2000';
          if (partType == PartTypes.separator && hours > 4000) return 'Máximo: 4000';
          if (partType == PartTypes.oil && hours > 8000) return 'Máximo: 8000';
          return null;
      }
    };
  }
}
