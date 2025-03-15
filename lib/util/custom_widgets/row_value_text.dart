import 'package:flutter/material.dart';
import 'package:task_management/util/extension/padding_extension.dart';
import 'package:task_management/util/extension/string_extension.dart';

class RowValueText extends StatelessWidget {
  final String value;
  final String title;

  const RowValueText({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            text: "$title : ",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
            children: [
              TextSpan(
                text: value.capitalize(),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    ).paddingBottom(5);
  }
}
