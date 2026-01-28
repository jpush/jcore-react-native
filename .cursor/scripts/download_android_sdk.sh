#!/bin/bash

# 从极光官方下载指定版本的 jcore-android SDK
# 使用方法: ./.cursor/scripts/download_android_sdk.sh <版本号>
# 示例: ./.cursor/scripts/download_android_sdk.sh 5.2.0

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查参数
if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请提供版本号${NC}"
    echo "使用方法: $0 <版本号>"
    echo "示例: $0 5.2.0"
    exit 1
fi

VERSION_NUMBER=$1
# 处理版本号格式（移除 'v' 前缀如果存在）
VERSION_NUMBER=${VERSION_NUMBER#v}

TEMP_DIR=$(mktemp -d)
TARGET_DIR="android/libs"
JAR_NAME="jcore-android-${VERSION_NUMBER}.jar"
AAR_NAME="jcore-android-${VERSION_NUMBER}.aar"

# 清理函数
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        echo -e "${YELLOW}清理临时目录...${NC}"
        rm -rf "$TEMP_DIR"
    fi
}

# 注册清理函数
trap cleanup EXIT


echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}JCore Android SDK 下载工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo "版本号: $VERSION_NUMBER"
echo "目标目录: $TARGET_DIR"
echo ""

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}创建目标目录: $TARGET_DIR${NC}"
    mkdir -p "$TARGET_DIR"
fi

# 尝试自动下载（如果极光提供直接下载链接）
echo -e "${GREEN}[1/4] 正在尝试自动下载 SDK...${NC}"

# 检查 curl 或 wget 是否安装
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl"
    DOWNLOAD_FLAGS="-L -o"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget"
    DOWNLOAD_FLAGS="-O"
else
    DOWNLOAD_CMD=""
fi

ZIP_DOWNLOADED=false
if [ -n "$DOWNLOAD_CMD" ]; then
    echo -e "${YELLOW}正在从极光官方下载 API 获取下载链接...${NC}"
    
    ZIP_FILE="$TEMP_DIR/jcore-android-${VERSION_NUMBER}.zip"
    
    # 直接访问极光下载 API，跟随重定向获取实际 ZIP 文件
    # 极光下载 API: https://www.jiguang.cn/downloads/sdk/android
    # 会重定向到: https://api.srv.jpush.cn/v1/website/downloads/sdk/android
    # 最终重定向到: https://sdkfiledl.jiguang.cn/sdk-build/日期/构建号/jcore-android-版本号-release.zip
    # 注意：JCore SDK 可能需要使用不同的下载 API 或手动下载
    DOWNLOAD_API="https://www.jiguang.cn/downloads/sdk/android"
    
    if [ "$DOWNLOAD_CMD" = "curl" ]; then
        # 使用 curl 直接跟随重定向下载文件
        echo -e "${YELLOW}正在从极光下载 API 下载 SDK（自动跟随重定向）...${NC}"
        
        HTTP_CODE=$(curl -s -L -o "$ZIP_FILE" -w "%{http_code}" "$DOWNLOAD_API" 2>/dev/null || echo "000")
        
        if [ "$HTTP_CODE" = "200" ] && [ -f "$ZIP_FILE" ] && [ -s "$ZIP_FILE" ]; then
            # 检查文件是否为有效的 ZIP 文件
            if unzip -tq "$ZIP_FILE" >/dev/null 2>&1; then
                # 验证 ZIP 文件中的 jar 或 aar 文件名是否包含正确的版本号
                JAR_IN_ZIP=$(unzip -l "$ZIP_FILE" 2>/dev/null | grep -oE "jcore-android-[0-9.]+\.(jar|aar)" | head -1)
                if [ -n "$JAR_IN_ZIP" ]; then
                    # 提取 jar 文件中的版本号
                    JAR_VERSION=$(echo "$JAR_IN_ZIP" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1)
                    if [ "$JAR_VERSION" = "$VERSION_NUMBER" ]; then
                        echo -e "${GREEN}✓ 自动下载成功 (版本: $JAR_VERSION)${NC}"
                        ZIP_DOWNLOADED=true
                        ZIP_PATH="$ZIP_FILE"
                    else
                        echo -e "${YELLOW}下载的文件版本不匹配 (期望: $VERSION_NUMBER, 实际: $JAR_VERSION)${NC}"
                        rm -f "$ZIP_FILE"
                    fi
                else
                    echo -e "${YELLOW}无法验证 ZIP 文件中的版本号${NC}"
                    rm -f "$ZIP_FILE"
                fi
            else
                echo -e "${YELLOW}下载的文件不是有效的ZIP文件${NC}"
                rm -f "$ZIP_FILE"
            fi
        else
            echo -e "${YELLOW}从 API 下载失败 (HTTP $HTTP_CODE)${NC}"
        fi
    else
        # wget 版本（类似逻辑）
        echo -e "${YELLOW}正在从极光下载 API 下载 SDK（自动跟随重定向）...${NC}"
        
        # wget 可以自动跟随重定向
        if wget -q -O "$ZIP_FILE" "$DOWNLOAD_API" 2>/dev/null && [ -f "$ZIP_FILE" ] && [ -s "$ZIP_FILE" ]; then
            if unzip -tq "$ZIP_FILE" >/dev/null 2>&1; then
                JAR_IN_ZIP=$(unzip -l "$ZIP_FILE" 2>/dev/null | grep -oE "jcore-android-[0-9.]+\.(jar|aar)" | head -1)
                if [ -n "$JAR_IN_ZIP" ]; then
                    JAR_VERSION=$(echo "$JAR_IN_ZIP" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1)
                    if [ "$JAR_VERSION" = "$VERSION_NUMBER" ]; then
                        echo -e "${GREEN}✓ 自动下载成功 (版本: $JAR_VERSION)${NC}"
                        ZIP_DOWNLOADED=true
                        ZIP_PATH="$ZIP_FILE"
                    else
                        echo -e "${YELLOW}下载的文件版本不匹配 (期望: $VERSION_NUMBER, 实际: $JAR_VERSION)${NC}"
                        rm -f "$ZIP_FILE"
                    fi
                else
                    echo -e "${YELLOW}无法验证 ZIP 文件中的版本号${NC}"
                    rm -f "$ZIP_FILE"
                fi
            else
                echo -e "${YELLOW}下载的文件不是有效的ZIP文件${NC}"
                rm -f "$ZIP_FILE"
            fi
        else
            echo -e "${YELLOW}从 API 下载失败${NC}"
        fi
    fi
