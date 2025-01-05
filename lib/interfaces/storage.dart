import 'dart:typed_data';

abstract class Storage {
  Future<void> uploadFile(String path, Uint8List file);
  Future<Uint8List?> downloadFile(String path);
  Future<void> deleteFile(String path);
  Future<bool> fileExists(String path);
  Future<Map<String, dynamic>> getFileMetadata(String path);
}
