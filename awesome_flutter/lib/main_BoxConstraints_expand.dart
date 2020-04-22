import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BoxConstraintsExpandPage(),
  ));
}

class BoxConstraintsExpandPage extends StatefulWidget {
  @override
  _BoxConstraintsExpandPageState createState() => _BoxConstraintsExpandPageState();
}

class _BoxConstraintsExpandPageState extends State<BoxConstraintsExpandPage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Text("aaaaa"),
                  ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                      color: Colors.amberAccent,
                      child: Text(index.toString()),
                    ),
                    itemCount: 100,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: (){
                _showBottomSheet();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: Colors.blue,
              ),
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }

  _showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context){
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.black54,
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              ),
            ),
            child: Text("aaaa"),
          ),
        ],
      );
    });
  }
}
