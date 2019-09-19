import 'package:flutter/material.dart';

void main() {
  runApp(TextFieldApp());
}

class TextFieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextFieldPage(),
    );
  }
}

class TextFieldPage extends StatefulWidget {
  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  FocusNode myFocusNode;
  String _focusRadio;

  @override
  void initState() {
    myFocusNode = FocusNode()
      ..addListener(() {
        print("focus node");
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextField的使用"),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        children: <Widget>[
          _focusNodeDemo(),
          _keyboardTypeDemo(),
          _textInputAction(),
        ],
      ),
    );
  }

  //焦点控制属性
  _focusNodeDemo() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey, width: 1)),
          child: ExpansionTile(
            title: Text("focusNode属性控制焦点"),
            children: <Widget>[
              RadioListTile(
                  title: Text("获取焦点，FocusScope.of(context).requestFocus(myFocusNode)"),
                  value: "获取焦点",
                  groupValue: _focusRadio,
                  onChanged: (value) {
                    setState(() {
                      _focusRadio = value;
                    });
                    FocusScope.of(context).requestFocus(myFocusNode);
                  }),
              RadioListTile(
                  title: Text("取消焦点，myFocusNode.unfocus()"),
                  value: "取消焦点",
                  groupValue: _focusRadio,
                  onChanged: (value) {
                    setState(() {
                      _focusRadio = value;
                    });
                    myFocusNode.unfocus();
                  }),
            ],
          ),
        ),
        TextField(
          focusNode: myFocusNode,
          decoration: InputDecoration(labelText: "焦点控制"),
        )
      ],
    );
  }

  //控制键盘显示字母还是数字
  _keyboardTypeDemo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey, width: 1)),
      child: ExpansionTile(
        title: Text("keyboardType"),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "phone"),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            decoration: InputDecoration(labelText: "text(普通全键盘)"),
            keyboardType: TextInputType.text,
          ),
          TextField(
            decoration: InputDecoration(labelText: "number(数字键盘)"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: InputDecoration(labelText: '''url(普通键盘，带有“/” 和 "." 符号)'''),
            keyboardType: TextInputType.url,
          ),
          TextField(
            decoration: InputDecoration(labelText: "datetime(数字键盘，带有 “/” 和 “:” 符号)"),
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            decoration: InputDecoration(labelText: "emailAddress(普通键盘，带有“@”符号)"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: InputDecoration(labelText: "multiline&maxLines=2(普通键盘，能换行,只显示maxLines行)"),
            maxLines: 2,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  //控制键盘右下角显示功能
  _textInputAction() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey, width: 1)),
      child: ExpansionTile(
        title: Text("textInputAction"),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "next"),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            decoration: InputDecoration(labelText: "done"),
            textInputAction: TextInputAction.done,
          ),
          TextField(
            decoration: InputDecoration(labelText: "search"),
            textInputAction: TextInputAction.search,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'continueAction'),
            textInputAction: TextInputAction.continueAction,
          )
        ],
      ),
    );
  }
}
