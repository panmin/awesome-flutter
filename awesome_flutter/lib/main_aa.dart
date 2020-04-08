import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(theme:ThemeData(
  ),home: TestPage(),));
}

class TestPage extends StatelessWidget {

  BoxShadow _shadow() => BoxShadow(color: Color(0x5D5D5D),offset: Offset(0, 5),blurRadius: 12,spreadRadius: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text("签到课程表"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Color(0xF6F6F6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("2019年04月16日（周一）"),
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(6)),boxShadow:[_shadow(),_shadow(),_shadow(),_shadow()] ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _row1(),
                      Text("篮球中教课U5"),
                      _row3(),
                      _for()
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _row1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: Text("17:30 至 19:0017:30 至 19:0017:30 至 19:0017:30 至 19:0017:30 至 19:0017:30 至 19:00",
          maxLines: 1,overflow: TextOverflow.ellipsis,)),
        Text("已结束")
      ],
    );
  }

  Widget _row3() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 7),
          child: Text("约课人数"),
        ),
        Expanded(child: Text("10人（实际/7人 体验/3人 在籍/4人）10人（实际/7人 体验/3人 在籍/4人）10人（实际/7人 体验/3人 在籍/4人）10人（实际/7人 体验/3人 在籍/4人）"))
      ],
    );
  }
  Widget _for(){
    List<String> list = ["1","2","3","1","2","3","1","2","3"];
    List<Widget> listWidget = [];
    list.forEach((str){
      listWidget.add(Text(str));
    });
    return Column(
      children: listWidget.toList(),
    );
  }
}

