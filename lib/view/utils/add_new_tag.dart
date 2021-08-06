import 'package:flutter/material.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:provider/provider.dart';

class AddNewTag extends StatelessWidget {
  AddNewTag({this.fontSize = 16});

  final _controller = TextEditingController();
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.black45,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(0),
        hintStyle: TextStyle(fontSize: fontSize),
        hintText: '新しいタグを追加',
      ),
      onSubmitted: (text) {
        if (text.trim().isNotEmpty) {
          context.read<EditableTagItemProvider>().addTag(text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "新しいタグを追加しました",
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        _controller.clear();
      },
    );
  }
}