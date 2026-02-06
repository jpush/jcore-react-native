# 更新SDK

根据输入的需要更新的SDK版本号更新插件。

## 更新步骤

### 1. 更新iOS JCore SDK

iOS 端通过 CocoaPods 依赖 JCore SDK。在 `JCoreRN.podspec` 中修改版本号即可：

```ruby
Pod::Spec.new do |s|
  # ...
  s.dependency 'JCore', '5.x.x'  # 将 5.x.x 改为目标版本，如 5.3.0
  # ...
end
```

**说明**：将 `JCore` 的版本号改为需要更新的版本（如 5.3.0）

### 2. 更新Android JCore SDK

Android 端通过 Maven 依赖 JCore SDK。在 `android/build.gradle` 中修改版本号即可：

```gradle
dependencies {
  implementation 'cn.jiguang.sdk:jcore:5.x.x'  // 将 5.x.x 改为目标版本，如 5.3.0
  // ...
}
```

**说明**：将 `cn.jiguang.sdk:jcore` 的版本号改为需要更新的版本（如 5.3.0）

### 3. 更新插件版本号

在 `package.json` 中更新插件版本号：

**版本号更新规则**：
- 在现有版本号基础上 + 0.0.1

**示例**：
- 假设当前版本为 `2.3.3`
- 更新后版本为 `2.3.4`

### 4. 更新示例项目依赖版本（如有示例项目）

如果项目包含示例项目，在 `example/package.json` 中更新示例项目的插件依赖版本，改为最新的插件版本号：

```json
"dependencies": {
    ...
    "jcore-react-native": "^x.x.x",
    ...
}
```

### 5. 更新CHANGELOG.md（如有）

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

- 确保 Android 和 iOS 的 SDK 版本对应关系正确
- 更新后建议进行测试验证
- 更新步骤应遵循：
  1. 更新 iOS SDK：在 `JCoreRN.podspec` 中修改 `s.dependency 'JCore', '5.x.x'` 的版本号
  2. 更新 Android SDK：在 `android/build.gradle` 中修改 `implementation 'cn.jiguang.sdk:jcore:5.x.x'` 的版本号
  3. 更新 `package.json` 版本号（+0.0.1）