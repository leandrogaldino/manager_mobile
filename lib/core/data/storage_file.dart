import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manager_mobile/core/exceptions/storage_exception.dart';
import 'package:manager_mobile/interfaces/storage.dart';

class StorageFile implements Storage {
  final _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String path, Uint8List file) async {
    try {
      final ref = _storage.ref(path);
      await ref.putData(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException('STO001', 'Erro ao fazer upload do arquivo.');
    }
  }

  @override
  Future<Uint8List?> downloadFile(String path) async {
    try {
      final ref = _storage.ref(path);
      final Uint8List? fileData = await ref.getData();
      return fileData;
    } catch (e) {
      throw StorageException('STO002', 'Erro ao fazer download do arquivo.');
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref(path);
      await ref.delete();
    } catch (e) {
      throw StorageException('STO003', 'Erro ao deletar o arquivo.');
    }
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final ref = _storage.ref(path);
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      }
      throw StorageException('STO004', 'Erro ao verificar existência do arquivo: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFileMetadata(String path) async {
    try {
      final ref = _storage.ref(path);
      final metadata = await ref.getMetadata();
      return {
        'name': metadata.name,
        'path': metadata.fullPath,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'creationTime': metadata.timeCreated,
        'updatedTime': metadata.updated,
      };
    } catch (e) {
      throw StorageException('STO005', 'Erro ao obter os metadados do arquivo.');
    }
  }
}
