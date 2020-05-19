import 'package:flutter/material.dart';


class MySliverAppBarPage extends StatefulWidget {
  @override
  _MySliverAppBarPageState createState() => _MySliverAppBarPageState();
}

class _MySliverAppBarPageState extends State<MySliverAppBarPage> {
  var rpx = 0.0;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: Icon(Icons.arrow_back, color: Colors.white),
          flexibleSpace: _flexibleSpace(),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Text("a"),
          Text("a"),
          Text("a"),
          Text("a"),
          Text("a"),
          Text("a"),
        ]))
      ],
    );
  }

  Widget _flexibleSpace() {
    return Stack(
      children: <Widget>[
        Image.network(
            "https://pics5.baidu.com/feed/35a85edf8db1cb13191e06396179d24892584b5c.png?token=232fa6da1136ced780c3fb7b8d2b9c94",
            width: 750 * rpx,
            height: 200 * rpx),
        Container(
          margin: EdgeInsets.only(top: 180 * rpx),
          child: CircleAvatar(
            child: Image.network(
                "http://img0.imgtn.bdimg.com/it/u=2798216820,1841993320&fm=26&gp=0.jpg",
                width: 50 * rpx,
                height: 50 * rpx),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 210 * rpx),
          margin: EdgeInsets.symmetric(horizontal: 20 * rpx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text("+关注"), Icon(Icons.add_location)],
          ),
        ),
        Divider(color: Colors.black,)
      ],
    );
  }
}
