import 'package:contact_book/helpers/local_storage.dart';
import 'package:contact_book/models/contact_model.dart';

class ContactRepository {
  static Future<List<ContactModel>> getContacts({String? search}) async {
    List<ContactModel> taskList = [];
    List<Map<String, dynamic>> data;

    if (search != null && search != "" && search.isNotEmpty) {
      // SQL query to filter by name or phone
      final query = '''
    SELECT * FROM contact_list 
    WHERE name LIKE ? OR phone LIKE ?
  ''';

      // Execute the query using `directQuery`
      data = await LocalStorage.directQuery(
        query,
        ['%$search%', '%$search%'], // Arguments for the query
      );
    } else {
      data = await LocalStorage.get(DBTable.contacts);
    }
    taskList = data.map((e) => ContactModel.fromJson(e)).toList();
    return taskList;
  }

  static Future<bool> saveContact(ContactModel model) async {
    try {
      await LocalStorage.save(DBTable.contacts, model.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateContacts(ContactModel model) async {
    try {
      await LocalStorage.update(DBTable.contacts, model.toJson(),
          where: {"id": model.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteContact(ContactModel model) async {
    try {
      await LocalStorage.delete(DBTable.contacts, where: {"id": model.id});
      return true;
    } catch (e) {
      return false;
    }
  }
}
