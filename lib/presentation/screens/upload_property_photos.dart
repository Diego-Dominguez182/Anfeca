import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ImageModel extends ChangeNotifier {
  List<File> selectedFiles = [];

  Future<void> pickFile(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff'],
        allowMultiple: true,  
      );
      if (result != null && result.files.isNotEmpty) {
        result.files.forEach((file) {
          selectedFiles.add(File(file.path!));
        });
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona al menos un archivo válido.'),
          ),
        );
      }
    } catch (e) {
      print('Error al seleccionar el archivo: $e');
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final mountainsRef =
          storageRef.child('User/${DateTime.now().millisecondsSinceEpoch}');
      await mountainsRef.putFile(file);
      return await mountainsRef.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}

class UploadPropertyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageModel>(
      create: (_) => ImageModel(),
      builder: (context, child) {
        final imageModel = Provider.of<ImageModel>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Sube fotos sobre tu propiedad'),
          ),
          body: imageModel.selectedFiles.isEmpty
              ? _buildSelectFile(context)
              : _buildImageGrid(context),
        );
      },
    );
  }

  Widget _buildSelectFile(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final imageModel = Provider.of<ImageModel>(context, listen: false);
          await imageModel.pickFile(context);
        },
        child: Text('Seleccionar archivos'),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
  final imageModel = Provider.of<ImageModel>(context);
  return Padding(
    padding: const EdgeInsets.all(8.0), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: imageModel.selectedFiles.length,
            itemBuilder: (context, index) {
              final file = imageModel.selectedFiles[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                ),
                padding: EdgeInsets.all(4), 
                child: Image.file(file),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () async {
                final imageModel = Provider.of<ImageModel>(context, listen: false);
                await imageModel.pickFile(context);
              },
              child: Text('Seleccionar fotos'),
            ),
            ElevatedButton(
              onPressed: () async {
                final imageModel = Provider.of<ImageModel>(context, listen: false);
                for (final file in imageModel.selectedFiles) {
                  String? downloadUrl = await imageModel.uploadFile(file);
                  if (downloadUrl != null) {
                    await saveDownloadUrl(downloadUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al subir el archivo.'),
                      ),
                    );
                  }
                }
                imageModel.selectedFiles.clear();
              },
              child: Text('Subir archivos'),
            ),
          ],
        ),
      ],
    ),
  );
}





  Future<void> saveDownloadUrl(String downloadUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('User').doc(uid);
        await userDocRef.set({
          'schoolFile': downloadUrl,
        }, SetOptions(merge: true));
      } else {
        throw Exception('User is not authenticated');
      }
    } catch (error) {
      print("Error al guardar el URL de descarga: $error");
    }
  }
}
