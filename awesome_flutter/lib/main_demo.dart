import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      backgroundColor: Color(0xF6F6F6)
    ),
    home: DemoPage(),
  ));
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, color: Colors.black),
        title: Text("签到课程表"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _getGroupItem(),
        ],
      ),
    );
  }

  BoxShadow _getBoxShaw() => BoxShadow(color: Color(0xFFFFFF), offset: Offset(0, 5), blurRadius: 12, spreadRadius: 0);

  Widget _getGroupItem() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("2019年04月16日（周一）"),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 15),
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(6)), boxShadow: [_getBoxShaw(),_getBoxShaw(),_getBoxShaw(),_getBoxShaw()]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _row1(),
                Text("篮球中教课篮球中教课篮球中教课篮球中教课篮球中教课篮球中教课篮球中教课"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("约课人数"),
                    Expanded(child: Text("约课人数值约课人数值约课人数值约课人数值约课人数值约课人数值"))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _row1() {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: Text("时间时间时间时间时间时间时间时间时间时间时间时间时间时间",maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  Text("上课中")
                ],
              );
  }
}
