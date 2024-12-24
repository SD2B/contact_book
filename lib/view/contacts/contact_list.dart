import 'dart:io';

import 'package:contact_book/core/colors.dart';
import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/view/custom_scaffold.dart';
import 'package:contact_book/vm/contact_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends HookWidget {
  const ContactList({super.key});

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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorCode.colorList(context).secondary,
      isHome: true,
      appBar: AppBar(
        backgroundColor: ColorCode.colorList(context).middlePrimary,
      ),
      child: Obx(
        () {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              spacing: 10,
              children: [
                if (contactVM.contactList.isEmpty)
                  SizedBox(
                    width: context.width(),
                    height: context.height() - 200,
                    child: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "0 Contacts",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorCode.colorList(context).customTextColor, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Press",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorCode.colorList(context).customTextColor, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.add_circle),
                            Text(
                              "to add new contact",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorCode.colorList(context).customTextColor, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ...contactVM.contactList.map((contact) {
                  return SizedBox(
                    height: 80,
                    width: context.width(),
                    child: ListTile(
                      onTap: () {
                        context.pushNamed(
                          RouteEnum.viewContact.name,
                          extra: contact,
                        );
                      },
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorCode.colorList(context).middlePrimary,
                          image: contact.image != null ? DecorationImage(image: FileImage(File(contact.image!)), fit: BoxFit.cover) : null,
                        ),
                        child: contact.image != null ? null : Icon(Icons.person, color: ColorCode.colorList(context).secondary),
                      ),
                      title: Text("${contact.name}"),
                      subtitle: Text("${contact.phone}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () async {
                                _makeCall(context, "${contact.phone}");
                              },
                              child: Icon(Icons.phone)),
                          10.width,
                          InkWell(
                              onTap: () async {
                                await contactVM.deleteContact(contact);
                              },
                              child: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
