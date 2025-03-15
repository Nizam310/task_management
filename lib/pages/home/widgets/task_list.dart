import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/pages/Home/widgets/task_add_dialogue.dart';
import 'package:task_management/util/extension/padding_extension.dart';
import 'package:task_management/util/extension/string_extension.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../model/task_model.dart';
import '../../../provider/task_provider.dart';
import '../../../util/custom_widgets/custom_icon_button.dart';
import '../../../util/custom_widgets/row_value_text.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TaskProvider>();
    return SingleChildScrollView(
      child: Column(
        children:
            context
                .select<TaskProvider, List<TaskModel>>(
                  (provider) => provider.taskList,
                )
                .asMap()
                .entries
                .map((v) {
                  var e = v.value;
                  var index = v.key;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            provider.setSelectedIndex(index);
                          },
                          child: Container(
                            height: 140,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff2e344e),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    context.select<TaskProvider, bool>(
                                          (provider) =>
                                              provider.dueDate(e.dueDate),
                                        )
                                        ? Colors.red
                                        : provider.selectedIndex == index
                                        ? Colors.white
                                        : Colors.transparent,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: context.select<TaskProvider, bool>(
                                    (provider) => provider.dueDate(e.dueDate),
                                  ),
                                  child: Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Due",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: WaveWidget(
                                      config: CustomConfig(
                                        gradients: [
                                          provider.getWaveColor(e.priority),
                                        ],
                                        durations: [5000],
                                        heightPercentages: [
                                          provider.getWaveHeight(e.status),
                                        ],
                                        // Adjust for height inside container
                                        gradientBegin: Alignment.bottomLeft,
                                        gradientEnd: Alignment.bottomLeft,
                                      ),
                                      size: Size(
                                        double.infinity,
                                        double.infinity,
                                      ),
                                      waveAmplitude: 5,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title.capitalize(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(color: Colors.white),
                                          ).paddingBottom(10),
                                          RowValueText(
                                            value: e.description,
                                            title: "Description",
                                          ),
                                          RowValueText(
                                            value: e.priority,
                                            title: "Priority",
                                          ),
                                          RowValueText(
                                            value: e.status,
                                            title: "Status",
                                          ),
                                          RowValueText(
                                            value: e.dueDate,
                                            title: "Due date",
                                          ),
                                        ],
                                      ),
                                      if (provider.selectedIndex == index)
                                        Row(crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomIconButton(
                                              icon: Icons.edit,
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return TaskAddDialogue(
                                                      isUpdate: true,
                                                      taskModel: e,
                                                      index: index,
                                                    );
                                                  },
                                                );
                                              },
                                            ).paddingRight(10),
                                            CustomIconButton(
                                              icon: Icons.delete,
                                              onTap: () {
                                                context
                                                    .read<TaskProvider>()
                                                    .removeTask(
                                                      index: index,
                                                      id: e.id,
                                                    );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
                .toList(),
      ),
    );
  }
}
