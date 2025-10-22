
使用方法：修改需求里的内容，将需求和步骤内容作为指令让cursor进行执行。


需求：
1. 更新iOS JCore SDK 到 x.x.x 版本。JCore SDK 包的路径是：xxx
2. 更新Android JCore SDK 到 x.x.x 版本, JCore SDK 包的路径是：xxx
3. 将原生iOS、Android SDK 新增的方法，封装在插件中。
   原生SDK新增方法一：
   iOS ：
   
   ```
   ```
   
   Android:
   
   ```
   ```
   
    统一封装为 方法名为 "" 的对外方法。
    

请按照以下步骤完成：

1. 找到需要升级的iOS JPush SDK，替换ios/RCTJPushModule/jcore-ios-x.x.x.xcframework 为需要更新的版本。
2. 将ios/RCTJCoreModule.xcodeproj/project.pbxproj中关于jcore-ios-x.x.x.xcframework相关的引用，替换为需要更新的版本。
3. 找到需要升级的Android JPush SDK，替换android/libs/jcore-android-x.x.x.jar 为需要更新的版本。
4. 在插件中封装需求中需要封装的SDK方法，并在插件示例demo中提供示例调用代码，注意rn插件新增方法还需要再index.js和index.d.ts文件中声明哦。（如果没有需求中没有需要新增的方法，则跳过该步骤）
5. 在package.json中更新插件版本号，在现有版本号上 + 0.0.1



