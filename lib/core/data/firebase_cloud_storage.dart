import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manager_mobile/core/exceptions/storage_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/storage.dart';

class FirebaseCloudStorage implements Storage {
  final _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String path, Uint8List file) async {
    try {
      final ref = _storage.ref(path);
      await ref.putData(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e, s) {
      String code = 'STO001';
      String message = 'Erro ao fazer upload do arquivo';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw StorageException(code, message);
    }
  }

  @override
  Future<Uint8List?> downloadFile(String path) async {
    try {
      final ref = _storage.ref(path);
      final Uint8List? fileData = await ref.getData();
      return fileData;
    } catch (e, s) {
      String code = 'STO002';
      String message = 'Erro ao fazer download do arquivo';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw StorageException(code, message);
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref(path);
      await ref.delete();
    } catch (e, s) {
      String code = 'STO003';
      String message = 'Erro ao deletar o arquivo';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw StorageException(code, message);
    }
  }

  @override
  Future<bool> fileExists(String path) async {
    try {
      final ref = _storage.ref(path);
      await ref.getDownloadURL();
      return true;
    } catch (e, s) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      }
      String code = 'STO004';
      String message = 'Erro ao verificar existência do arquivo';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw StorageException(code, message);
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
    } catch (e, s) {
      String code = 'STO005';
      String message = 'Erro ao obter os metadados do arquivo';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw StorageException(code, message);
    }
  }
}
