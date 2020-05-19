import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(child: MaterialApp(home: ProviderPage()), create: (BuildContext context) {return TestModel();},));
}

class TestModel extends ChangeNotifier {
  int index = 0;

  setIndex(int i) {
    index = i;
    notifyListeners();
  }
}

class ProviderPage extends StatefulWidget {
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Provider"),
      ),
      body: Column(
        children: <Widget>[
          Text(Provider.of<TestModel>(context).index.toString()),
          RaisedButton(onPressed: () {
            Provider.of<TestModel>(context,listen: false).setIndex(count++);
          }, child: Text("add"))
        ],
      ),
    );
  }
}
