## Flutter动态化-Android（二）

> 上一篇文章我们已经了解如何修改flutter engine代码实现动态化效果，这一篇文章主要是讲解，flutter build aar的过程，然后修改对应的gradle编译脚本，目的是打出适合混合工程使用的aar包。

### 一、flutter build aar打包结果

> 这一小节，我们先来看下正常使用`flutter build aar`打包出的aar的结构是怎么样的

#### 1.1、前置条件

Android混合工程，先创建一个新的Android项目，然后新建`flutter module`，也可以使用`flutter create -t module --org com.example flutter_module`创建。

`cd flutter_module`，然后执行`flutter pub get`，会自动创建`.android`文件

#### 1.2、执行flutter build aar

<img src="./imgs/image-flutter_release.png" alt="image-20200413174834139" style="zoom:70%;" />

我们这里只分析release版本的aar，将`flutter_release-1.0.aar`的后缀修改成**jar**，然后用反编译工具**JD-GUI**打开`flutter_release-1.0.jar`，结果如下：

<img src="./imgs/image-flutter-release-jd-gui.png" alt="image-20200413175456832" style="zoom:67%;" />

可以看到打包的代码中没有`flutter.jar`的代码，也没有`libflutter.so`，那么这两个文件放在哪儿了呢？

如何将这两个文件打包到aar中呢？带着问题我们来看下执行`flutter build aar`过程中都执行了哪些脚本。

*这里先提一个解决方案，那就是`fat-aar`来打包aar，具体使用请大家自行百度*

### 二、flutter build aar的过程解析



### 三、如何修改gradle打包aar脚本

### 四、如何使用修改后的gradle脚本

### 五、如何傻瓜式使用实现动态化的flutter.jar和libflutter.so

