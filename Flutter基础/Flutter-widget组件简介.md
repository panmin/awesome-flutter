## Flutter widget组件简介

### 一、简介

Flutter Widget采用现代**响应式**框架构建，核心思想是用`widget`组件来构建UI，当`widget`的状态发生变化时，`widget`也会对应重新构建UI，Flutrer会对比前后变化的不同，以确定底层渲染树从一个状态转换到下一个状态所需的最小更改。

### 二、入口程序

通过`flutter create`创建的项目，我们可以看到在`lib`目录下有一个默认的`mian.dart`文件，下面来看下这个文件里的内容。

Flutter跟Java程序一样，程序要跑起来就必须要一个入口，Java中用的是main方法当作入口，Flutter也是一样

```dart
void main() => runApp(MyApp());
```

这个`main`就是`flutter`的入口，使用`runApp`函数可以将给定的根组件填满整个屏幕。

### 三、基础的widget

#### 3.1 无状态和有状态的组件

接着看`flutter create`创建出来的这个项目代码：

```dart
class MyApp extends StatelessWidget {}
class MyHomePage extends StatefulWidget {}
```

* **StatelessWidget**表示无状态的组件，这个意味着它里面的值都是不可变的

* **StatefulWidget**表示有状态的组件，这个意味着`StatefulWidget`持有的状态在widget的生命周期中发生改变，创建一个**StatefulWidget**需要两个类：

  ```dart
  class MyHomePage extends StatefulWidget {
    @override 
    _MyHomePageState createState() => _MyHomePageState();
  }
  class _MyHomePageState extends State<MyHomePage> {
    @override 
    Widget build(BuildContext context){
      return Container();
    }
  }
  ```

  *StatefulWidget类本身是不变的，但State类在Widget中的生命周期是始终存在的*

#### 3.2 常用的基础Widget

* `Text`：带格式的文本。相当于Android中的`TextView`
* `Row`、`Column`：水平和垂直方向的布局组件。符合Vue中的Flexbox布局模型，相当于Android中的`LinearLayout的orientation=horizontal和vertical`
* `Stack`：允许子widget堆叠，可以用`Positioned`来定位上下左右的位置。相当于Android中的`RelativeLayout`
* `Container`：创建一个矩形视觉元素，可以通过`BoxDecoration`设置background、边框、阴影。相当于C#中的`panel`

### 四、Material组件

几乎所有的dart文件中都会引入`flutter/material.dart`这个包，这个是一个实现了`Material Design`风格的组件库，如`flutter create`创建出来的这个项目代码中的`MaterialApp`、`Scaffold`、`Navigator`等组件

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```



### 五、State的生命周期

Flutter程序可以看成是一个巨大的状态机器，用户的操作、网络请求、系统事件都是推动这个状态机运行的触发点，触发点通过`setState`来推动状态机的改变。

**`构造函数`-->`initState`-->`didChangeDepencies`-->`build`-->`deactivate`-->`dispose`**

* 构造函数：调用一次
* initState：调用一次，在这里可以做一些初始化的工作，比如变量初始化、调用网络接口。相当于Android中的`onCreate`
* didChangeDependencies：多次调用，在`initState`之后立刻调用，在`InheritedWidget rebuild`时也会触发调用
* build：调用多次，第一次绘制界面时调用，当setState时也会被触发调用
* didUpdateWidget：组件状态改变时调用，可能会调用多次，在widget重新构建时，Flutter framework会调用`Widget.canUpdate`来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果`Widget.canUpdate`返回`true`则会调用此回调。正如之前所述，`Widget.canUpdate`会在新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等时`didUpdateWidget()`就会被调用。如rebuild、hot reload
* deactivate：调用多次，当移除渲染树时调用，比如跳转新界面、栈顶界面被销毁时都会调用。相当于Android中的`onDetatch`和`onResume`
* dispose：调用一次，组件即将销毁时调用。相当于Android中的`onDestroy`

看下面的代码例子：

```dart
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
```

我们想下这个`print`打印结果的先后顺序是什么？

1. WidgetLifePage和WidgetLifePage2启动时分别调用了哪些生命周期的方法？

   ```dart
   //WidgetLifePage启动时
   page1 initState
   page1 didChangeDependencies
   page1 build
   
   //WidgetLifePage2启动时
   page2 initState
   page2 didChangeDependencies
   page2 build
   ```

2. WidgetLifePage跳转WidgetLifePage2时分别调用了哪些生命周期？

   ```dart
   page2 initState
   page2 didChangeDependencies
   page2 build
   page1 deactivate
   page1 build
   ```

3. WidgetLifePage2关闭时WidgetLifePage和WidgetLifePage2分别调用了哪些生命周期？

   ```dart
   page1 deactivate
   page1 build
   page2 deactivate
   page2 dispose
   ```

4. `setState`执行时有哪些生命周期方法被触发了？

   **setState**会导致Widget重新绘制，也就是**build**方法被触发。



