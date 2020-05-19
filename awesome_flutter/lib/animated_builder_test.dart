import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBuilderTest extends StatefulWidget {
  @override
  _AnimatedBuilderTestState createState() => _AnimatedBuilderTestState();
}

class _AnimatedBuilderTestState extends State<AnimatedBuilderTest>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(begin: 0, end: 2 * pi).animate(_controller);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text("AnimatedBuilder"),
      ),
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.rotate(
          angle: animation.value,
          child: Container(
            width: 100,
            height: 100,
            child: child,
            color: Colors.blue,
            alignment: Alignment.center,
          ),
        ),
        child: Text("aaaa"),
      ),
    );
  }
}
