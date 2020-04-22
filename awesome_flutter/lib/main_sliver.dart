import 'package:flutter/material.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: MySliverPage2(),
    );
  }
}

class MySliverPage extends StatefulWidget {
  @override
  _MySliverPageState createState() => _MySliverPageState();
}

class _MySliverPageState extends State<MySliverPage> with TickerProviderStateMixin {
  var rpx = 0.0;

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _header(),
            ),
            expandedHeight: 300 * rpx,
            bottom: TabBar(
              tabs: [
                Text("aaaa"),
                Text("bbb"),
              ],
              controller: _tabController,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Text("第$index");
          }, childCount: 50))
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3386247472,87720242&fm=26&gp=0.jpg",
          fit: BoxFit.fitWidth,
          width: 750 * rpx,
          height: 200 * rpx,
        ),
        Text(
          "aaaaa",
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}

class MySliverPage2 extends StatefulWidget {
  @override
  _MySliverPage2State createState() => _MySliverPage2State();
}

class _MySliverPage2State extends State<MySliverPage2> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {}),
        title: Text("sliver"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Text(
              "aaaaaaaa",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
              delegate: SliverTabBarDelegate(
                  Column(children: <Widget>[
                    TabBar(
                      tabs: [
                        Text(
                          "aaaa",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "bbbb",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                      controller: _tabController,
                    ),
                  ]),
                  20,
                  50)),
//          SliverAppBar(
//            floating: true,
//            pinned: true,
//            flexibleSpace: FlexibleSpaceBar(
//              background: Text("aaaaaaaa",style: TextStyle(fontSize: 20),),
//            ),
//            bottom: TabBar(tabs: [
//              Text("aaaa"),
//              Text("bbbb"),
//            ],
//            controller: _tabController,),
//          ),
          SliverList(delegate: SliverChildBuilderDelegate((context, index) => Text("第$index"))),
        ],
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double minHeight;
  final double maxHeight;

  SliverTabBarDelegate(this.widget, this.minHeight, this.maxHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
