import 'package:contact_book/core/colors.dart';
import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/view/common_widgets/custom_icon_button.dart';
import 'package:contact_book/view/common_widgets/custom_text_field.dart';
import 'package:contact_book/view/contacts/elements/contact_tile.dart';
import 'package:contact_book/view/custom_scaffold.dart';
import 'package:contact_book/vm/contact_vm.dart';
import 'package:contact_book/vm/group_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ContactList extends HookWidget {
  const ContactList({super.key});

  Future<void> _searchContacts(String query) async {
    if (query.isEmpty) {
      await contactVM.getContacts();
    } else {
      await contactVM.getContacts(search: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enableSearch = useState(false);
    final searchController = useTextEditingController();
    final searchFocus = useFocusNode();
    final sortByGroup = useState(false);

    return CustomScaffold(
      backgroundColor: ColorCode.colorList(context).middlePrimary,
      isHome: true,
      appBar: AppBar(
        backgroundColor: ColorCode.colorList(context).middlePrimary,
        title: Text(
          "Contacts",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: ColorCode.colorList(context).secondary,
              ),
        ),
        actions: [
          CustomIconButton(
              icon: Icons.search,
              iconColor: ColorCode.colorList(context).secondary,
              buttonColor: Colors.transparent,
              onTap: () {
                enableSearch.value = !enableSearch.value;
                if (enableSearch.value == true) {
                  searchFocus.requestFocus();
                } else {
                  FocusScope.of(context).unfocus();
                  // searchFocus.unfocus();
                }
              }),
          10.width,
          PopupMenuButton(
              iconColor: ColorCode.colorList(context).secondary,
              color: ColorCode.colorList(context).secondary,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorCode.colorList(context).customTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                    child: Text("Sort by,"),
                  ),
                  PopupMenuItem(
                    onTap: () => {
                      contactVM.sortContacts(SortType.name),
                      sortByGroup.value = false
                    },
                    child: Row(
                      children: [
                        15.width,
                        Icon(Icons.person,
                            color: ColorCode.colorList(context).middlePrimary),
                        10.width,
                        Text(
                          "Name",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorCode.colorList(context)
                                        .customTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => {
                      contactVM.sortContacts(SortType.phone),
                      sortByGroup.value = false
                    },
                    child: Row(
                      children: [
                        15.width,
                        Icon(Icons.phone,
                            color: ColorCode.colorList(context).middlePrimary),
                        10.width,
                        Text(
                          "Phone number",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorCode.colorList(context)
                                        .customTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => {
                      contactVM.sortContacts(SortType.group),
                      sortByGroup.value = true
                    },
                    child: Row(
                      children: [
                        15.width,
                        Icon(Icons.group,
                            color: ColorCode.colorList(context).middlePrimary),
                        10.width,
                        Text(
                          "Group",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorCode.colorList(context)
                                        .customTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => {
                      contactVM.sortContacts(SortType.email),
                      sortByGroup.value = false
                    },
                    child: Row(
                      children: [
                        15.width,
                        Icon(Icons.mail_rounded,
                            color: ColorCode.colorList(context).middlePrimary),
                        10.width,
                        Text(
                          "Email",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorCode.colorList(context)
                                        .customTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ];
              }),
          15.width,
        ],
      ),
      child: Container(
        height: context.height(),
        color: ColorCode.colorList(context).secondary,
        child: Obx(
          () {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    if (enableSearch.value) ...[
                      CustomTextField(
                        focusNode: searchFocus,
                        controller: searchController,
                        hintText: "Search contacts",
                        onChanged: (value) {
                          _searchContacts(value);
                        },
                      ).animate().fade(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300)),
                    ],
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorCode.colorList(context)
                                          .customTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                            ),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Press",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: ColorCode.colorList(context)
                                              .customTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.add_circle),
                                Text(
                                  "to add new contact",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: ColorCode.colorList(context)
                                              .customTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    if (sortByGroup.value) ...[
                      10.height,
                      ...groupVM.groupList.map((e) => (contactVM.contactList
                              .where((contact) => contact.group == e)
                              .isEmpty)
                          ? SizedBox.shrink()
                          : ExpansionTile(
                              backgroundColor:
                                  ColorCode.colorList(context).middlePrimary,
                              collapsedBackgroundColor:
                                  ColorCode.colorList(context).middlePrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              initiallyExpanded: true,
                              iconColor: ColorCode.colorList(context).secondary,
                              title: Text(
                                e.toTitleCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: ColorCode.colorList(context)
                                            .secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                              ),
                              children: [
                                ...contactVM.contactList
                                    .where((contact) => contact.group == e)
                                    .map((contact) {
                                  return ContactTile(contact: contact);
                                })
                              ],
                            )),
                      if (contactVM.contactList
                          .where((contact) =>
                              contact.group == null || contact.group == "")
                          .isNotEmpty)
                        ExpansionTile(
                            backgroundColor:
                                ColorCode.colorList(context).middlePrimary,
                            collapsedBackgroundColor:
                                ColorCode.colorList(context).middlePrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            initiallyExpanded: true,
                            iconColor: ColorCode.colorList(context).secondary,
                            title: Text(
                              "Other",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorCode.colorList(context)
                                          .secondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            ),
                            children: [
                              ...contactVM.contactList
                                  .where((contact) =>
                                      contact.group == null ||
                                      contact.group == "")
                                  .map((contact) {
                                return ContactTile(contact: contact);
                              })
                            ]),
                    ],
                    if (!sortByGroup.value)
                      ...contactVM.contactList.map((contact) {
                        return ContactTile(contact: contact);
                      })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
