import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photogpt/widgets/spacing.dart';
import 'package:photogpt/chatgpt/utils.dart';
import 'package:image_picker/image_picker.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          width(20),
          _page(
              icon: Icons.add_a_photo_outlined,
              title: 'Camera',
              onTap: () => _onTapCamera(ImageSource.camera)),
          width(25),
          _page(
            icon: Icons.photo_size_select_actual_outlined,
            title: 'Gallery',
            onTap: () => _onTapCamera(ImageSource.gallery),
          ),
          width(55),
          _gotoChat,
          width(30),
        ],
      ),
    );
  }

  Widget get _gotoChat => Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
              child: const SizedBox(
                width: 100,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          height(10),
          Expanded(
            flex: 1,
            child: Text('Go to Chat',
                style: GoogleFonts.titilliumWeb(
                  color: Colors.white,
                  fontSize: 18,
                )),
          ),
        ],
      );

  Widget _page({required IconData icon, required String title, required Function() onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.2),
              ),
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.titilliumWeb(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// comment

  void _onTapCamera(ImageSource source) async {
    String resp = await GPTUtils.getGPTResponse(prompt: 'Hello Gpt, can openai api key be free?');
    print('RESPONSE: $resp');

    File? pickedImage;
    XFile? xPickedImage;
    CroppedFile? croppedImage;
    xPickedImage = await ImagePicker().pickImage(
      source: source,
    );

    croppedImage = await ImageCropper().cropImage(
      sourcePath: xPickedImage!.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );

    if (xPickedImage == null) {
      pickedImage = null;
      return;
    }

    pickedImage = croppedImage != null ? File(croppedImage.path) : null;
    print('PICKED ${xPickedImage.path}');
  }
}
