# 更新SDK

根据输入的需要更新的SDK版本号更新插件。

## 更新步骤

### 1. 更新iOS JCore SDK

**方法一：手动替换（推荐）**
1. 找到需要升级的 iOS JCore SDK，替换 `ios/RCTJCoreModule/jcore-ios-x.x.x.xcframework` 为需要更新的版本
2. 将 `ios/RCTJCoreModule.xcodeproj/project.pbxproj` 中关于 `jcore-ios-x.x.x.xcframework` 相关的引用，替换为需要更新的版本

**方法二：使用自动下载脚本（如果脚本已适配 JCore）**
```bash
# 在项目根目录执行
./.cursor/scripts/download_ios_sdk.sh <版本标签>

# 示例：下载 v5.2.1 版本
./.cursor/scripts/download_ios_sdk.sh v5.2.1
```

**注意**：
- 如果使用脚本，脚本会自动更新 project.pbxproj 文件
- 如果自动更新失败，请手动更新
- 确保 SDK 路径和版本号在 project.pbxproj 中正确更新

### 2. 更新Android JCore SDK

根据 `cursor.md` 文档，更新 Android JCore SDK 的步骤如下：

**方法一：手动替换（推荐）**
1. 找到需要升级的 Android JCore SDK，替换 `android/libs/jcore-android-x.x.x.jar` 或 `android/libs/jcore-android-x.x.x.aar` 为需要更新的版本
2. **注意**：新版本可能使用 AAR 格式，旧版本使用 JAR 格式，脚本和 build.gradle 已兼容两种格式

**方法二：使用自动下载脚本（如果脚本已适配 JCore）**
```bash
# 在项目根目录执行
./.cursor/scripts/download_android_sdk.sh <版本号>

# 示例：下载 5.2.0 版本
./.cursor/scripts/download_android_sdk.sh 5.2.0
```

