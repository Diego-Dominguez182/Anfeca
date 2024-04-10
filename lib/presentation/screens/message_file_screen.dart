import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/message_tenant_register_screen.dart';
import 'package:resty_app/presentation/widgets/custom_outlined_button.dart';

class ImageModel extends ChangeNotifier {
  File? file;

  Future<void> pickFile(BuildContext context) async {
    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        if (result.files.single.extension == 'mp4' ||
            result.files.single.extension == 'mov' ||
            result.files.single.extension == 'avi' ||
            result.files.single.extension == 'wmv' ||
            result.files.single.extension == 'flv' ||
            result.files.single.extension == 'mkv') {
          file = File(result.files.single.path!);
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor selecciona un archivo de vídeo.'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error al seleccionar el archivo: $e');
    }
  }

  Future<String?> uploadFile() async {
    try {
      if (file == null) {
        throw Exception('File is not initialized');
      }
      final storageRef = FirebaseStorage.instance.ref();
      final mountainsRef =
          storageRef.child('User/${DateTime.now().millisecondsSinceEpoch}');
      await mountainsRef.putFile(file!);
      return await mountainsRef.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}

class MessageFileScreen extends StatelessWidget {
  const MessageFileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageModel>(
      create: (_) => ImageModel(),
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 28),
              width: double.maxFinite,
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgRoommateroots1,
                    height: 250.v,
                    width: 282.h,
                  ),
                  SizedBox(height: 38.h),
                  SizedBox(height: 14.v),
                  _buildMessage(context),
                  SizedBox(height: 34.v),
                  _buildUploadFile(context),
                  SizedBox(height: 9.v),
                  _buildSelectFile(context),
                  SizedBox(height: 8.v),
                  _buildCancel(context),
                  SizedBox(height: 9.v),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Container(
      width: 233.h,
      margin: EdgeInsets.symmetric(horizontal: 28.h),
      child: Text(
        "Sube un vídeo corto sosteniendo la credencia de tu institución educativa",
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        textAlign: TextAlign.center,
        style: restyTextTheme.displaySmall,
      ),
    );
  }

  Widget _buildSelectFile(BuildContext context) {
    return CustomOutlinedButton(
      text: "Seleccionar archivo",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () async {
        final imageModel = Provider.of<ImageModel>(context, listen: false);
        await imageModel.pickFile(context);
      },
    );
  }

  Widget _buildUploadFile(BuildContext context) {
    return Selector<ImageModel, File?>(
      selector: (_, model) => model.file,
      builder: (context, file, _) {
        if (file != null) {
          return CustomOutlinedButton(
            text: "Subir archivo",
            margin: EdgeInsets.symmetric(horizontal: 34.h),
            onPressed: () async {
              final imageModel =
                  Provider.of<ImageModel>(context, listen: false);
              String? downloadUrl = await imageModel.uploadFile();
              if (downloadUrl != null) {
                await saveDownloadUrl(downloadUrl);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageTenantRegisterScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al subir el archivo.'),
                  ),
                );
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCancel(BuildContext context) {
    return CustomOutlinedButton(
      text: "Cancelar",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.loginScreen);
      },
    );
  }
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
