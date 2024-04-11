import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController _nameController = TextEditingController();
  File? _file;

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // allowMultiple: true,
      // allowCompression: true,
      type: FileType.image,
      // type: FileType.custom,
      // allowedExtensions: ['jpg', 'pdf', 'png', 'doc'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.first.path!);
      });
    }
  }

  void _deleteFile() async {
    setState(() {
      _file = null;
    });
  }

  void _submitForm() async {
    Dio dio = Dio();
    String url = "https://e89e-202-80-212-36.ngrok-free.app/user";

    if (_file == null) {
      return;
    } else {
      String fileName = _file!.path.split('/').last;

      final params = {
        'name': _nameController.text,
        'file': await MultipartFile.fromFile(
          _file!.path,
          filename: fileName,
        ),
      };

      FormData formData = FormData.fromMap(params);

      print("FileName: $fileName");
      print("FilePath: ${_file!.path}");

      try {
        Response response = await dio.post(url, data: formData);

        print("Response: $response");
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Form"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _selectFile,
                      child: const Text('Select File'),
                    ),
                    IconButton(
                      onPressed: _deleteFile,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                _file != null
                    ? Text(_file!.path)
                    : const Text('No file selected.'),
                const SizedBox(height: 20.0),
                _file != null ? Image.file(_file!) : const SizedBox(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
