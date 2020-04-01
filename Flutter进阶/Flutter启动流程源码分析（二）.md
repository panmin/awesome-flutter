## Flutter启动流程源码分析

> 接上篇

### 二、FlutterActivity

> 在flutter中有两个FlutterActivity，一个是io.flutter.app.FlutterActivity，另一个是io.flutter.embedding.android.FlutterActivity，前者是老版本的Flutter运行相关类，在1.12版本已经不建议使用了。参考文档https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects，下面讲解的都是io.flutter.embedding.android.FlutterActivity。

#### 2.1、FlutterActivity

##### 2.1.1、onCreate

```java
@Override
protected void onCreate(@Nullable Bundle savedInstanceState) {
  // 查看metedata中是否有配置主题
  switchLaunchThemeForNormalTheme();
  super.onCreate(savedInstanceState);
  lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_CREATE);
	// 初始化delegate
  delegate = new FlutterActivityAndFragmentDelegate(this);
  // 初始化flutter engine相关
  delegate.onAttach(this);
  // 为插件提供恢复状态的onRestoreInstanceState
  delegate.onActivityCreated(savedInstanceState);

  // 当Intent配置的backgroundMode是透明时，就配置window是否透明
  configureWindowForTransparency();
  // 创建FlutterView
  setContentView(createFlutterView());
  configureStatusBarForFullscreenFlutterExperience();
}
```

##### 2.1.2、configureWindowForTransparency

```java
public FlutterView.RenderMode getRenderMode() {
  	// 获取intent里传递的backgroundMode，opaque表示不透明
    return getBackgroundMode() == BackgroundMode.opaque
        ? FlutterView.RenderMode.surface
        : FlutterView.RenderMode.texture;
}
private void configureWindowForTransparency() {
    BackgroundMode backgroundMode = getBackgroundMode();
    if (backgroundMode == BackgroundMode.transparent) {
      getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
      getWindow().setFlags(
        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
      );
    }
  }
```

##### 2.1.3、createFlutterView

```java
private View createFlutterView() {
	// 通过代理创建flutterView
	return delegate.onCreateView(
  	null /* inflater */,
    null /* container */,
    null /* savedInstanceState */);
}
```

#### 2.2、FlutterActivityAndFragmentDelegate

##### 2.2.1、onAttach

> 主要做以下几件事：
>
> 1、获取或者创建flutter engine
>
> 2、创建和配置PlatformPlugin
>
> 3、将flutterEngine附加到activity

```java
void onAttach(@NonNull Context context) {
    ensureAlive();

    // 当这个FlutterActivity是复用时，flutter engine复用
    if (flutterEngine == null) {
      setupFlutterEngine();
    }

    // 创建和配置platform plugin
    platformPlugin = host.providePlatformPlugin(host.getActivity(), flutterEngine);

    if (host.shouldAttachEngineToActivity()) {
      // 将flutter engine附加到activity
      Log.d(TAG, "Attaching FlutterEngine to the Activity that owns this Fragment.");
      flutterEngine.getActivityControlSurface().attachToActivity(
          host.getActivity(),
          host.getLifecycle()
      );
    }
		// flutter activity配置flutter engine提供入口
    host.configureFlutterEngine(flutterEngine);
  }
```

#### 2.2.2、onCreateView

```java
View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    Log.v(TAG, "Creating FlutterView.");
    ensureAlive();
  	// 创建flutterView
    flutterView = new FlutterView(host.getActivity(), host.getRenderMode(), host.getTransparencyMode());
    flutterView.addOnFirstFrameRenderedListener(flutterUiDisplayListener);
		// 创建一个在view直到flutter的第一帧显示出来
    flutterSplashView = new FlutterSplashView(host.getContext());
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      flutterSplashView.setId(View.generateViewId());
    } else {
      flutterSplashView.setId(486947586);
    }
  	// 当flutter view第一帧渲染后会移除splash view
    flutterSplashView.displayFlutterViewWithSplash(flutterView, host.provideSplashScreen());

    return flutterSplashView;
 }
```

### 三、FlutterEngine

##### 3.1、构造方法时调用

```java
public FlutterEngine(
      @NonNull Context context,
      @NonNull FlutterLoader flutterLoader,
      @NonNull FlutterJNI flutterJNI,
      @NonNull PlatformViewsController platformViewsController,
      @Nullable String[] dartVmArgs,// FlutterActivity重写getFlutterShellArgs方法可以添加参数
      boolean automaticallyRegisterPlugins) {
    this.flutterJNI = flutterJNI;
  	// 初始化配置、资源、加载libflutter.so；如果使用了FlutterApplication，也不会重复初始化操作
    flutterLoader.startInitialization(context.getApplicationContext());
  	// 确保初始化完成
    flutterLoader.ensureInitializationComplete(context, dartVmArgs);

    flutterJNI.addEngineLifecycleListener(engineLifecycleListener);
  	// 调用flutterJNI的attachToNative初始化setting配置
    attachToJni();

    this.dartExecutor = new DartExecutor(flutterJNI, context.getAssets());
    this.dartExecutor.onAttachedToJNI();

    // 。。。。。省略
  }
```

##### 3.2、attachToJni

```java
private void attachToJni() {
    Log.v(TAG, "Attaching to JNI.");
    // 通过FlutterJNI调用libflutter.so中的方法
    flutterJNI.attachToNative(false);
    if (!isAttachedToJni()) {
      throw new RuntimeException("FlutterEngine failed to attach to its native Object reference.");
    }
  }
```

### 四、FlutterJNI

> 通过这个类调用flutter engine中的 C/C++ 代码，对应platform_view_android_jni.cc代码

```java
// 将java层初始化的参数传递给C++层
public static native void nativeInit(
      @NonNull Context context,
      @NonNull String[] args,
      @Nullable String bundlePath,
      @NonNull String appStoragePath,
      @NonNull String engineCachesPath);
```

```java
// 初始化AndroidShellHolder
private native long nativeAttach(@NonNull FlutterJNI flutterJNI, boolean isBackgroundView);
```

*附上FlutterActivity启动时序图*

![image-20200401103956925](/Users/panmin/work/awesome-flutter/Flutter进阶/imgs/image-flutter-activity.png)