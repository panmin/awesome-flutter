## Flutter动态化-Android（一）

> 上篇我们讲了flutter engine编译环境搭建，这篇我们正式来看下如何修改flutter engine源码，实现动态化。
>
> 本篇文章将分为两部分来讲，本篇讲述有哪些核心代码需要修改的，如何编译engine源码，以及在flutter应用中该如何使用；下一篇会讲解如何打包编译成aar，以方便混合开发时使用。

### 一、flutter engine核心代码修改

> 思路：分析libapp.so和flutter_assets的加载过程，在加载之前修改源码替换需要成自己的路径

#### 1.1、`FlutterLoader`的`ensureInitializationComplete`

> 从前面的文章我们可以知道，这个方法主要是构建shellArgs列表，在C层代码中会调用此配置初始化参数

先看下面这段代码：

```java
if (BuildConfig.DEBUG || BuildConfig.JIT_RELEASE) {
		String snapshotAssetPath =
				PathUtils.getDataDirectory(applicationContext) + File.separator + flutterAssetsDir;
    kernelPath = snapshotAssetPath + File.separator + DEFAULT_KERNEL_BLOB;
    shellArgs.add("--" + SNAPSHOT_ASSET_PATH_KEY + "=" + snapshotAssetPath);
    shellArgs.add("--" + VM_SNAPSHOT_DATA_KEY + "=" + vmSnapshotData);
    shellArgs.add("--" + ISOLATE_SNAPSHOT_DATA_KEY + "=" + isolateSnapshotData);
}
```

在debug和JIT模式时会配置`flutter_assets`、`vm_snapshot_data`、`isolate_snapshot_data`的位置，我们知道在`libapp.so`文件的本质是相当于`vm_snapshot_data`、`isolate_snapshot_data`的打包合集，从这里我们可以找到想到将**`libapp.so`和`flutter_assets`**文件放到debug或者JIT模式时的文件路径下，也就是**`PathUtils.getDataDirectory(applicationContext)`**目录下。

我们再来看如何修改这个代码对应的`else`部分的代码：

```java
// 查看/user/0/package/app_flutter目录是否存在libapp.so文件，如果存在就传递这个新的路径，否则就还使用默认路径（也就是lib/arm/或者lib/arm64/）的libapp.so文件
File appFile = new File(PathUtils.getDataDirectory(applicationContext) + File.separator + aotSharedLibraryName);
String aotSharedLibraryPath = applicationInfo.nativeLibraryDir + File.separator + aotSharedLibraryName;
if(appFile.exists()){
  aotSharedLibraryPath = appFile.getPath();
}
shellArgs.add("--" + AOT_SHARED_LIBRARY_NAME + "=" + aotSharedLibraryPath);
```

如果不需要动态替换`flutter_assets`文件，其实上面就修改就足够动态替换`libapp.so`了。还有一种不用修改engine源码的方法就是在继承`FlutterActivity`时重写`getFlutterShellArgs`方法，把`AOT_SHARED_LIBRARY_NAME`传递成自定义的路径，亲测有效，小伙伴们自行尝试，有问题可以在留言区交流。

附上`AOT_SHARED_LIBRARY_NAME`在C层使用的代码

```c++
// 代码位置shell-->common-->switches.cc
if (aot_shared_library_name.size() > 0) {
  // 循环会导致最后一个shellArgs中AOT_SHARED_LIBRARY_NAME生效，不用担心设置了多个AOT_SHARED_LIBRARY_NAME
  for (std::string_view name : aot_shared_library_name) {
    settings.application_library_path.emplace_back(name);
  }
}
```

#### 1.2、`FlutterJNI`的`nativeAttach`

> 这是一个调用`libflutter.so`的jni方法，通过这个方法，我们可以传递一个路径到C层，在C层的初始化`AndroidShellHolder`之前将自定义的路径配置进去

修改后的`nativeAttach`方法体以及相关代码，如下

