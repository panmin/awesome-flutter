import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

void main(){
  runApp(MaterialApp(
    home: Scaffold(
      body: Container(
        color: Colors.blue,
        child: Text("aaaa",style: TextStyle(),),
      ),
    ),
  ));
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
