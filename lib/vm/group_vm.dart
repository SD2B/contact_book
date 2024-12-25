import 'package:contact_book/vm/repositories/group_repository.dart';
import 'package:get/get.dart';

class GroupVM extends GetxController {
  Rx<String> group = "".obs;
  RxList<String> groupList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getGroups();
  }

  Future<void> getGroups() async {
    groupList.value = await GroupRepository.getTask();
  }

  Future<bool> saveTask(String groupName) async {
    if (groupList
        .where((e) => e.toLowerCase() == groupName.toLowerCase())
        .toList()
        .isNotEmpty) {
      return false;
    }
    bool res = await GroupRepository.saveTask(groupName);
    await getGroups();
    return res;
  }

  Future<bool> deleteTask(String groupName) async {
    bool res = await GroupRepository.deleteTask(groupName);
    await getGroups();
    return res;
  }
}

final GroupVM groupVM = Get.put(GroupVM());
