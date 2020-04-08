import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  debugPaintSizeEnabled = true;
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final int count;

  const CounterDisplay({Key key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('count=$count');
  }
}

class CounterIncrement extends StatelessWidget {
  final VoidCallback onPress;

  const CounterIncrement({Key key, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      child: Text("add"),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _increment() {
    setState(() {
      ++_count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Row(
          children: <Widget>[
            CounterDisplay(count: _count),
            CounterIncrement(
              onPress: _increment,
            )
          ],
        )),
      ),
    );
  }
}
