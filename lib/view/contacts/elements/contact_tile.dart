import 'dart:io';

import 'package:contact_book/core/colors.dart';
import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;
  const ContactTile({super.key, required this.contact});
  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      await launchUrl(launchUri);
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Phone permission denied. Please allow permission in settings.")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: context.width(),
      child: ListTile(
        tileColor: ColorCode.colorList(context).secondary,
        onTap: () {
          context.pushNamed(RouteEnum.viewContact.name, extra: contact);
        },
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorCode.colorList(context).middlePrimary,
            image: contact.image != null
                ? DecorationImage(
                    image: FileImage(File(contact.image!)), fit: BoxFit.cover)
                : null,
          ),
          child: contact.image != null
              ? null
              : Icon(Icons.person,
                  color: ColorCode.colorList(context).secondary),
        ),
        title: Text("${contact.name}"),
        subtitle: Text("${contact.phone}"),
        trailing: InkWell(
            onTap: () async => _makeCall(context, "${contact.phone}"),
            child: Icon(Icons.phone)),
      ),
    );
  }
}
