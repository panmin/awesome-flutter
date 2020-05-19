import 'package:flutter/material.dart';

class ShaderMaskTest extends StatefulWidget {
  @override
  _ShaderMaskTestState createState() => _ShaderMaskTestState();
}

class _ShaderMaskTestState extends State<ShaderMaskTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("ShaderMask"),
      ),
      body: Center(
        child: ShaderMask(
          shaderCallback: (rect) {
            return RadialGradient(
                    radius: 1,
                    tileMode: TileMode.mirror,
                    colors: <Color>[Colors.yellow, Colors.deepOrange],
                    center: Alignment.topLeft)
                .createShader(rect);
          },
          child: Text(
            "Bruning Text",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
      ),
    );
  }
}
