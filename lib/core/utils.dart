import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    debugPrint('PICKER RESULT: $filePickerRes'); // 👈 is it null?
    debugPrint('FILES: ${filePickerRes?.files}'); // 👈 any files?

    if (filePickerRes != null) {
      final path = filePickerRes.files.first.xFile.path;
      debugPrint('PATH: $path');
      return File(path);
    }
    return null;
  } catch (e, st) {
    debugPrint('PICKER ERROR: $e'); // 👈 exact error
    debugPrint('STACKTRACE: $st');
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
