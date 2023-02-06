
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatelessWidget {
  const FileUpload({super.key});

  @override
  Widget build(BuildContext context) {
    FilePickerResult? result;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          if (result != null) Text('File: ${result.files.single.name}'),
          TextButton(
            onPressed: () async =>
                // For now, only supports upload of a single file.
                result = await FilePicker.platform.pickFiles(),
            child: const Text('Upload a File'),
          ),
        ],
      ),
    );
  }
}
