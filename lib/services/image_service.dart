import 'dart:io';
import 'dart:typed_data';
import 'package:manager_mobile/core/enums/image_types.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static const _tempFolder = 'temp';

  Future<String> saveTemporary(ImageTypes type, Uint8List imageBytes) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final finalDir = Directory('${tempDir.path}/$_tempFolder');
    await finalDir.create(recursive: true);
    final filename = StringHelper.getUniqueString(suffix: type.extension);
    final file = File('${finalDir.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  Future<String> savePermanentFromPath({required ImageTypes type, required String tempImagePath}) async {
    final docDir = await getApplicationDocumentsDirectory();
    final finalDir = Directory('${docDir.path}/${type.folderName}');
    await finalDir.create(recursive: true);
    final filename = path.basename(tempImagePath);
    final file = File(tempImagePath);
    final movedFile = await file.rename('${finalDir.path}/$filename');
    return movedFile.path;
  }

  Future<String> savePermanentFromBytes({required ImageTypes type, required String filename, required Uint8List imageBytes}) async {
    final docDir = await getApplicationDocumentsDirectory();
    final finalDir = Directory('${docDir.path}/${type.folderName}');
    await finalDir.create(recursive: true);
    final file = File('${finalDir.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  Future<void> delete(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> cleanTemporaryDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final tempDir = Directory('${documentsDir.path}/$_tempFolder');
    if (!await tempDir.exists()) {
      return;
    }
    await tempDir.delete(recursive: true);
    await tempDir.create(recursive: true);
  }
}
