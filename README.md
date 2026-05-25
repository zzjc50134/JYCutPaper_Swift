# 京韵剪影

> 非遗剪纸 AI 创作平台

[![iOS](https://img.shields.io/badge/iOS-15.0%2B-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange)](https://swift.org/)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20iPadOS-green)]()

一款融合中国传统剪纸艺术与 AI 技术的水果 APP，帮助用户轻松创作独特的剪纸艺术作品。

## 功能特色

### AI 创作中心
- **文生图**：输入文字描述，AI 自动生成精美剪纸图样
- **AI 优化**：智能扩展描述词，生成更专业的创作提示
- **多风格支持**：传统剪纸、现代剪纸、简约剪纸
- **多尺寸输出**：支持 1:1、16:9、9:16、4:3、3:4 等多种比例

### 学习与闯关
- 剪纸教程学习路径
- 循序渐进的闯关模式
- 学习历史记录

### 个人中心
- 创作记录：保存和查看历史作品
- 我的收藏：收藏喜欢的剪纸作品
- 成就徽章：解锁各种成就称号
- 设置管理：自定义默认风格、尺寸等偏好

## 界面预览

| 首页 | 创作中心 | 个人中心 |
|:---:|:---:|:---:|
| ![Home] | ![Create] | ![Profile] |

## 技术栈

- **框架**：SwiftUI
- **最低版本**：iOS 15.0
- **AI 服务**：MiniMax API
- **后端**：Vapor (Swift)
- **本地存储**：UserDefaults

## 项目结构

```
Sources/
├── App/            # 应用入口、AppState
├── Components/     # 复用组件
├── Models/        # 数据模型
├── Services/      # API 服务层
├── Theme/         # 主题颜色、样式
└── Views/         # 页面视图
    ├── LoginView.swift       # 登录
    ├── RegisterView.swift    # 注册
    ├── HomeView.swift        # 首页
    ├── CreateView.swift      # AI 创作中心
    ├── ProfileView.swift     # 个人中心
    └── ...
```

## 配置说明

### 1. 安装依赖

```bash
# 使用 Xcode 打开
open 京韵剪影.xcodeproj

# 或使用 xcodegen
xcodegen generate
```

### 2. 配置 API Key

1. 打开 APP 设置页面
2. 输入您的 MiniMax API Key
3. 点击保存

> 获取 API Key：[MiniMax 开放平台](https://platform.minimaxi.com/)

### 3. 运行项目

1. 在 Xcode 中选择目标设备/模拟器
2. 按 `Cmd + R` 构建运行

## 后端服务

京韵剪影需要配合后端服务使用，请参考 [JYCutPaper_Backend](https://github.com/your-repo/JYCutPaper_Backend)

默认后端地址：`http://127.0.0.1:8080/api`

## 开发说明

### 主要依赖

- **XcodeGen**：项目生成工具
- **Vapor**：后端框架（后端项目）

### 快捷命令

```bash
# 生成 Xcode 项目
xcodegen generate

# 安装 CocoaPods（如有）
pod install
```

## 注意事项

- 请确保后端服务已启动
- AI 生成需要有效的 MiniMax API Key
- 部分功能需要登录后才能使用

## License

MIT License

## 联系方式

- 项目问题：提交 Issue
- 商务合作：contact@jycutaichina.com
