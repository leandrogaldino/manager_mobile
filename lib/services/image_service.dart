import 'dart:io';
import 'dart:typed_data';
import 'package:manager_mobile/core/enums/image_types.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<String> saveTemporary(ImageTypes type, Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final finalDir = Directory('${tempDir.path}/${type.folderName}');
    await finalDir.create(recursive: true);
    final filename = StringHelper.getUniqueString(suffix: type.extension);
    final file = File('${finalDir.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  Future<String> savePermanent(ImageTypes type, String tempImagePath) async {
    final docDir = await getApplicationDocumentsDirectory();
    final finalDir = Directory('${docDir.path}/${type.folderName}');
    await finalDir.create(recursive: true);
    final filename = tempImagePath.split('/').last;
    final file = File(tempImagePath);
    final movedFile = await file.rename('${finalDir.path}/$filename');
    return movedFile.path;
  }

  Future<void> delete(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
