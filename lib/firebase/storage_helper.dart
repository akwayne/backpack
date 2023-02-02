import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageHelper {
  StorageHelper() {
    storage = FirebaseStorage.instance;
  }
  late FirebaseStorage storage;

  Future<String> uploadFile({
    required String filename,
    required String path,
    required File file,
  }) async {
    // Create storage reference
    final ref = _getRef(path, filename);

    // Upload file
    await ref.putFile(file);

    // Return download url
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile({
    required String filename,
    required String path,
  }) async {
    // Create storage reference
    final ref = _getRef(path, filename);

    // Delete file
    await ref.delete();
  }

  // Get reference point
  Reference _getRef(String path, String filename) {
    final destination = path + filename;
    return storage.ref().child(destination);
  }
}
