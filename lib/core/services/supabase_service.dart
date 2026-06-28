import 'dart:io';

import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadImage({
    required File file,
    required String folder,
  }) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}";

    final path = "$folder/$fileName";

    await _client.storage
        .from("media")
        .upload(path, file);

    return _client.storage
        .from("media")
        .getPublicUrl(path);
  }

  Future<void> deleteImage(String imageUrl) async {
    final uri = Uri.parse(imageUrl);

    final index = uri.path.indexOf("/media/");

    if (index == -1) return;

    final storagePath = uri.path.substring(index + 7);

    await _client.storage
        .from("media")
        .remove([storagePath]);
  }
}