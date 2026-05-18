# Feng Admin Scaffold

Spring Boot 3 + Vue 3 + Java 17 + MySQL 的前后端分离快速开发脚手架。

## 技术栈

- 后端：Spring Boot 3.2.4、Spring Security、JWT、MyBatis-Plus、MySQL 8、Java 17
- 前端：Vue 3、Vite、Element Plus、Pinia、Vue Router

## 已内置模块

- 用户管理
- 角色管理
- 岗位管理
- 部门管理
- 菜单管理
- 菜单 + 按钮级权限控制

## 启动方式

### 1. 初始化数据库

执行 [sql/init.sql](E:\feng\feng-code\sql\init.sql)

默认数据库名：`feng-ai-admin`

### 2. 启动后端

进入 [backend](E:\feng\feng-code\backend) 目录后执行：

```bash
mvn spring-boot:run
```

默认端口：`10101`

数据库配置文件： [application.yml](E:\feng\feng-code\backend\src\main\resources\application.yml)

### 3. 启动前端

进入 [frontend](E:\feng\feng-code\frontend) 目录后执行：

```bash
npm install
npm run dev
```

默认端口：`5173`

## 默认账号

- 管理员：`admin / admin123`
- 演示账号：`operator / admin123`

> 初始化 SQL 中为了便于演示使用了 `{noop}` 明文前缀密码；后续正式项目建议改为 BCrypt 密码。
