import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:task_management/model/task_model.dart';

class ObjectBoxProvider with ChangeNotifier {
  late final Store _store;
  late final Box<TaskModel> _taskBox;

  ObjectBoxProvider(this._store) {
    _taskBox = _store.box<TaskModel>();
  }

  List<TaskModel> getList() {
    return _taskBox.getAll();
  }

  void addList(List<TaskModel> tasks) {
    _taskBox.putMany(tasks);
    notifyListeners();
  }

  bool updateItemById(int id, TaskModel updatedTask) {
    final existingTask = _taskBox.get(id);
    if (existingTask != null) {
      updatedTask.id = id; // Ensure ID remains the same
      _taskBox.put(updatedTask);
      notifyListeners();
      return true;
    }
    return false; // Item not found
  }

  void editList(TaskModel updatedTaskModel) {
    _taskBox.put(updatedTaskModel);
    notifyListeners();
  }

  void deleteList(int id) {
    _taskBox.remove(id);
    notifyListeners();
  }
}
