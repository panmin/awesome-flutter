import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredTest extends StatefulWidget {
  @override
  _StaggeredTestState createState() => _StaggeredTestState();
}

class _StaggeredTestState extends State<StaggeredTest> {
  ScrollController _scrollController;
  int _count = 8;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() async {
        await Future.delayed(Duration(seconds: 5));
        var px = _scrollController.position.pixels;
        if (px >= _scrollController.position.maxScrollExtent) {
          print("加载过多");
          setState(() {
            _count += _count;
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Staggered grid view'),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 5));
                },
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                    controller: _scrollController,
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 10,
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      return Container(
                          color: Colors.green,
                          child: new Center(
                            child: new CircleAvatar(
                              backgroundColor: Colors.white,
                              child: new Text('$index'),
                            ),
                          ));
                    },
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(2, index == 0 ? 2.5 : 3)),
              ),
            ),
          ],
        ));
  }
}
