import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/util/extension/padding_extension.dart';

import '../../../provider/task_provider.dart';
import '../../../util/custom_widgets/custom_button.dart';
import '../../../util/custom_widgets/custom_drop_down.dart';
import '../../../util/custom_widgets/custom_textfield.dart';
import '../../../util/enum.dart';

class TaskAddDialogue extends StatelessWidget {
  final bool isUpdate;
  final TaskModel? taskModel;
  final int index;

  const TaskAddDialogue({
    super.key,
    this.isUpdate = false,
    this.taskModel,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = context.watch<TaskProvider>();

    if (isUpdate) {
      taskProvider.titleController.text = taskModel!.title;
      taskProvider.descriptionController.text = taskModel!.description;
      taskProvider.dueDateController.text = taskModel!.dueDate;
      taskProvider.priorityController.text = taskModel!.priority;
      taskProvider.statusController.text = taskModel!.priority;
    }

    return AlertDialog(
      backgroundColor:  Color(0xFF223E6D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isUpdate ? "Update Task" : "Create Task",style: TextStyle(color: Colors.white),),
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.clear, color: Colors.red, size: 15),
            ),
          ),
        ],
      ),
      content: Form(
        key: context.select<TaskProvider, GlobalKey<FormState>>(
          (provider) => provider.taskFormKey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: context.select<TaskProvider, TextEditingController>(
                (provider) => provider.titleController,
              ),
              label: 'Title',
              validator: (val) {
                if (val!.isEmpty) {
                  return "Title cant be empty";
                } else {
                  return null;
                }
              },
            ).paddingBottom(10),
            CustomTextField(
              controller: context.select<TaskProvider, TextEditingController>(
                (provider) => provider.descriptionController,
              ),
              label: "Description",
              validator: (val) {
                if (val!.isEmpty) {
                  return "Description cant be empty";
                } else {
                  return null;
                }
              },
            ).paddingBottom(10),
            CustomDropDown(
              label: "Priority",
              itemList: Priority.values,
              value: Priority.low,
              onChanged: (val) {
                if (val != null) {
                  context.read<TaskProvider>().setPriorityDropVal(val.name);
                }
              },
              validator: (val) {
                if (val!.name.isEmpty) {
                  return "Priority cant be empty";
                } else {
                  return null;
                }
              },
            ).paddingBottom(10),
            CustomDropDown(
              label: "Status",
              itemList: Status.values,
              value: Status.pending,
              onChanged: (val) {
                if (val != null) {
                  context.read<TaskProvider>().setStatusDropVal(val.name);
                }
              },
              validator: (val) {
                if (val!.name.isEmpty) {
                  return "Status cant be empty";
                } else {
                  return null;
                }
              },
            ).paddingBottom(10),
            CustomTextField(
              readOnly: true,
              onTap: () {
                context.read<TaskProvider>().selectDate(context);
              },
              controller: context.select<TaskProvider, TextEditingController>(
                (provider) => provider.dueDateController,
              ),
              label: "Due Date",
              validator: (val) {
                if (val!.isEmpty) {
                  return "Due date cant be empty";
                } else {
                  return null;
                }
              },
            ).paddingBottom(10),
            CustomButton(
              label: isUpdate ? "Update" : "Add",
              onTap: () {
                if (isUpdate) {
                  context.read<TaskProvider>().updateTask(
                    index: index,
                    id: taskModel!.id,
                    context: context,
                  );
                } else {
                  context.read<TaskProvider>().addTask(context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