```java
private native long nativeAttach(@NonNull FlutterJNI flutterJNI, String dynamicPath, boolean isBackgroundView);

 public void attachToNative(String dynamicPath, boolean isBackgroundView) {
    ensureRunningOnMainThread();
    ensureNotAttachedToNative();
		// 因为当前类中无法获得Contenxt，所以需要FlutterNativeView和FlutterEngine调用attachToNative方法时传入路径   
    nativePlatformViewId = nativeAttach(this, dynamicPath, isBackgroundView);
 }
```

#### 1.3、`platform_view_android_jni.cc`修改

```c++
// 1. jni映射方法新增参数类型
bool RegisterApi(JNIEnv* env) {
  static const JNINativeMethod flutter_jni_methods[] = {
      // Start of methods from FlutterJNI
      {
          .name = "nativeAttach",
        	// 新增一个String参数类型
          .signature = "(Lio/flutter/embedding/engine/FlutterJNI;Ljava/lang/String;Z)J",
          .fnPtr = reinterpret_cast<void*>(&AttachJNI),
      },
    。。。

// 2. AttachJNI方法修改
static jlong AttachJNI(JNIEnv* env,
                       jclass clazz,
                       jobject flutterJNI,
                       jstring dynamicPath,
                       jboolean is_background_view) {
  fml::jni::JavaObjectWeakGlobalRef java_object(env, flutterJNI);
  const auto dynamic_path = fml::jni::JavaStringToString(env, dynamicPath);
  // 获取配置
  Settings settings = FlutterMain::Get().GetSettings();
  if(dynamic_path.size() > 0) {
      settings.application_library_path.clear();
    	// 在AndroidShellHolder初始化前设置新路径
      settings.application_library_path.emplace_back(dynamic_path + "/libapp.so");
      settings.assets_path = dynamic_path + "/flutter_assets";
  }

  FML_LOG(INFO) << "settings.assets_path:" << settings.assets_path;
	
  // 将修改后的settings传递进去
  auto shell_holder = std::make_unique<AndroidShellHolder>(
      settings, java_object, is_background_view);
  if (shell_holder->IsValid()) {
    return reinterpret_cast<jlong>(shell_holder.release());
  } else {
    return 0;
  }
}
```

#### 1.4、`FlutterNativeView`中相关修改的代码

```java
private void attach(FlutterNativeView view, boolean isBackgroundView) {
    mFlutterJNI.attachToNative(PathUtils.getDynamicPath(mContext), isBackgroundView);
    dartExecutor.onAttachedToJNI();
}
```

#### 1.5、`FlutterEngine`中相关修改的代码

```java
// 1. 构造函数中
attachToJni(context);

// 2. attachToJni方法修改
private void attachToJni(Context context) {
		Log.v(TAG, "Attaching to JNI.");
  	// TODO(mattcarroll): update native call to not take in "isBackgroundView"
    flutterJNI.attachToNative(PathUtils.getDynamicPath(context), false);

    if (!isAttachedToJni()) {
      throw new RuntimeException("FlutterEngine failed to attach to its native Object reference.");
    }
}
```

#### 1.6、`PathUtils`新增**getDynamicPath**方法

```java
// 获取动态化资源文件路径
public static String getDynamicPath(Context applicationContext){
    String packagePath = getDataDirectory(applicationContext);
    String aotLibFile = packagePath + File.separator + FlutterLoader.DEFAULT_AOT_SHARED_LIBRARY_NAME;
    String flutterAssetsPath = packagePath + File.separator + FlutterLoader.DEFAULT_FLUTTER_ASSETS_DIR;
    File aotFile = new File(aotLibFile);
    File flutterAssetsFile = new File(flutterAssetsPath);
    if (!aotFile.exists() && !flutterAssetsFile.exists()) {
      packagePath = "";
    }
    return packagePath;
}
```

到此，动态化所需要的方法基本都修改完了，具体代码请看**https://github.com/panmin/engine/tree/feature_my_engine**，欢迎**star**和**watch**，代码会不定期优化更新。

