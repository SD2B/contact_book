import 'dart:io';
import 'dart:ui';
import 'package:contact_book/core/colors.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/common_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactImagePicker extends HookWidget {
  final ValueNotifier<ContactModel> model;
  final bool isView;
  const ContactImagePicker(
      {super.key, required this.model, this.isView = false});

  Future<void> _requestPermission(BuildContext context) async {
    final status = await Permission.photos.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Permission denied. Please allow permission in settings.")));
      throw Exception("Permission denied. Please enable it from settings.");
    }
  }

  Future<void> _pickImage(
      ValueNotifier<File?> selectedImage, BuildContext context) async {
    try {
      await _requestPermission(context);

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600, // Optional: Resize image
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        model.value = model.value.copyWith(image: pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = useState<File?>(
        (model.value.image != null && model.value.image != "")
            ? File(model.value.image ?? "")
            : null);

    return GestureDetector(
      onTap: () {
        if (isView == false) _pickImage(selectedImage, context);
        if (isView && model.value.image != null && model.value.image != "") {
          showDialog(
            context: context,
            builder: (context) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withValues(alpha: .5),
                      ),
                    ),
                  ),
                  AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Image.file(File(model.value.image ?? ""))),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: context.width() - 230,
                width: context.width() - 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorCode.colorList(context).secondary!,
                  border: selectedImage.value != null
                      ? Border.all(
                          color: ColorCode.colorList(context).middleSecondary!,
                          width: 5)
                      : null,
                  image: selectedImage.value != null
                      ? DecorationImage(
                          image: FileImage(selectedImage.value!),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: selectedImage.value == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                                isView ? Icons.person : Icons.upload_rounded,
                                color: Colors.grey[600],
                                size: isView ? 100 : 40),
                          ),
                          if (!isView)
                            Text(
                              "Upload image",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                            ),
                        ],
                      )
                    : isView
                        ? null
                        : Center(
                            child: CustomIconButton(
                              onTap: () => _pickImage(selectedImage, context),
                              icon: Icons.edit,
                              iconSize: 20,
                              iconColor:
                                  ColorCode.colorList(context).customTextColor,
                              buttonColor:
                                  ColorCode.colorList(context).middleSecondary,
                            ),
                          ),
              ),
            ],
          ),
          if (isView) ...[
            10.height,
            Text(
              model.value.name ?? "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorCode.colorList(context).secondary,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}
