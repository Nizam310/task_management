import 'package:objectbox/objectbox.dart';

@Entity()
class TaskModel {
  @Id()
  int id;

  String title;
  String description;
  String priority;
  String status;
  String dueDate;
  int updatedAt;

  TaskModel({
    this.id = 0,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'dueDate': dueDate,
      'updatedAt': updatedAt,
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map, {int? id}) {
    return TaskModel(
      id: id ?? 0,
      // Set ID to 0 for new entries
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      status: map['status'],
      dueDate: map['dueDate'],
      updatedAt: map['updatedAt'],
    );
  }
}