### 二、编译本地engine

> 修改完engine的代码，这一小节我们就来看看如何将修改后的engine编译成`flutter.jar`和`libflutter.so`

#### 2.1、编译相关基础知识

* **CPU架构**

  编译结果包括`arm`、`arm64`、`x86`这几种架构，arm对应Android的`armeabi-v7a`，arm64对应Android的`arm64-v8a`，x86还是`x86`一般是模拟器上用的。

* **是否优化**

  未优化的engine包是可以添加打印出C层的代码的，engine的C++里用`FML_LOG(INFO)`打印log；优化后的包体积也更小。

* **运行模式**

  根据flutter的模式是分为`debug`、`profile`、`release`这三种模式的。

#### 2.2、常用的编译参数

* `--android-cpu`: CPU架构，对应`arm`、`arm64`、`x86`，如：`gn --android-cpu arm`
* `--runtime-mode`: 运行模式，对应`debug`、`profile`、`release`，如：`gn --runtime-mode debug`
* `--unoptiimized`: 是否优化，带上这个参数就说明是不优化的情况

#### 2.3、编译开始

```shell
# 1、定位到`engine/src`目录
cd engine/src
# 2、编译Android对应平台已优化的release代码，这里大家根据自己的实际使用情况，合理的使用2.2中提到的编译参数
./flutter/tools/gn --android --runtime-mode release --android-cpu arm
# 通过2中的命令会在src目录下生成一个out/android_release的目录
# 3、编译2中生成的代码成为flutter.jar和libflutter.so，这一步就最耗时的，有快有慢，看电脑性能了
ninja -C out/android_release
# 如果2中使用的CPU架构是arm64时，3中的这一步就要用android_release_arm64文件夹了
# 4、编译Android打包时需要的代码
./flutter/tools/gn --runtime-mode release --android-cpu arm
# 5、同样编译一下
ninja -C out/host_android
# 如果4中使用的是arm64，这里就需要用host_android_arm64文件夹了
```

通过上的编译，我们可以看到`out/android_release`文件夹中已经生成了`flutter.jar`和里面已经包含了`libflutter.so`

### 三、使用本地engine

> 这一小节只讲解纯flutter项目时如何使用；至于混合开发的项目中如何使用，因为牵扯到一些gradle脚本的修改，我会单独抽出一篇文章来讲。

#### 3.1、使用本地engine打包apk

```shell
# 打包arm平台的apk
flutter build apk --target-plarform android-arm --split-per-abi --local-engine-src engine/src --local-engine=android-release
# 打包arm64平台的apk
flutter build apk --target-plarform android-arm --split-per-abi --local-engine-src engine/src --local-engine=android-release_arm64
```

#### 3.2、修改代码后如何查看新的`libapp.so`和`flutter_assets`文件

> 对于已经安装完使用本地engine打包的apk的手机来说，想动态更新新的代码，需要找到修改后代码打包生成的`libapp.so`和`flutter_assets`文件，这个文件怎么生成和找到的呢？

1. 修改dart代码
2. 使用3.1中的命令打包apk
3. 在跟`lib`同级别的目录`build/app/intermediates/flutter/release`下找到对应CPU架构的**`app.so`**文件，将其改名成**`libapp.so`**，然后在app启动时复制到`PathUtils.getDataDirectory(applicationContext)`对应的目录下，也就是`user/0/package/app_flutter`目录下；把`build/app/intermediates/flutter/release`目录下的`flutter_assets`也复制到这个目录下。
4. 待下次重启app时即可生效

### 四、总结

本篇文章讲解了flutter engine代码实现动态化的代码修改，以及编译和使用本地的engine，下一篇我会详细讲解在混合开发时使用本地engine，以及如何修改`bulid aar`时的脚本，打包成**aar**供业务方使用，也是伸手党们的福利，欢迎大家关注和点赞。