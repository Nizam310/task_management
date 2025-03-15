import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/util/custom_widgets/toast.dart';

import '../../model/task_model.dart';
import '../../objectbox.g.dart';

class SqliteService {

  static Future<void> exportToSQLite(Store store) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String exportPath = join(appDocDir.path, 'tasks_backup.db');

      final Database db = await openDatabase(
        exportPath,
        version: 1,
        onCreate: (db, version) async {
          if (kDebugMode) {
            print("Creating tasks table...");
          }
          await db.execute('''
          CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            priority TEXT,
            status TEXT,
            dueDate TEXT,
            updatedAt INTEGER
          )
        ''');
        },
      );

      if (kDebugMode) {
        print("Database path: $exportPath");
      }


      final Box<TaskModel> taskBox = store.box<TaskModel>();
      final List<TaskModel> tasks = taskBox.getAll();


      for (var task in tasks) {
        await db.insert('tasks', task.toMap());
      }

      await db.close();
      Dialogues.toast("Export successful: $exportPath");
    } catch (e) {
      if (kDebugMode) {
        print("Error exporting to SQLite: $e");
      }
    }
  }

  static Future<void> importFromSQLite(Store store) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String importPath = join(appDocDir.path, 'tasks_backup.db');

      final Database db = await openDatabase(importPath);

      List<Map<String, dynamic>> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='tasks';");

      if (tables.isEmpty) {
        if (kDebugMode) {
          print("Error: tasks table does not exist in SQLite database.");
        }
        Dialogues.toast("No 'tasks' table found in SQLite database.");
        await db.close();
        return;
      }

      final List<Map<String, dynamic>> taskList = await db.query('tasks');
      await db.close();

      if (taskList.isNotEmpty) {
        final Box<TaskModel> taskBox = store.box<TaskModel>();
        List<TaskModel> tasks =
        taskList.map((e) => TaskModel.fromMap(e, id: 0)).toList();

        taskBox.putMany(tasks);
        Dialogues.toast("Import successful: ${tasks.length} tasks added.");
      } else {
        Dialogues.toast("No tasks found in SQLite database.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error importing from SQLite: $e");
      }
    }
  }

}
