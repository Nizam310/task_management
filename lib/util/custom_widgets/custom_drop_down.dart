import 'package:flutter/material.dart';
import 'package:task_management/util/extension/string_extension.dart';
// import 'package:nb_utils/nb_utils.dart';

class CustomDropDown<T extends Enum> extends StatelessWidget {
  final String label;
  final String? hint;
  final List<T> itemList;
  final void Function(T?)? onChanged;
  final T? value;
  final String? Function(T?)? validator;
  final void Function()? onTap;

  const CustomDropDown({
    super.key,
    required this.label,
    this.hint,
    required this.itemList,
    this.onChanged,
    this.value,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white),
    );

    return DropdownButtonFormField<T>(
      style: TextStyle(color: Colors.white),
      onTap: onTap,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border,
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        hintText: hint,
        isDense: false,
        hintStyle: const TextStyle(fontSize: 5),
      ),
      value: value,
      validator: validator,
      items:
          itemList.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.name.toString().capitalize(),
                overflow: TextOverflow.ellipsis,
                // sty/le: context.textTheme.bodyMedium,
              ),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
