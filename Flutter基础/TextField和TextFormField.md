## Flutter--TextField和TextFormField

### TextField

> Material Design中的文本录入组件，相当于Android中的`EditText`。

#### 1、构造函数

```dart
const TextField({
    Key key,
	  //TextEditingController用来获取或者监听text内容的变化，注意在不需要时必须调用【dispose】方法销毁，可以在State的dispose生命周期中销毁。
    this.controller,
    ///myFocusNode = FocusNode();
    ///FocusScope.of(context).requestFocus(myFocusNode);//获取焦点
    ///myFocusNode.addListener((){
    ///  if(myFocusNode.hasFocus){
    ///      myFocusNode.unfocus()
    ///  };});//监听并取消焦点
    ///可以用来控制键盘的隐藏和显示
    this.focusNode,
  	/// InputDecoration(
		///     border: OutlineInputBorder(),
		///     labelText: 'Password',
		/// )
    this.decoration = const InputDecoration(),
  	/// 控制键盘显示字母还是数字，相当于Android中EditText的inputType
    TextInputType keyboardType,
  	/// 控制键盘右下角显示功能，相当于Android中EditText的imeOptions
    this.textInputAction,
  	/// 控制键盘大小写显示
  	/// characters 默认为每个字符使用大写键盘
  	/// sentence 默认为每个句子的第一个字母使用大写键盘
  	/// word 默认为每个单词的第一个字母使用大写键盘
  	/// none 默认使用小写
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
  	/// 文字显示的位置
    this.textAlign = TextAlign.start,
  	/// 文字竖向位置
    this.textAlignVertical,
  	/// 文字的方向
    this.textDirection,
  	/// 是否只读
    this.readOnly = false,
  	/// 是否显示光标
    this.showCursor,
  	/// 是否自动获取焦点
    this.autofocus = false,
  	/// 是否是密码
    this.obscureText = false,
  	/// 是否自动更正
    this.autocorrect = true,
  	/// 最大长度，设置此项会让控件右下角显示一个数量统计字符串，
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
  	/// 最大长度
    this.maxLength,
  	/// 跟maxLength对应，为false时，当输入长度超过最大长度时依然会展示；为true时则不会
    this.maxLengthEnforced = true,
  	/// 当内容改变时回调
    this.onChanged,
  	/// 按回车键时回调
    this.onEditingComplete,
  	/// 按回车键提交内容时回调
    this.onSubmitted,
  	/// 限制输入的最大长度，TextField右下角没有输入数量的统计字符串
  	/// [LengthLimitingTextInputFormatter(11)]
  	/// 允许的输入格式，下方的模式指只允许输入数字
  	/// [WhitelistingTextInputFormatter.digitsOnly]
    this.inputFormatters,
    this.enabled,
  	/// 光标宽度
    this.cursorWidth = 2.0,
  	/// 光标圆角弧度
    this.cursorRadius,
  	/// 光标颜色
    this.cursorColor,
  	/// 控制键盘的外观，此设置仅适用于iOS设备，默认对应ThemeData.primaryColorBrightness
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
  	/// 结合focusNode使用来获取焦点和释放焦点
    this.onTap,
  	/// 
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
  })
```

#### 2、具体使用

##### 2.1、如何控制键盘收起？

思路：使用`focusNode`属性，通过`FocusScope`来获取焦点和取消焦点，从而达到控制键盘的作用

```dart
FocusNode myFocusNode = FocusNode();
......
  TextField(
  	focusNode: myFocusNode
	)
......
//获取焦点
FocusScope.of(context).requestFocus(myFocusNode);
//取消焦点
myFocusNode.unfocus();
```

##### 2.2、自带Material Design输入框效果如何实现？如自带label和hint提示

思路：使用`decoration`属性，设置`InputDecoration`的`labelText`和`hintText`。

```dart
TextField(
	decoration: InputDecoration(
    hintText: "请输入手机号",
    labelText: "手机号",
  )
)
```

##### 2.3、自带删除按钮功能如何显示和隐藏？

思路：使用`decoration`属性，设置`InputDecoration`的`suffixIcon`，然后通过`TextEditingController`来清除输入框的内容和监控文本的长度来控制删除按钮的显示和隐藏。

```dart
TextEditingController myEditController;
bool isShowClearButton = false;
@override
void initState(){
  myEditController = TextEditingController()
    ..addListener((){
      if(myEditController.text.length > 0){
        if(isShowClearButton == false){
          setState((){
            isShowClearButton = true;
          });
        }
      }else {
        if(isShowClearButton == true){
          setState((){
            isShowClearButton = false;
          });
        }
      }
    });
  super.initState();
}
......
  TextField(
  	controller: myEditController,
  	decoration: InputDecoration(
          hintText: "请输入手机号",
          labelText: "手机号",
          suffixIcon: isShowClearButton
              ? IconButton(
                  icon: Icon(Icons.cancel, color: Colors.grey, size: 20),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      myEditController.clear();
                    });
                  },
                )
              : null)
	)
......
  
@override
void dispose(){
  myEditController.dispose();
  super.dispose();
}
```

*注：TextEditingController 在不使用时一定要销毁。*

为了防止`invalid text selection`错误，使用了`WidgetsBinding.instance.addPostFrameCallback((_) {});`。

##### 2.4、如何实现限制字数的效果，而又不在右下角显示字符串数量统计？如何实现只能数字录入，字母和汉字无效？

> 当设置maxLength后，会在右下角显示一个字符串统计的数字，这种往往不是设计图上需要的，那我们应该如何在不显示这个统计的同时又限制了字数呢？

思路：不使用`maxLength`属性，使用`inputFormatters`控制

```dart
import 'package:flutter/services.dart';
......
  TextField(
		inputFormatters: [
      LengthLimitingTextInputFormatter(11),//限制字符长度，需要引入services库	
      WhitelistingTextInputFormatter.digitsOnly //限制只允许输入数字
    ],
	)
......
```

##### 2.5、`onChange`的作用





