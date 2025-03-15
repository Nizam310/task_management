import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:task_management/util/custom_widgets/toast.dart';

import '../../model/task_model.dart';
import '../../objectbox.g.dart';

class FireStoreSyncService {
  final Box<TaskModel> taskBox; // ObjectBox local storage
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FireStoreSyncService(this.taskBox);

  Future<void> syncCompletedTasks() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.contains(ConnectivityResult.none)) {
      Dialogues.toast(
        "No internet. Sync will happen when online.",
        isError: true,
      );
      return;
    }

    List<TaskModel> completedTasks =
        taskBox.query(TaskModel_.status.equals("completed")).build().find();

    for (var task in completedTasks) {
      DocumentReference docRef = firestore
          .collection('tasks')
          .doc(task.id.toString());

      var docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        var cloudData = docSnapshot.data() as Map<String, dynamic>;
        int cloudUpdatedAt = cloudData['updatedAt'];

        if (task.updatedAt < cloudUpdatedAt) {
          if (kDebugMode) {
            print(
              "Skipping sync for task ${task.id}, Firestore has newer data.",
            );
          }
          continue;
        }
      }

      await docRef.set(task.toMap());
      if (kDebugMode) {
        print("Synced task ${task.id} to Firestore.");
        Dialogues.toast("Synced task  to Firestore.");
      }
    }
  }

}
