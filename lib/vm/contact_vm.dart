import 'package:contact_book/helpers/sddb_helper.dart';
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

  Future<void> getContacts() async {
    contactList.value = await ContactRepository.getContacts();
  }

  Future<bool> saveContact(ContactModel model) async {
    qp(model);
    bool res = await ContactRepository.saveContact(model);
    await getContacts();
    return res;
  }

  Future<bool> updateContact(ContactModel model) async {
    qp(model);
    bool res = await ContactRepository.updateContacts(model);
    await getContacts();
    return res;
  }

  Future<bool> deleteContact(ContactModel model) async {
    qp(model);
    bool res = await ContactRepository.deleteContact(model);
    await getContacts();
    return res;
  }
}

final ContactVM contactVM = Get.put(ContactVM());
