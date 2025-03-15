  import 'package:path_provider/path_provider.dart';
  import 'package:task_management/model/task_model.dart';

import '../../objectbox.g.dart';

  class ObjectBox {
    late final Store _store;
    late final Box<TaskModel> _taskBox;

    ObjectBox._internal(this._store) {
      _taskBox = _store.box<TaskModel>();
    }

    static Future<ObjectBox> create() async {
      final directory = await getApplicationDocumentsDirectory();
      final store = await openStore(directory: directory.path);
      return ObjectBox._internal(store);
    }

    Box<TaskModel> get taskBox => _taskBox;
    Store get store => _store;

    // Close the store
    Future<void> close() async {
      _store.close();
    }
  }
