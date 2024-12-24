import 'package:contact_book/helpers/local_storage.dart';

class GroupRepository {
  static Future<List<String>> getTask() async {
    List<String> taskList = [];
    try {
      List<Map<String, dynamic>> data = await LocalStorage.get(DBTable.contactGroups);
      taskList = data.map((e) => e["group_name"].toString()).toList();
      return taskList;
    } catch (e) {
      return taskList;
    }
  }

  static Future<bool> saveTask(String groupName) async {
    try {
      await LocalStorage.save(DBTable.contactGroups, {"group_name": groupName});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTask(String groupName) async {
    try {
      await LocalStorage.delete(DBTable.contactGroups, where: {"group_name": groupName});
      return true;
    } catch (e) {
      return false;
    }
  }
}
