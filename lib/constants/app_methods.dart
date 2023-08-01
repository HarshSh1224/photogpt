import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AppMethods {
  static Future<File?> pickImage({required source}) async {
    File? pickedImage;
    XFile? xPickedImage;
    CroppedFile? croppedImage;
    xPickedImage = await ImagePicker().pickImage(
      source: source,
    );

    if (xPickedImage == null) return null;

    croppedImage = await ImageCropper().cropImage(
      sourcePath: xPickedImage.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    pickedImage = croppedImage != null ? File(croppedImage.path) : null;
    return pickedImage;
  }
}
