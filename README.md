# JCore-React-Native

极光 `JCore` SDK 的 `React Native` 封装，支持 `Android` 和 `iOS`，Fork 自 [jcore-react-native](https://github.com/jpush/jcore-react-native)。

## 安装

**NPM:**

```bash 
npm i jcore-rn
```

**YARN**

```bash 
yarn add jcore-rn
```

## SDK 版本

使用 `Cocoapods` 导入 [JCore](https://cocoapods.org/pods/JCore) SDK，当前版本为 `4.4.2-noidfa`。

想使用 `idfa` 版本，可以修改自己项目下的 `node_modules/jcore-rn/ios/RCTJCore.podspec`，去掉 `-noidfa`：

```ruby
# 去掉 `-noidfa`
# s.dependency 'JCore', "4.4.2-noidfa"
s.dependency 'JCore', "4.4.2"
```
生成修复补丁：

```bash
npx patch-package jcore-rn
```

接着，在你项目的 `package.json` 中添加 `postinstall` 脚本：

```json
"scripts": {
  "postinstall": "patch-package"
}
```

最后，记得安装 `patch-package`：

**NPM:**

```bash
npm i patch-package -D
```

**YARN:**

```bash
yarn add patch-package -D
```

这样子，以后每次安装依赖时，都会自动打补丁。

