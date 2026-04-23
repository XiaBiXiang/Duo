# Duo

一款为情侣打造的恋爱清单 App，记录属于你们的每一个冒险瞬间。

## 功能

- **情侣配对** — 创建专属空间，通过邀请码邀请另一半加入
- **恋爱清单** — 创建和管理你们的共同愿望清单，支持状态追踪（待开始 / 进行中 / 已完成）
- **回忆记录** — 为每个清单项添加珍贵的回忆和照片
- **深色模式** — 支持浅色 / 深色主题切换
- **实时同步** — 通过 Appwrite Cloud 实现多端数据同步

## 技术栈

| 层级 | 技术 |
|------|------|
| 框架 | Flutter 3.29 |
| 状态管理 | Riverpod |
| 路由 | GoRouter |
| 后端 | Appwrite Cloud |
| AI | Google Generative AI (Gemini) |
| 本地存储 | SharedPreferences |

## 项目结构

```
lib/
├── core/          # 主题、颜色、排版、常量
├── models/        # 数据模型 (Task, Moment, Couple)
├── pages/         # 页面 (首页、登录、配对、设置、任务详情)
├── providers/     # Riverpod 状态管理
├── router/        # GoRouter 路由配置
├── services/      # 后端服务 (Auth, Database, Couple, AI)
└── widgets/       # 可复用组件
```

## 快速开始

### 环境要求

- Flutter 3.29+
- Dart 3.6+
- Android Studio / VS Code

### 配置

1. 在 [Appwrite Cloud](https://cloud.appwrite.io) 创建项目，获取 Project ID 和 Endpoint
2. 编辑 `lib/core/constants/app_constants.dart`，填入你的 Appwrite 配置：

```dart
static const String appwriteEndpoint = 'https://your-region.cloud.appwrite.io/v1';
static const String appwriteProjectId = 'your-project-id';
```

3. 运行 Appwrite 初始化脚本配置数据库集合：

```bash
dart run scripts/setup_appwrite.dart
```

### 运行

```bash
flutter pub get
flutter run
```

### 构建 Release

```bash
flutter build apk --release --split-per-abi
```
