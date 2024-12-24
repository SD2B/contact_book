import 'package:contact_book/core/colors.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/contacts/elements/add_group_popup.dart';
import 'package:contact_book/vm/group_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GroupSelection extends HookWidget {
  const GroupSelection({super.key, required this.model});

  final ValueNotifier<ContactModel> model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await groupVM.getGroups();
        showDialog(context: context, builder: (context) => AddGroupPopup(model: model));
      },
      child: Container(
        height: 50,
        width: context.width(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorCode.colorList(context).middleSecondary!,
          ),
          color: ColorCode.colorList(context).secondary!,
        ),
        padding: const EdgeInsets.only(left: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15.5,
          children: [
            Icon(Icons.group, size: 20, color: ColorCode.colorList(context).middleSecondary!),
            Text(
              (model.value.group ?? "Select group").toTitleCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: (model.value.group != null && model.value.group != "") ? ColorCode.colorList(context).customTextColor : const Color(0xffA8B1BE),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
