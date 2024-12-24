import 'package:contact_book/core/colors.dart';
import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/common_widgets/custom_icon_button.dart';
import 'package:contact_book/view/contacts/elements/contact_image_picker.dart';
import 'package:contact_book/view/contacts/elements/icon_text_tile.dart';
import 'package:contact_book/view/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends HookWidget {
  final ContactModel contactModel;
  const ViewContact({super.key, required this.contactModel});

  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      await launchUrl(launchUri);
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone permission denied. Please allow permission in settings.")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
      await launchUrl(launchUri);
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone permission denied. Please allow permission in settings.")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _sendMail(BuildContext context, String email) async {
    if (email.isEmpty || email == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No email is added to this contact")));
    } else {
      final Uri launchUri = Uri(scheme: 'mailto', path: email);
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = useState(contactModel);
    return CustomScaffold(
      backgroundColor: ColorCode.colorList(context).middlePrimary,
      enableBack: true,
      trailingWidget: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  context.goNamed(RouteEnum.addContact.name, extra: model.value);
                },
                icon: Icon(Icons.edit, color: ColorCode.colorList(context).secondary)),
            IconButton(
                onPressed: () {
                  context.goNamed(RouteEnum.addContact.name, extra: model.value);
                },
                icon: Icon(Icons.delete, color: ColorCode.colorList(context).secondary)),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContactImagePicker(model: model, isView: true),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: context.height() / 1.8,
                width: context.width(),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: ColorCode.colorList(context).secondary,
                ),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomIconButton(buttonSize: 55, icon: Icons.phone, iconColor: ColorCode.colorList(context).middlePrimary, buttonColor: ColorCode.colorList(context).middleSecondary, onTap: () => _makeCall(context, model.value.phone ?? "")),
                            CustomIconButton(buttonSize: 55, icon: Icons.messenger, iconColor: ColorCode.colorList(context).middlePrimary, buttonColor: ColorCode.colorList(context).middleSecondary, onTap: () => _sendSMS(context, model.value.phone ?? "")),
                            CustomIconButton(buttonSize: 55, icon: Icons.email_rounded, iconColor: ColorCode.colorList(context).middlePrimary, buttonColor: ColorCode.colorList(context).middleSecondary, onTap: () => _sendMail(context, model.value.email ?? "")),
                          ],
                        ),
                      ),
                      Divider(color: ColorCode.colorList(context).middlePrimary),
                      IconTextTile(icon: Icons.phone, text: model.value.phone ?? ""),
                      if (model.value.email != null) IconTextTile(icon: Icons.mail_rounded, text: model.value.email ?? ""),
                      if (model.value.group != null) IconTextTile(icon: Icons.group, text: model.value.group ?? "", noCopy: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
