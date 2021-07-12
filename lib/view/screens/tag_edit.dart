import 'package:flutter/material.dart';
import 'package:presc/view/utils/ripple_button.dart';

class TagEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tagList = ['宮沢賢治', '練習用'];

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: _appbar(context),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var tag in _tagList)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        children: [
                          Icon(Icons.tag, color: Colors.black45),
                          SizedBox(width: 32),
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.black45,
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: tag,
                                  selection: TextSelection.collapsed(
                                      offset: tag.length),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.black45),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 32, right: 16),
                            child: TextField(
                              cursorColor: Colors.black45,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                                hintStyle: TextStyle(fontSize: 16),
                                hintText: '新しいタグを追加',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "タグの編集",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
