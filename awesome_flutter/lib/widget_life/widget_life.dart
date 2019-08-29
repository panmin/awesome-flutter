import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: WidgetLifePage(),
    );
  }
}

class WidgetLifePage extends StatefulWidget {
  @override
  _WidgetLifePageState createState() => _WidgetLifePageState();
}

class _WidgetLifePageState extends State<WidgetLifePage> {
  int _page1Count = 0;
  Color _color = Colors.black;

  _increase() {
    setState(() {
      _page1Count++;
    });
    _changeColor();
  }

  _changeColor() {
    setState(() {
      _color == Colors.black ? _color = Colors.blue : _color = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("page1 build");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "widget life page 1 count = $_page1Count",
              style: TextStyle(color: _color),
            ),
            RaisedButton(
              onPressed: () => _increase(),
              child: Text("增加"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WidgetLifePage2()));
              },
              child: Text("跳转"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    print("page1 initState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("page1 didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(WidgetLifePage oldWidget) {
    print("page1 didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("page1 deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("page1 dispose");
    super.dispose();
  }
}

class WidgetLifePage2 extends StatefulWidget {
  @override
  _WidgetLifePage2State createState() => _WidgetLifePage2State();
}

class _WidgetLifePage2State extends State<WidgetLifePage2> {
  int _page2Count = 0;

  _increase() {
    setState(() {
      _page2Count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("page2 build");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("widget life page 2 count = $_page2Count"),
            RaisedButton(
              onPressed: () => _increase(),
              child: Text("增加"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("返回"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    print("page2 initState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("page2 didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(WidgetLifePage2 oldWidget) {
    print("page2 didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("page2 deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("page2 dispose");
    super.dispose();
  }
}
