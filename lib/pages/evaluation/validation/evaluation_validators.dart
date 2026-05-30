import 'package:flutter/material.dart';
import 'package:manager_mobile/core/enums/part_types.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';

class EvaluationValidators {
  EvaluationValidators._();
  static FormFieldValidator validPartTimeRange(PersonCompressorModel? compressor, PartTypes partType) {
    return (value) {
      if (compressor == null) return null;

      if (partType == PartTypes.airFilter && int.parse(value) > compressor.airFilterCapacity) return 'Máximo: ${compressor.airFilterCapacity}';

      if (partType == PartTypes.oilFilter && int.parse(value) > compressor.oilFilterCapacity) return 'Máximo: ${compressor.oilFilterCapacity}';

      if (partType == PartTypes.separator && int.parse(value) > compressor.separatorCapacity) return 'Máximo: ${compressor.separatorCapacity}';

      if (partType == PartTypes.oil && int.parse(value) > compressor.oilCapacity) return 'Máximo: ${compressor.oilCapacity}';

      if (partType == PartTypes.greasing && compressor.greasingCapacity != null && int.parse(value) > compressor.greasingCapacity!) return 'Máximo: ${compressor.greasingCapacity}';

      return null;
    };
  }
}
