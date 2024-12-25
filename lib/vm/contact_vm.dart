import 'package:contact_book/core/common_enums.dart';
import 'package:contact_book/models/contact_model.dart';
import 'package:contact_book/vm/repositories/contact_repository.dart';
import 'package:get/get.dart';

class ContactVM extends GetxController {
  RxList<ContactModel> contactList = <ContactModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getContacts();
  }

  Future<void> getContacts({String? search}) async {
    contactList.value = await ContactRepository.getContacts(search: search);
    contactList
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  }

  Future<bool> saveContact(ContactModel model) async {
    bool res = await ContactRepository.saveContact(model);
    await getContacts();
    return res;
  }

  Future<bool> updateContact(ContactModel model) async {
    bool res = await ContactRepository.updateContacts(model);
    await getContacts();
    return res;
  }

  Future<bool> deleteContact(ContactModel model) async {
    bool res = await ContactRepository.deleteContact(model);
    await getContacts();
    return res;
  }

  void sortContacts(SortType sortType) {
    switch (sortType) {
      case SortType.name:
        contactList.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        break;
      case SortType.phone:
        contactList.sort((a, b) => a.phone!.compareTo(b.phone!));
        break;
      case SortType.group:
        contactList.sort((a, b) {
          if (a.group == null && b.group == null) return 0;
          if (a.group == null) return 1;
          if (b.group == null) return -1;
          return a.group!.toLowerCase().compareTo(b.group!.toLowerCase());
        });
        break;
      case SortType.email:
        contactList.sort((a, b) {
          if (a.email == null && b.email == null) return 0;
          if (a.email == null) return 1;
          if (b.email == null) return -1;
          return a.email!.toLowerCase().compareTo(b.email!.toLowerCase());
        });
        break;
    }
    // contactList.refresh();
  }
}

final ContactVM contactVM = Get.put(ContactVM());
