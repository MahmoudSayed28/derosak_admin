import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return null;

    return File(result.files.single.path!);
  }
}