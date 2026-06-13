enum ImageTypes {
  photo,
  signature;

  String get extension {
    switch (this) {
      case ImageTypes.photo:
        return '.jpg';
      case ImageTypes.signature:
        return '.png';
    }
  }

  String get folderName {
    switch (this) {
      case ImageTypes.photo:
        return 'photos';
      case ImageTypes.signature:
        return 'signatures';
    }
  }
}
