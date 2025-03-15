import 'package:task_management/model/task_model.dart';
import 'object_box_main.dart';

class TaskDBService {
  final ObjectBox objectBox;

  TaskDBService(this.objectBox);

  Future<List<int>> addTasks(List<TaskModel> tasks) async {
    return objectBox.taskBox.putMany(tasks);
  }

  // Read (Get All Notes)
  Future<List<TaskModel>> getAllNotes() async {
    return objectBox.taskBox.getAll();
  }

  // Update
  Future<int> updateNote(TaskModel task) async {
    return objectBox.taskBox.put(task);
  }

  // Delete
  Future<bool> deleteNote(int id) async {
    return objectBox.taskBox.remove(id);
  }

  // Get a single note by ID
  Future<TaskModel?> getNoteById(int id) async {
    return objectBox.taskBox.get(id);
  }
}
