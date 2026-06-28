import 'dart:io';

import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;

  //====================================================
  // Upload Image (Backward Compatibility)
  //====================================================

  Future<String> uploadImage({required File file, required String folder}) {
    return uploadFile(file: file, folder: folder);
  }

  //====================================================
  // Upload Any File
  //====================================================

  Future<String> uploadFile({
    required File file,
    required String folder,
  }) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}";

    final storagePath = "$folder/$fileName";

    await _client.storage.from("media").upload(storagePath, file);

    return _client.storage.from("media").getPublicUrl(storagePath);
  }

  //====================================================
  // Delete Image (Backward Compatibility)
  //====================================================

  Future<void> deleteImage(String imageUrl) {
    return deleteFile(imageUrl);
  }

  //====================================================
  // Delete Any File
  //====================================================

  Future<void> deleteFile(String fileUrl) async {
    final uri = Uri.parse(fileUrl);

    final index = uri.path.indexOf("/media/");

    if (index == -1) return;

    final storagePath = uri.path.substring(index + 7);

    await _client.storage.from("media").remove([storagePath]);
  }
}
