# YCAssistivePlugin

## 介绍

**YCAssistivePlugin**是一款App辅助开发测试工具，可以有效帮助开发解决常见问题，辅助测试完成功能测试。

## 功能模块

### 一、常用工具

1. **【环境切换】** App内进行项目、测试、预发、线上环境的切换，方便调试、测试；
2. **【网络监测】** 拦截App内部的网络请求，可以查看具体的请求与响应信息，统计流量使用情况，使App自带类似“Charles”功能；
3. **【用户日志】** App的调试日志可视化，提升排查问题的效率；
4. **【崩溃记录】** 记录App crash发生时的堆栈信息，便于开发查看原因解决问题；
5. **【App信息】** 快速查看手机、App及相关权限信息，避免查看手机设置或源码，节省时间；
6. **【沙盒浏览】** App 内部文件浏览的功能，并且可通过AirDrop或其他分享方式将文件发送到PC端查看。

### 二、性能检测工具

1. **【帧率检测】** App页面帧率信息以波形图形式展示，让帧率监控趋势更加明显；
2. **【cpu检测】** App CPU使用率信息以波形图形式展示，让cpu使用率更加形象；
3. **【内存检测】** App内存使用量信息以波形图形式展示，让内存监控的趋势更加鲜明；
4. **【泄漏检测】**  通过`MLeaksFinder`和`FBRetainCycleDetector`工具，检测出App中存在内存泄漏和循环引用的地方；
5. **【大图检测】** 通过网络检测以及`SDWebImage`加载图片方法hook，找出所有的大小超标的图片，避免下载大图造成的流量浪费和渲染大图带来的CPU消耗。

### 三、视图工具

1. **【截   图】**  快速截图，可在生成的截图中标记问题、编辑文字。
1. **【拾色器】** 方便设计师取色，便于查看每一个组件的颜色值是否设置正确；
2. **【视图层级】** 可以抓取任意一个UI控件，查看它们的详细信息，包括控件名称、控件位置、背景色、字体颜色、字体大小；
3. **【视图定位】** 快速定位当前视图的文件名；
4. **【视图边框】** 绘制每个UI组件的边框，便于了解组件结构和布局。

## 安装
通过cocoapods安装
```ruby
pod 'YCAssistivePlugin'
```

## 使用

```
#ifdef DEBUG
#import <YCAssistivePlugin/YCAssistivePlugin.h>
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#ifdef DEBUG
[[YCAssistiveManager sharedManager] installPlugins];
#endif

return YES;
}
```

## Author

shenweihang, shenweihang_2019@163.com

## License

YCAssistivePlugin is available under the MIT license. See the LICENSE file for more info.
