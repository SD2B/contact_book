import 'package:contact_book/core/colors.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/common_widgets/custom_icon_button.dart';
import 'package:contact_book/view/common_widgets/custom_text_field.dart';
import 'package:contact_book/vm/group_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';

class AddGroupPopup extends HookWidget {
  final ValueNotifier<ContactModel> model;
  const AddGroupPopup({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final groupController = useTextEditingController();
    final selectedValue = useState(model.value.group ?? "");
    return AlertDialog(
      backgroundColor: Colors.blue[50],
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            0.height,
            if (groupVM.groupList.isNotEmpty)
              Obx(() {
                return Column(
                  spacing: 10,
                  children: [
                    ...groupVM.groupList.map((e) => CheckboxListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 7),
                          value: selectedValue.value == e,
                          tileColor: ColorCode.colorList(context).secondary,
                          title: Text(e.toTitleCase()),
                          activeColor: ColorCode.colorList(context).middlePrimary,
                          onChanged: (value) {
                            selectedValue.value = e;
                            model.value = model.value.copyWith(group: e);
                            GoRouter.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Apply BorderRadius here
                          ),
                        )),
                  ],
                );
              }),
            Row(
              spacing: 20,
              children: [
                CustomTextField(width: 195, controller: groupController, hintText: "Add new group", firstLetterCapital: true),
                CustomIconButton(
                  icon: Icons.add,
                  iconColor: ColorCode.colorList(context).secondary,
                  buttonColor: ColorCode.colorList(context).middlePrimary,
                  buttonSize: 48,
                  onTap: () async {
                    if (groupController.text != "") {
                      bool res = await groupVM.saveTask(groupController.text);
                      if (res == true) {
                        model.value = model.value.copyWith(group: groupController.text);
                        GoRouter.of(context).pop();
                      }
                      groupController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return FutureBuilder(
    //     future: groupVM.getGroups(),
    //     builder: (context, snapShot) {
    //       return AlertDialog(
    //         backgroundColor: ColorCode.colorList(context).middleSecondary,
    //         shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
    //         content: SizedBox(
    //           width: 300,
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             spacing: 10,
    //             children: [
    //               0.height,
    //               if (groupVM.groupList.isNotEmpty)
    //                 Obx(() {
    //                   return Column(
    //                     spacing: 10,
    //                     children: [
    //                       ...groupVM.groupList.map((e) => CheckboxListTile(
    //                             contentPadding: EdgeInsets.only(left: 10, right: 7),
    //                             value: selectedValue.value == e,
    //                             tileColor: Colors.white54,
    //                             title: Text(e.toTitleCase()),
    //                             activeColor: ColorCode.colorList(context).middlePrimary,
    //                             onChanged: (value) {
    //                               selectedValue.value = e;
    //                               model.value = model.value.copyWith(group: e);
    //                             },
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(10), // Apply BorderRadius here
    //                             ),
    //                           )),
    //                     ],
    //                   );
    //                 }),
    //               Row(
    //                 spacing: 20,
    //                 children: [
    //                   CustomTextField(width: 195, controller: groupController, hintText: "Add new group"),
    //                   CustomIconButton(
    //                     icon: Icons.add,
    //                     iconColor: ColorCode.colorList(context).middleSecondary,
    //                     buttonColor: ColorCode.colorList(context).middlePrimary,
    //                     buttonSize: 48,
    //                     onTap: () async {
    //                       if (groupController.text != "") {
    //                         await groupVM.saveTask(groupController.text);
    //                         groupController.clear();
    //                         await groupVM.getGroups();
    //                       }
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
