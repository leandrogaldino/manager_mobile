enum PhotoState {
  empty,
  downloading,
  cloud,
  local,
  temp;

  static PhotoState getPhotoState(String? tempPath, String? localPath, String? cloudPath, Set<String> downloadingImages) {
    if (cloudPath != null && downloadingImages.contains(cloudPath)) return PhotoState.downloading;
    if (tempPath != null) return PhotoState.temp;
    if (localPath != null) return PhotoState.local;
    if (cloudPath != null) return PhotoState.cloud;
    return PhotoState.empty;
  }
}
