## flutter的staggered GridView详细使用

### 一、简介
> flutter staggered gridview是一个支持多列网格大小不同的布局，且Android、iOS、Web都适用
在这种布局中每个单元格都可以称为一个Tile。
它有以下几种特性：
* 可以像GridView一样设置多列
* 在纵轴和主轴上可以设置Tile的个数或者所占用的比例（如crossAxisCount：4，StaggeredTile.fit(2)则表示在纵轴上有两列，如果StaggeredTile.fit(1)则表示在纵轴上有4列，如果使用StaggeredTile.Count(2,index==0?2.5:3)则表示纵轴有两列并且主轴方向上第一个Tile的大小其他Tile高度的2.5比3）
* 可以设置Tile间的行间距和列间距
* 能够在CustomScollerView内使用（可以用shrinkWrap:true，以及ScrollerController关联两个Widget）
* Tile能够在主轴方向上自适应高度（这是比GridView好的地方，不用设置宽高比，不担心溢出）

### 二、使用
### 2.1、pubspec.yaml添加依赖
```yaml
dependencies:
   flutter_staggered_grid_view:
```

#### 2.2、导包
```dart
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart’;
```

#### 2.3、6种创建方式
区别：
* `StaggeredGridView.count`和`StaggeredGridView.extent`，前者创建了一个纵轴方向固定Tile个数的布局，后者只是在纵轴方法指定了一个Tile个数的最大值，这两种都是适合子Widget个数比较少的情况，都是List<Widget>来设置
* `StaggeredGridView.countBuilder`和`StaggeredGridView.extentBuild`，这两个跟上面的含义差不多，区别在于适合子Widget数量比较多的需要动态创建的情况
* 更高级的还有`StaggeredGridView.builder`和`StaggeredGridView.custom`，区别在于创建的方式不同，而且也更加灵活
#### 2.4、StaggeredTile的使用
* StaggeredTile.count：固定纵轴和主轴上的数量
* StaggeredTile.extent：纵轴上的数量和主轴上的最大范围
* StaggeredTile.fit：纵轴上的数量

   **StaggeredGridView有几列是由crossAxisCount除以StaggeredTile设置上的纵轴的数量的结果。**

### 三、应用场景
#### 3.1、无法确定GridView中的item的高度，所以无法设置宽高比，这种情况可以使用StaggeredGridView来自动适配高度
```dart
StaggeredGridView.countBuilder(
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
        StaggeredTile.fit(2))
```

#### 3.2、瀑布流样式
```dart
StaggeredGridView.countBuilder(
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
        StaggeredTile.count(2, index == 0 ? 2.5 : 3))
```

#### 3.3、配合RefreshIndicator实现下拉刷新
```dart
CustomScrollView(
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
))
```

### 四、常见问题总结（持续更新）

#### 4.1、嵌套CustomScrollView使用时无法滑动

1、升级`StaggeredGridView`的版本，据说0.3.0以上版本已经解决

2、StaggeredGridView设置`shrinkWrap:true`