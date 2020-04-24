## Flutter问题总结

1. `AspectRatio`设置宽高比可以用来配置图片的显示的比例

   ```dart
   AspectRatio(aspectRatio: headUrl.width / headUrl.height, child: ImageLoader.loadImageView(context, headUrl.url, fit: BoxFit.cover)),
   ```

2. `EdgeInsets.symmetric(vertical: 20, horizontal: 20)`控制横向、竖向的间隔

3. `SingleChildScrollView`嵌套`ListView`提示：`Vertical viewport was given unbounded height.`

   解决方案：`ListView`设置`shrinkWrap:true`

4. `Container`属性`constraints`：`BoxConstraints.expand()`的使用，当内部有ListView或者GridView这种可滚动不一定能确定高度的组件时使用可以撑满屏幕，如：

   ```dart
   Stack(
     children: <Widget>[
       Container(
         constraints: BoxConstraints.expand(),// 核心代码
         child: SingleChildScrollView(
           child: Column(
             children: <Widget>[
               ListView.builder(
                 shrinkWrap: true,
                 itemBuilder: (context, index) => Container(
                   color: Colors.amberAccent,
                   child: Text(index.toString()),
                 ),
                 itemCount: 10,
               )
             ],
           ),
         ),
       ),
       Positioned(
         child: Container(
           width: MediaQuery.of(context).size.width,
           height: 60,
           color: Colors.blue,
         ),
         bottom: 0,
       )
     ],
   ),
   ```

5. 多个可滚动组件，滚动冲突问题，可以使用同一个`ScrollController`解决

6. `GridView`组件设置宽高比时，需要注意`Text`这种组件会不会出现**换行**的情况

7. `showModalBottomSheet`不能设置圆角，解决方案：

   ```dart
   showModalBottomSheet(context: context, builder: (context){
     return Stack(
       children: <Widget>[
         Container(
           width: double.infinity,
           color: Colors.black54,
           height: 10,
         ),
         Container(
           width: double.infinity,
           decoration: BoxDecoration(
             color: Colors.amber,
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(10),
               topRight: Radius.circular(10)
             )
           ),
         ),
       ],
     );
   });
   ```

8. `showModalBottomSheet`的**最大高度**不超过半屏幕，原因是:

   ```dart
   maxHeight: isScrollControlled ? constraints.maxHeight : constraints.maxHeight * 9.0 / 16.0
   ```

   源码中有限制。要解决的话需要修改源码了

9. `Column`被撑开时，如何设置高度收紧？

   ```dart
   Column(mainAxisSize: MainAxisSize.min,)
   ```

10. `Stack`使用`fit: StackFit.expand`时，子组件`Container`设置高度无效，解决方案：

    使用`Positioned`包裹`Container`，通过`left`、`right`、`top`、`bottom` 控制位置，这样`Container`才会自适应子组件的高度。