fi

# 如果自动下载失败，引导用户手动下载
if [ "$ZIP_DOWNLOADED" = false ]; then
    echo -e "${YELLOW}⚠ 无法自动下载，需要从极光官方下载页面手动下载${NC}"
    echo ""
    echo -e "${YELLOW}请按以下步骤操作：${NC}"
    echo "1. 访问极光官方下载页面: https://docs.jiguang.cn/jcore/resources"
    echo "2. 找到 Android SDK 下载按钮，下载对应版本 (v${VERSION_NUMBER})"
    echo "3. 下载的文件是 ZIP 压缩包，SDK jar 或 aar 文件在压缩包的 libs 文件夹下"
    echo ""
    echo -e "${YELLOW}下载完成后，请提供 ZIP 文件路径（支持拖拽文件到终端）：${NC}"
    read -p "请输入 ZIP 文件路径（或按 Enter 退出）: " ZIP_PATH

    if [ -z "$ZIP_PATH" ]; then
        echo -e "${RED}已取消操作${NC}"
        exit 1
    fi

    # 处理用户输入的路径（支持拖拽文件）
    ZIP_PATH=$(echo "$ZIP_PATH" | sed "s/^[[:space:]]*//;s/[[:space:]]*$//" | sed "s/^['\"]//;s/['\"]$//")

    if [ ! -f "$ZIP_PATH" ]; then
        echo -e "${RED}错误: 文件不存在: $ZIP_PATH${NC}"
        exit 1
    fi
fi

# 检查文件是否为 ZIP 文件
if [[ ! "$ZIP_PATH" =~ \.(zip|ZIP)$ ]]; then
    echo -e "${YELLOW}警告: 文件扩展名不是 .zip，但将尝试解压${NC}"
fi

# 检查是否有 unzip 命令
if ! command -v unzip &> /dev/null; then
    echo -e "${RED}错误: 未找到 unzip 命令，请先安装 unzip${NC}"
    echo "macOS: brew install unzip"
    echo "Linux: sudo apt-get install unzip 或 sudo yum install unzip"
    exit 1
fi

# 解压 ZIP 文件
if [ "$ZIP_DOWNLOADED" = true ]; then
    echo -e "${GREEN}[2/4] 正在解压 ZIP 文件...${NC}"
else
    echo -e "${GREEN}[2/4] 正在解压 ZIP 文件...${NC}"
fi
if ! unzip -q "$ZIP_PATH" -d "$TEMP_DIR" 2>/dev/null; then
    echo -e "${RED}错误: ZIP 文件解压失败${NC}"
    exit 1
fi

# 在解压后的 libs 文件夹中查找 jar 或 aar 文件
echo -e "${GREEN}[3/4] 正在查找 SDK 文件 (jar 或 aar)...${NC}"
SDK_FILE=$(find "$TEMP_DIR" -path "*/libs/jcore-android-*.jar" -o -path "*/libs/jcore-android-*.aar" -o -path "*/libs/JCore_Android_*.jar" -o -path "*/libs/JCore_Android_*.aar" 2>/dev/null | head -1)

