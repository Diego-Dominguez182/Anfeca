import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum ImageSection {
  browseFiles, // The UI shows the button to pick files
  imageLoaded, noStoragePermissionPermanent, noStoragePermission, // File picked and shown in the screen
}

class ImageModel extends ChangeNotifier {
  ImageSection _imageSection = ImageSection.browseFiles;

  ImageSection get imageSection => _imageSection;

  set imageSection(ImageSection value) {
    if (value != _imageSection) {
      _imageSection = value;
      notifyListeners();
    }
  }

  File? file;

  Future<bool> requestFilePermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = PermissionStatus.granted;
    } else {
      // For iOS, request photos permission
      result = await Permission.photos.request();
    }

    if (result.isGranted) {
      imageSection = ImageSection.browseFiles;
      return true;
    } else {
      imageSection = ImageSection.browseFiles;
      return false;
    }
  }

  Future<void> pickFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {
      file = File(result.files.single.path!);
      imageSection = ImageSection.imageLoaded;
    }
  }
}
