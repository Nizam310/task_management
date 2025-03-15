import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/main.dart';
import 'package:task_management/pages/Home/widgets/task_add_dialogue.dart';
import 'package:task_management/pages/home/widgets/task_list.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/util/custom_widgets/menu_button.dart';
import 'package:task_management/util/extension/padding_extension.dart';
import 'package:task_management/util/sqlite/sqlite_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF26293c),
      appBar: AppBar(
        backgroundColor: Color(0xFF223E6D),
        title: Text("Task Manager"),
        centerTitle: true,
        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, child) {
              return CupertinoSwitch(
                value: provider.isOnline,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.red,
                onChanged: (val) {
                  provider.toggleOnlineStatus(val);
                },
              ).paddingSymmetric(horizontal: 20, vertical: 5);
            },
          ),
        ],
      ),
      body: TaskList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MenuButton(
        items: [
          CustomMenuItem(
            name: "Create Task",
            icon: Icons.add_chart_outlined,
            onTap: () async {
              showDialog(
                context: context,
                builder: (builder) => TaskAddDialogue(),
              );
            },
          ),
          CustomMenuItem(
            name: "Import Task",
            icon: Icons.download_for_offline,
            onTap: () async {
              SqliteService.importFromSQLite(objectBox.store);
            },
          ),
          CustomMenuItem(
            name: "Export Task",
            icon: Icons.upload_file,
            onTap: () async {
              await SqliteService.exportToSQLite(objectBox.store);
            },
          ),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }
}

class CustomMenuItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function() onTap;

  const CustomMenuItem({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF223E6D),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ).paddingRight(4),
            Icon(icon, color: Colors.white, size: 17),
          ],
        ),
      ),
    );
  }
}