if [ -z "$SDK_FILE" ] || [ ! -f "$SDK_FILE" ]; then
    # 如果没找到，尝试在整个解压目录中查找
    SDK_FILE=$(find "$TEMP_DIR" -name "jcore-android-*.jar" -o -name "jcore-android-*.aar" -o -name "JCore_Android_*.jar" -o -name "JCore_Android_*.aar" 2>/dev/null | head -1)
    
    if [ -z "$SDK_FILE" ] || [ ! -f "$SDK_FILE" ]; then
        echo -e "${RED}错误: 在 ZIP 文件中未找到 jar 或 aar 文件${NC}"
        echo -e "${YELLOW}提示: 请确认 ZIP 文件是否正确，SDK 文件应该在 libs 文件夹下${NC}"
        exit 1
    fi
fi

# 检测文件类型
SDK_EXT="${SDK_FILE##*.}"
SDK_BASENAME=$(basename "$SDK_FILE")
SDK_SIZE=$(du -sh "$SDK_FILE" | cut -f1)

if [ "$SDK_EXT" = "aar" ]; then
    echo -e "${GREEN}✓ 找到 SDK aar 文件: $SDK_BASENAME (大小: $SDK_SIZE)${NC}"
    TARGET_NAME="$AAR_NAME"
    OLD_PATTERN="jcore-android-*.aar"
    FILE_TYPE="aar"
else
    echo -e "${GREEN}✓ 找到 SDK jar 文件: $SDK_BASENAME (大小: $SDK_SIZE)${NC}"
    TARGET_NAME="$JAR_NAME"
    OLD_PATTERN="jcore-android-*.jar"
    FILE_TYPE="jar"
fi

# 删除旧版本（如果存在）
# 同时删除同类型的旧版本和不同类型的旧版本（例如从 JAR 升级到 AAR）
OLD_SDK_SAME_TYPE=$(find "$TARGET_DIR" -name "$OLD_PATTERN" 2>/dev/null | head -1)
if [ "$FILE_TYPE" = "aar" ]; then
    OLD_PATTERN_OTHER="jcore-android-*.jar"
else
    OLD_PATTERN_OTHER="jcore-android-*.aar"
fi
OLD_SDK_OTHER_TYPE=$(find "$TARGET_DIR" -name "$OLD_PATTERN_OTHER" 2>/dev/null | head -1)

if [ -n "$OLD_SDK_SAME_TYPE" ] || [ -n "$OLD_SDK_OTHER_TYPE" ]; then
    if [ -n "$OLD_SDK_SAME_TYPE" ]; then
        OLD_NAME=$(basename "$OLD_SDK_SAME_TYPE")
        if [ "$OLD_NAME" != "$TARGET_NAME" ]; then
            echo -e "${YELLOW}[4/4] 删除旧版本 ($FILE_TYPE): $OLD_NAME${NC}"
            rm -f "$OLD_SDK_SAME_TYPE"
        else
            echo -e "${YELLOW}[4/4] 检测到相同版本，将覆盖...${NC}"
            rm -f "$OLD_SDK_SAME_TYPE"
        fi
    fi
    if [ -n "$OLD_SDK_OTHER_TYPE" ]; then
        OLD_NAME_OTHER=$(basename "$OLD_SDK_OTHER_TYPE")
        echo -e "${YELLOW}[4/4] 删除旧版本 (其他格式): $OLD_NAME_OTHER${NC}"
        rm -f "$OLD_SDK_OTHER_TYPE"
    fi
else
    echo -e "${GREEN}[4/4] 未找到旧版本${NC}"
fi

# 复制新 SDK 到目标目录
echo -e "${GREEN}[4/4] 正在复制 SDK 到目标目录...${NC}"
cp "$SDK_FILE" "$TARGET_DIR/$TARGET_NAME"

# 验证复制是否成功
if [ ! -f "$TARGET_DIR/$TARGET_NAME" ]; then
    echo -e "${RED}错误: SDK 复制失败${NC}"
    exit 1
fi

# 完成
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ SDK 下载和配置完成!${NC}"
echo -e "${BLUE}========================================${NC}"
echo "SDK 位置: $TARGET_DIR/$TARGET_NAME"
echo "SDK 类型: $FILE_TYPE"
echo "SDK 大小: $SDK_SIZE"
echo ""
if [ "$FILE_TYPE" = "aar" ]; then
    echo -e "${YELLOW}提示: 检测到 AAR 格式，请确保 build.gradle 已配置支持 AAR 文件${NC}"
else
    echo -e "${YELLOW}提示: JCore Android SDK (JAR) 已更新${NC}"
fi
echo ""
