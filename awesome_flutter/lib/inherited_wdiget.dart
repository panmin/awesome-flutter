import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SharePage(),
  ));
}

class ShareWidget extends InheritedWidget {
  final int data;

  ShareWidget({@required this.data, Widget child}) : super(child: child);

  static ShareWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareWidget>();
  }

  @override
  bool updateShouldNotify(ShareWidget oldWidget) {
    return oldWidget.data != data;
  }
}

class _TestWidget extends StatefulWidget {
  @override
  __TestWidgetState createState() => __TestWidgetState();
}

class __TestWidgetState extends State<_TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(ShareWidget.of(context).data.toString());
  }
  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }
}

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("InheritedWidget"),
      ),
      body: ShareWidget(
        data: index,
        child: Column(
          children: <Widget>[
            _TestWidget(),
            RaisedButton(
              onPressed: () {
                setState(() {
                  index++;
                });
              },
              child: Text("add"),
            ),
            TestWidget()
          ],
        ),
      ),
    );
  }
}
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("test");
  }
}


//class ShareWidget extends InheritedWidget {
//  final int selectIndex;
//
//  ShareWidget({
//    @required this.selectIndex,
//    Widget child
//  }) :super(child: child);
//
//
//  static ShareWidget of(BuildContext context) {
//    return context.dependOnInheritedWidgetOfExactType<ShareWidget>();
//  }
//
//  @override
//  bool updateShouldNotify(ShareWidget oldWidget) {
//    return oldWidget.selectIndex != selectIndex;
//  }
//}
//
//class SharePage extends StatefulWidget {
//  @override
//  _SharePageState createState() => _SharePageState();
//}
//
//class _SharePageState extends State<SharePage> with TickerProviderStateMixin {
//  TabController _tabController;
//  int _selectedIndex = 0;
//
//  @override
//  void initState() {
//    _tabController = TabController(length: 2, vsync: this)
//      ..addListener(() {
//        if (_tabController.animation.value == _tabController.index) {
//          setState(() {
//            _selectedIndex = _tabController.index;
//          });
//          print(_selectedIndex);
//        }
//      });
//    _selectedIndex = _tabController.index;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("TabBar"),
//      ),
//      body: ShareWidget(selectIndex: _selectedIndex,
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Text(ShareWidget.of(context).selectIndex.toString()),
//            RaisedButton(onPressed: () {
//              setState(() {
//                _selectedIndex++;
//              });
//            },child: Text("add"),)
//            /*SizedBox(
//              height: 50,
//              child: ShareWidget(
//                  _tabController.index,
//                  TabBar(
//                    tabs: [_getTabTitle("aaaa", 0), _getTabTitle("bbbb",1)],
//                    controller: _tabController,
//                  )),
//            ),
//            Expanded(
//              child: TabBarView(
//                children: [
//                  Center(child: Text("aaaa content")),
//                  Center(child: Text("bbbb content"))
//                ],
//                controller: _tabController,
//              ),
//            )*/
//          ],
//        ),
//      ),
//    );
//  }
//
//  _getTabTitle(String title, int index) {
//    return Container(
//      decoration: BoxDecoration(
//          color: _selectedIndex == index ? Colors.yellow : Colors.white),
//      child: Text(title, style: TextStyle(color: Colors.black)),
//    );
//  }
//}
