# DB-GPT K8s Deployment

这个仓库包含了 DB-GPT 的 Kubernetes 部署配置文件。DB-GPT 是一个开源的数据库智能助手，基于大语言模型实现。

## 功能特点

- 完整的 Kubernetes 部署配置
- 支持 MySQL 数据库
- 支持 SiliconFlow API 集成
- 数据持久化存储
- 配置文件管理
- 服务自动发现


## 快速开始

### 前置条件

- Kubernetes 集群 (v1.19+)
- kubectl 命令行工具
- 已安装 Helm (可选)

### 部署步骤

1. 配置环境变量
```bash
# 创建 secret 用于存储 API key
kubectl create secret generic siliconflow-secret \
  --from-literal=api-key=your-api-key
```

2. 部署数据库
```bash
kubectl apply -f k8s/database/
```

3. 部署 Web 服务
```bash
kubectl apply -f k8s/service/
```

4. 验证部署
```bash
kubectl get pods
kubectl get services
```

## 配置说明

### 数据库配置

- 数据库服务端口：3306
- 默认用户名：root
- 默认密码：aa123456
- 数据持久化：使用 PVC 存储

### Web 服务配置

- 服务端口：5670
- 配置文件：通过 ConfigMap 管理
- 数据持久化：使用多个 PVC 存储

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| MYSQL_DATABASE | 数据库名称 | dbgpt |
| MYSQL_HOST | 数据库主机 | db |
| MYSQL_PASSWORD | 数据库密码 | aa123456 |
| MYSQL_PORT | 数据库端口 | 3306 |
| MYSQL_USER | 数据库用户 | root |
| SILICONFLOW_API_KEY | SiliconFlow API 密钥 | - |

## 存储配置

| PVC 名称 | 用途 | 默认大小 |
|----------|------|----------|
| dbgpt-myql-db | 数据库存储 | 100Mi |
| webserver-claim1 | Web 服务数据 | 100Mi |
| webserver-claim2 | Web 服务模型 | 100Mi |
| dbgpt-data | DB-GPT 数据 | 100Mi |
| dbgpt-message | DB-GPT 消息 | 100Mi |

## 服务说明

### 数据库服务

数据库服务使用 MySQL 8.0，主要配置包括：
- 字符集：utf8mb4
- 排序规则：utf8mb4_unicode_ci
- 认证插件：mysql_native_password

### Web 服务

Web 服务提供以下功能：
- DB-GPT API 接口
- 数据库智能助手
- 模型管理
- 数据持久化

## 注意事项

1. 部署前请确保：
   - 已正确配置 SiliconFlow API Key
   - 存储类（StorageClass）已正确配置
   - 集群资源充足

2. 生产环境建议：
   - 调整 PVC 存储大小
   - 配置资源限制
   - 设置适当的副本数
   - 配置健康检查
   - 配置网络策略

## 贡献指南

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目。

## 许可证

[Apache License 2.0](LICENSE)

## 相关项目

- [DB-GPT](https://github.com/eosphoros-ai/DB-GPT) - DB-GPT 主项目
