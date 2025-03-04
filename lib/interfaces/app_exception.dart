abstract class AppException implements Exception {
  final String code;
  final String message;

  AppException(this.code, this.message);

  @override
  String toString() {
    return '$code\n$message';
  }
}
