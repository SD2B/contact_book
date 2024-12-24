import 'package:contact_book/core/colors.dart';
import 'package:contact_book/helpers/sddb_helper.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/view/common_widgets/custom_text_field.dart';
import 'package:contact_book/view/contacts/elements/contact_image_picker.dart';
import 'package:contact_book/view/contacts/elements/group_selection.dart';
import 'package:contact_book/view/custom_scaffold.dart';
import 'package:contact_book/vm/contact_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AddContact extends HookWidget {
  final ContactModel contactModel;

  const AddContact({super.key, this.contactModel = const ContactModel()});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController(text: contactModel.name);
    final phoneController = useTextEditingController(text: contactModel.phone);
    final emailController = useTextEditingController(text: contactModel.email);
    final model = useState(contactModel);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: ColorCode.colorList(context).middlePrimary,
        enableBack: true,
        isClose: true,
        appBarTitle: "Create Contact",
        trailingWidget: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                model.value = model.value.copyWith(
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text.isNotEmpty ? emailController.text : null,
                );
                bool res = false;
                if (model.value.id != null) {
                  res = await contactVM.updateContact(model.value);
                } else {
                  res = await contactVM.saveContact(model.value);
                }
                if (res) GoRouter.of(context).pop();
              }
            },
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(ColorCode.colorList(context).secondary!)),
            child: Text(
              "Save",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorCode.colorList(context).customTextColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
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
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [ContactImagePicker(model: model)]),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: context.height() / 1.8,
                  width: context.width(),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: ColorCode.colorList(context).secondary),
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: nameController,
                            hintText: "Enter name",
                            firstLetterCapital: true,
                            prefix: Icon(Icons.person, size: 20, color: ColorCode.colorList(context).middleSecondary!),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          GroupSelection(model: model),
                          CustomTextField(
                            controller: phoneController,
                            hintText: "Enter phone",
                            textInputType: TextInputType.phone,
                            prefix: Icon(Icons.phone, size: 20, color: ColorCode.colorList(context).middleSecondary!),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone is required';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: emailController,
                            hintText: "Enter email (optional)",
                            textInputType: TextInputType.emailAddress,
                            prefix: Icon(Icons.mail_rounded, size: 20, color: ColorCode.colorList(context).middleSecondary!),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
