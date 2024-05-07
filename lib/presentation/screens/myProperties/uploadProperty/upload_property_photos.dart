import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_description_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_services_screen.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';

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
        final List<File> newFiles =
            result.files.map((file) => File(file.path!)).toList();
        selectedFiles.addAll(newFiles);
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

  Future<String?> uploadFile(File file, String idProperty) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final folderName = idProperty;
      final imageName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final imageRef = storageRef.child('$folderName/$imageName');
      await imageRef.putFile(file);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print('Error al subir el archivo: $e');
      return null;
    }
  }
}

class UploadPropertyScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;

  const UploadPropertyScreen({Key? key, this.idProperty, this.currentPosition}) : super(key: key);

  @override
  _UploadPropertyScreenState createState() => _UploadPropertyScreenState();
}

class _UploadPropertyScreenState extends State<UploadPropertyScreen> {
  bool _isButtonDisabled = false;  

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
          bottomNavigationBar:
              SizedBox(height: 80, child: _buildAppBar(context)),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        backgroundColor: Colors.white,
        leadingWidth: 48,
        leftText: "Atrás",
        rightText: "Siguiente",
        showBoxShadow: false,
        onTapLeftText: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PropertyServicesScreen(idProperty: widget.idProperty, 
                      currentPosition: widget.currentPosition)));
        },
        onTapRigthText: () async {
          if (_isButtonDisabled) return; 
          setState(() {
            _isButtonDisabled = true; 
          });

          final imageModel = Provider.of<ImageModel>(context, listen: false);
          final List<File> filesToUpload = List.from(imageModel.selectedFiles);

          if (filesToUpload.length > 0) {
            List<String> downloadUrls = [];

            for (final file in filesToUpload) {
              String? downloadUrl =
                  await imageModel.uploadFile(file, widget.idProperty!);
              if (downloadUrl != null) {
                downloadUrls.add(downloadUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al subir el archivo.'),
                  ),
                );
                setState(() {
                  _isButtonDisabled = false;
                });
                return; 
              }
            }

            if (downloadUrls.isNotEmpty) {
              await saveDownloadUrls(downloadUrls);
              imageModel.selectedFiles.clear();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PropertyDescriptionScreen(
                            idProperty: widget.idProperty,
                            currentPosition: widget.currentPosition
                          )));
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error en subida de fotos"),
                  content: Text("Tienes que subir como mínimo 5 fotos."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _isButtonDisabled = false;
                        });
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        });
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
                    border: Border.all(
                        width: 2, color: Colors.black.withOpacity(0.22)),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.file(file),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final imageModel =
                      Provider.of<ImageModel>(context, listen: false);
                  await imageModel.pickFile(context);
                },
                child: Text('Seleccionar fotos'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveDownloadUrls(List<String> downloadUrls) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection('Property')
            .doc(widget.idProperty);
        await userDocRef.set(
          {'propertyPhotos': FieldValue.arrayUnion(downloadUrls)},
          SetOptions(merge: true),
        );
      } else {
        throw Exception('Usuario no autenticado');
      }
    } catch (error) {
      print("Error al guardar los URLs de descarga: $error");
    }
  }
}