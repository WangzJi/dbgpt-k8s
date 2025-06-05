> 🇺🇸 [English version please click here (README.md)](./README.md)

# DB-GPT Kubernetes 一键部署指南

本仓库提供 [DB-GPT](https://github.com/eosphoros-ai/DB-GPT) 在 Kubernetes 上的完整部署方案，支持一键部署、敏感信息安全管理、持久化存储等生产级最佳实践。

---

## 功能亮点
- 一键部署数据库与 Web 服务
- 支持 OpenAI Proxy API 集成
- API Key 等敏感信息通过 Secret 管理
- 多数据卷持久化存储
- 配置文件与模型灵活挂载
- Makefile 自动化运维脚本

---

## 快速开始

### 前置条件
- 已安装 Kubernetes 集群（建议 1.19+）
- 已安装 kubectl
- 已安装 make

### 一键部署流程

1. **创建 API Key Secret**
   ```bash
   make create-secret KEY=你的真实key
   ```
2. **部署所有资源**
   ```bash
   make all
   ```
3. **查看服务状态**
   ```bash
   make status
   ```
4. **查看 Pod 日志**
   ```bash
   make logs POD=pod-name
   ```
5. **端口转发（本地调试）**
   ```bash
   make port-forward SERVICE=webserver LOCAL_PORT=5670 REMOTE_PORT=5670
   ```
6. **删除所有资源**
   ```bash
   make delete
   ```

---

## Makefile 主要命令

- `make all`：自动创建命名空间并 apply 所有资源
- `make create-secret KEY=xxx`：创建/更新 API Key Secret
- `make status`：查看所有资源状态
- `make logs POD=xxx`：查看指定 Pod 日志
- `make port-forward SERVICE=xxx LOCAL_PORT=本地端口 REMOTE_PORT=容器端口`：端口转发
- `make delete`：删除所有资源

---

## 目录结构说明

- `database/`：数据库相关 YAML（MySQL、PVC、ConfigMap 等）
- `service/`：Web 服务相关 YAML（Deployment、Service、PVC、ConfigMap 等）
- `Makefile`：一键自动化运维脚本

---

## Secret 管理（推荐生产用法）

API Key 等敏感信息通过 Secret 管理，自动注入环境变量，配置文件可用 `${env:SILICONFLOW_API_KEY}` 方式读取。

- 创建 Secret：
  ```bash
  make create-secret KEY=你的真实key
  ```
- Deployment 自动挂载：
  ```yaml
  env:
    - name: SILICONFLOW_API_KEY
      valueFrom:
        secretKeyRef:
          name: siliconflow-api-key
          key: SILICONFLOW_API_KEY
  ```

---

## 持久化存储（PVC）

| PVC 名称             | 用途         | 默认大小 |
|----------------------|--------------|----------|
| dbgpt-myql-db        | MySQL 数据库 | 10Gi     |
| webserver-claim1     | Web 数据     | 10Gi     |
| webserver-claim2     | Web 模型     | 10Gi     |
| dbgpt-data           | DB-GPT 数据  | 10Gi     |
| dbgpt-message        | DB-GPT 消息  | 10Gi     |

> 注意：腾讯云 CBS 存储要求最小 10Gi。

---

## 主要环境变量

| 变量名              | 说明             | 默认值         |
|---------------------|------------------|----------------|
| MYSQL_DATABASE      | 数据库名称       | dbgpt          |
| MYSQL_HOST          | 数据库主机       | db             |
| MYSQL_PASSWORD      | 数据库密码       | aa123456       |
| MYSQL_PORT          | 数据库端口       | 3306           |
| MYSQL_USER          | 数据库用户       | root           |
| SILICONFLOW_API_KEY | API 密钥（Secret）| -             |

---

## 生产环境建议
- 配置资源 requests/limits，防止资源争抢
- 配置 liveness/readiness 探针，提升高可用
- 持久化存储建议使用云厂商高可用存储类
- 配置 Ingress 实现公网访问（如有需求）
- 敏感信息全部用 Secret 管理

---

## 贡献与支持

欢迎提交 Issue 和 PR 共同完善本项目。

---

## 许可证

[Apache License 2.0](LICENSE)

---

## 相关链接
- [DB-GPT 主项目](https://github.com/eosphoros-ai/DB-GPT)
