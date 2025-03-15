import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/provider/object_box_provider.dart';
import 'package:task_management/util/fire_store_sync_service/fire_store_sync_service.dart';

import '../main.dart';
import '../util/custom_widgets/toast.dart';
import '../util/enum.dart';
import '../util/network_connection/connectivity.dart';

class TaskProvider extends ChangeNotifier {
  final ObjectBoxProvider _objectBoxProvider;

  TaskProvider(this._objectBoxProvider) {
    initializeTaskFields();
    getTaskList();
    initConnectivity();
  }

  GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  bool isOnline = false;

  void initConnectivity() {
    Connectivity().onConnectivityChanged.listen((statusList) {
      if (statusList.isNotEmpty &&
          statusList.first != ConnectivityResult.none) {
        isOnline = true;
      } else {
        isOnline = false;
      }
      notifyListeners();
    });
  }

  toggleOnlineStatus(bool val) {
    val != isOnline;
    notifyListeners();
  }

  List<TaskModel> taskList = [];
  int selectedIndex = -1;

  void setSelectedIndex(int index) {
    if (selectedIndex == index) {
      selectedIndex = -1;
    } else {
      selectedIndex = index;
    }
    notifyListeners();
  }

  addTask({required BuildContext context}) {
    if (taskFormKey.currentState?.validate() ?? false) {
      taskList.add(
        TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          priority: priorityController.text,
          status: statusController.text,
          dueDate: dueDateController.text,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      _objectBoxProvider.addList(taskList);
      final firestoreSyncService = FireStoreSyncService(objectBox.taskBox);
      ConnectivityService(firestoreSyncService);
      resetTaskFields(context);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  getTaskList() async {
    var list = _objectBoxProvider.getList();
    if (list.isNotEmpty) {
      for (var i in list) {
        if (!taskList.contains(i)) {
          taskList.addAll(list);
        }
      }
      notifyListeners();
    } else {
      await fetchFromFireStore();
    }
  }

  Future<void> fetchFromFireStore() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Dialogues.toast("No internet. Unable to fetch tasks.", isError: true);
      return;
    }

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tasks').get();
      List<TaskModel> fetchedTasks =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return TaskModel.fromMap(data, id: 0);
          }).toList();

      if (fetchedTasks.isNotEmpty) {
        _objectBoxProvider.addList(fetchedTasks);
        taskList.clear();
        taskList.addAll(fetchedTasks);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("::::::::::::::::::::::::::::");
        print(e);
        print("::::::::::::::::::::::::::::");
        Dialogues.toast("Failed to fetch tasks: $e", isError: true);
      }
    }
  }

  updateTask({
    required int index,
    required int id,
    required BuildContext context,
  }) {
    if (taskFormKey.currentState?.validate() ?? false) {
      TaskModel model = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        priority: priorityController.text,
        status: statusController.text,
        dueDate: dueDateController.text,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      taskList[index] = model;
      _objectBoxProvider.updateItemById(id, model);
      final firestoreSyncService = FireStoreSyncService(objectBox.taskBox);
      ConnectivityService(firestoreSyncService);
      resetTaskFields(context);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  resetTaskFields(BuildContext context) {
    titleController.clear();
    descriptionController.clear();
    statusController.text = Status.pending.name;
    priorityController.text = Priority.low.name;
    dueDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  removeTask({required int index, required int id}) {
    taskList.removeAt(index);
    _objectBoxProvider.deleteList(id);
    notifyListeners();
  }

  setStatusDropVal(String value) {
    statusController.text = value;
    notifyListeners();
  }

  setPriorityDropVal(String value) {
    priorityController.text = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      dueDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      notifyListeners();
    }
  }
  ///Check due date
  bool dueDate(String date) {
    if (date.isEmpty) {
      return false;
    } // Handle empty date
    else {
      try {
        // Parse "15-03-2025" format correctly
        DateTime dueDate = DateFormat(
          "dd-MM-yyyy",
        ).parse(date);
        DateTime today = DateTime.now();

        return dueDate.isBefore(
          today,
        ); // Returns true if dueDate has passed
      } catch (error) {
        if (kDebugMode) {
          print("Invalid date format: $error");
        }
        return false; // Return false if parsing fails
      }
    }
  }

  List<Color> getWaveColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return [Colors.red.withAlpha((0.6 * 255).toInt()), Colors.red[600]!];
      case 'medium':
        return [Colors.blue.withAlpha((0.6 * 255).toInt()), Colors.blue[600]!];
      case 'low':
        return [
          Colors.green.withAlpha((0.6 * 255).toInt()),
          Colors.green[600]!,
        ];
      default:
        return [
          Colors.grey.withAlpha((0.6 * 255).toInt()),
          Colors.grey[600]!,
        ]; // Default color
    }
  }

  double getWaveHeight(String status) {
    return status.toLowerCase() == "completed" ? 0.1 : 0.8;
  }

  void initializeTaskFields() {
    dueDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    statusController.text = Status.pending.name;
    priorityController.text = Priority.low.name;
    notifyListeners();
  }
}
