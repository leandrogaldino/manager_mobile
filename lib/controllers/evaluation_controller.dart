import 'package:flutter/material.dart';

class EvaluationController extends ChangeNotifier {
  bool _isReadingSectionExpanded = false;
  bool _isCoalescentSectionExpanded = false;
  bool _isTechnicianSectionExpanded = false;
  bool _isPhotoSectionExpanded = false;
  bool _isSignatureSectionExpanded = false;

  bool get isReadingSectionExpanded => _isReadingSectionExpanded;
  bool get isCoalescentSectionExpanded => _isCoalescentSectionExpanded;
  bool get isTechnicianSectionExpanded => _isTechnicianSectionExpanded;
  bool get isPhotoSectionExpanded => _isPhotoSectionExpanded;
  bool get isSignatureSectionExpanded => _isSignatureSectionExpanded;

  void toggleReadingSection() {
    _isReadingSectionExpanded = !isReadingSectionExpanded;
    notifyListeners();
  }

  void toggleCoalescentSection() {
    _isCoalescentSectionExpanded = !isCoalescentSectionExpanded;
    notifyListeners();
  }

  void toggleTechnicianSection() {
    _isTechnicianSectionExpanded = !isTechnicianSectionExpanded;
    notifyListeners();
  }

  void togglePhotoSection() {
    _isPhotoSectionExpanded = !isPhotoSectionExpanded;
    notifyListeners();
  }

  void toggleSignatureSection() {
    _isSignatureSectionExpanded = !isSignatureSectionExpanded;
    notifyListeners();
  }
}