**注意**：
- 如果使用脚本，脚本会尝试自动下载，如果失败，会引导您从[极光官方资源下载页面](https://docs.jiguang.cn/jcore/resources)手动下载
- 下载的文件是 ZIP 压缩包，SDK jar 或 aar 文件在压缩包的 `libs` 文件夹下
- 手动下载时，脚本会提示您输入 ZIP 文件路径（支持拖拽文件到终端）
- 脚本会自动解压 ZIP 文件，并从 `libs` 文件夹中提取 jar 或 aar 文件
- 脚本会自动检测文件类型（JAR 或 AAR），并复制到正确位置
- `build.gradle` 已配置支持 `libs` 目录下的 jar 和 aar 文件，无需手动修改

<!--
### 3. 查找SDK新增API

**⚠️ 重要：必须仔细逐项检查更新日志，不要因为看到"更新各厂商SDK"等主要更新内容就忽略新增API的检查！**

#### Android SDK
- 访问 [Android SDK Changelog](https://docs.jiguang.cn/jcore/jcore_changelog/updates_Android) 查找新版本的新增对外API
- **检查方法**：
  1. 找到目标版本（如 v5.2.0）的更新内容部分
  2. **逐项阅读**更新内容列表中的每一项，不要跳过任何条目
  3. 特别关注包含以下关键词的条目：
     - "新增"、"新增接口"、"新增API"、"新增方法"
     - "public static"、"public void" 等Java方法签名
     - "支持"、"功能"（可能包含新API）
  4. 对于每个疑似新增API的条目，记录：
     - API方法名（如 `setAuth`）
     - 完整方法签名（如 `public static void setAuth(boolean auth)`）
     - 功能描述
- 在 [Android SDK API 文档](https://docs.jiguang.cn/jcore/client/Android/android_api) 中查找并确认新增API的详细用法、参数说明和示例代码

#### iOS SDK
- 访问 [iOS SDK Changelog](https://docs.jiguang.cn/jcore/jcore_changelog/updates_iOS) 查找新版本的新增对外API
- **检查方法**：
  1. 找到目标版本（如 v5.2.1）的更新内容部分
  2. **逐项阅读**更新内容列表中的每一项，不要跳过任何条目
  3. 特别关注包含以下关键词的条目：
     - "新增"、"新增接口"、"新增API"、"新增方法"
     - Objective-C方法签名（如 `+ (void)setAuth:`）
     - "支持"、"功能"（可能包含新API）
  4. 对于每个疑似新增API的条目，记录：
     - API方法名
     - 完整方法签名
     - 功能描述
- 在 [iOS SDK API 文档](https://docs.jiguang.cn/jcore/client/iOS/ios_api) 中查找并确认新增API的详细用法、参数说明和示例代码

**检查清单**（在完成检查后确认）：
- [ ] 已找到目标版本的更新日志
- [ ] 已逐项阅读所有更新内容条目（包括次要更新）
- [ ] 已识别所有包含"新增"、"API"、"接口"、"方法"等关键词的条目
- [ ] 已记录所有新增API的方法名和签名
- [ ] 已在API文档中查找并确认了每个新增API的详细用法
- [ ] 已区分哪些是新增的对外API（需要封装），哪些是内部更新（不需要封装）

**常见误区**：
- ❌ 错误：看到"更新各厂商SDK"就认为只是版本更新，没有新增API
- ✅ 正确：即使主要更新是版本升级，也要仔细检查是否有新增API
- ❌ 错误：只关注主要更新内容，忽略列表中的其他条目
- ✅ 正确：必须逐项检查更新内容列表中的每一项
- ❌ 错误：依赖搜索结果判断是否有新增API
- ✅ 正确：直接查看官方更新日志，逐项检查
- ❌ 错误：文本识别有问题时（如缺少字母），直接忽略
- ✅ 正确：如果文本识别有问题，需要手动访问官方文档确认

### 4. 封装新增API（如有）

**⚠️ 重要：如果没有新增API，必须明确说明"经检查，该版本无新增对外API"，而不是简单说"没有新增API"。**

如果SDK有新增API，需要在插件中进行封装：
- 在 `index.js` 中添加JavaScript方法
- 在 `index.d.ts` 中添加TypeScript类型定义
- 在 `android/src/main/java/cn/jiguang/plugins/core/JCoreModule.java` 中实现Android端逻辑
- 在 `ios/RCTJCoreModule/RCTJCoreModule.m` 中实现iOS端逻辑

**封装原则**：
- 如果Android和iOS新增的API是同一个功能，封装成一个插件方法
- 如果不是同一个功能，分开封装
- **不要使用反射的方式调用SDK API，直接调用即可**
- 如果没有新增API，**必须明确说明已检查并确认无新增API**，然后跳过此步骤

**封装步骤**：
1. 确定API的完整签名和参数类型
2. 确定API的调用时机（是否需要在init之前调用）
3. 在对应平台实现方法（Android在JCoreModule.java，iOS在RCTJCoreModule.m）
4. 在 `index.js` 中添加JavaScript方法，保持与现有API风格一致
5. 在 `index.d.ts` 中添加TypeScript类型定义
6. 添加必要的错误处理和日志

**注意**：React Native插件新增方法还需要在 `index.js` 和 `index.d.ts` 文件中声明。

### 5. 更新示例代码

在插件示例demo中添加新增API的示例调用代码（如有新增API）。注意RN插件新增方法还需要在 `index.js` 和 `index.d.ts` 文件中声明。
-->

### 6. 更新插件版本号

在 `package.json` 中更新插件版本号：

**版本号更新规则**：
- 在现有版本号基础上 + 0.0.1

**示例**：
- 假设当前版本为 `2.3.3`
- 更新后版本为 `2.3.4`

### 7. 更新示例项目依赖版本（如有示例项目）

如果项目包含示例项目，在 `example/package.json` 中更新示例项目的插件依赖版本，改为最新的插件版本号：

```json
"dependencies": {
    ...
    "jcore-react-native": "^x.x.x",
    ...
}
```

### 8. 更新CHANGELOG.md（如有）

如果项目包含 `CHANGELOG.md` 文件，在其中记录本次更新的变更内容，包括：
- SDK版本更新
- **新增的API方法（如有，必须列出具体方法名）**
- 其他相关变更

**如果无新增API，也要明确说明**：
```
## [2.3.4] - YYYY-MM-DD

### Added
- 更新iOS JCore SDK到x.x.x版本
- 更新Android JCore SDK到x.x.x版本
- 经检查，该版本无新增对外API

### Changed
- 插件版本从2.3.3升级到2.3.4
```

## 注意事项

- **必须逐项检查更新日志，不要遗漏任何新增API**
- 确保Android和iOS的SDK版本对应关系正确
- 新增API的封装需要保持与现有API风格一致
- **React Native插件新增方法需要在 `index.js` 和 `index.d.ts` 两个文件中都声明**
- 更新后建议进行测试验证
- **如果更新日志中的文本识别有问题（如缺少字母），需要手动访问官方文档确认**
- 根据 `cursor.md` 文档，更新步骤应遵循：
  1. 替换 iOS SDK：`ios/RCTJCoreModule/jcore-ios-x.x.x.xcframework`
  2. 更新 `ios/RCTJCoreModule.xcodeproj/project.pbxproj` 中的 SDK 引用
  3. 替换 Android SDK：`android/libs/jcore-android-x.x.x.jar`
  4. 封装新增方法（如有）并在 `index.js` 和 `index.d.ts` 中声明
  5. 更新 `package.json` 版本号（+0.0.1）