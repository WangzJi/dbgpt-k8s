# DB-GPT Kubernetes One-Click Deployment Guide

This repository provides a complete Kubernetes deployment solution for [DB-GPT](https://github.com/eosphoros-ai/DB-GPT), supporting one-click deployment, secure secret management, persistent storage, and production best practices.

---

## Features
- One-click deployment for database and web services
- Supports OpenAI Proxy API integration
- Secure API Key management via Kubernetes Secret
- Multiple persistent volumes for data and models
- Flexible config and model mounting
- Automated DevOps with Makefile

---

## Quick Start

### Prerequisites
- Kubernetes cluster (v1.19+ recommended)
- kubectl installed
- make installed

### One-Click Deployment Steps

1. **Create API Key Secret**
   ```bash
   make create-secret KEY=your_real_key
   ```
2. **Deploy all resources**
   ```bash
   make all
   ```
3. **Check resource status**
   ```bash
   make status
   ```
4. **View Pod logs**
   ```bash
   make logs POD=pod-name
   ```
5. **Port-forward for local debugging**
   ```bash
   make port-forward SERVICE=webserver LOCAL_PORT=5670 REMOTE_PORT=5670
   ```
6. **Delete all resources**
   ```bash
   make delete
   ```

---

## Makefile Main Commands

- `make all`: Create namespace and apply all resources
- `make create-secret KEY=xxx`: Create/update API Key Secret
- `make status`: View all resource status
- `make logs POD=xxx`: View logs for a specific Pod
- `make port-forward SERVICE=xxx LOCAL_PORT=local REMOTE_PORT=container`: Port-forward
- `make delete`: Delete all resources

---

## Directory Structure

- `database/`: Database YAMLs (MySQL, PVC, ConfigMap, etc.)
- `service/`: Web service YAMLs (Deployment, Service, PVC, ConfigMap, etc.)
- `Makefile`: One-click DevOps script

---

## Secret Management (Recommended for Production)

API keys and other sensitive info are managed via Kubernetes Secret and injected as environment variables. Config files can reference them as `${env:SILICONFLOW_API_KEY}`.

- Create Secret:
  ```bash
  make create-secret KEY=your_real_key
  ```
- Deployment example:
  ```yaml
  env:
    - name: SILICONFLOW_API_KEY
      valueFrom:
        secretKeyRef:
          name: siliconflow-api-key
          key: SILICONFLOW_API_KEY
  ```

---

## Persistent Volumes (PVC)

| PVC Name            | Purpose         | Default Size |
|---------------------|-----------------|-------------|
| dbgpt-myql-db       | MySQL database  | 10Gi        |
| webserver-claim1    | Web data        | 10Gi        |
| webserver-claim2    | Web models      | 10Gi        |
| dbgpt-data          | DB-GPT data     | 10Gi        |
| dbgpt-message       | DB-GPT messages | 10Gi        |

> Note: Tencent Cloud CBS requires at least 10Gi per volume.

---

## Main Environment Variables

| Name                | Description         | Default     |
|---------------------|--------------------|-------------|
| MYSQL_DATABASE      | Database name      | dbgpt       |
| MYSQL_HOST          | Database host      | db          |
| MYSQL_PASSWORD      | Database password  | aa123456    |
| MYSQL_PORT          | Database port      | 3306        |
| MYSQL_USER          | Database user      | root        |
| SILICONFLOW_API_KEY | API key (Secret)   | -           |

---

## Production Recommendations
- Set resource requests/limits to avoid contention
- Configure liveness/readiness probes for high availability
- Use cloud provider HA storage classes for PVC
- Use Ingress for public access (if needed)
- Always manage sensitive info with Secret

---

## Contribution & Support

Feel free to submit Issues and PRs to help improve this project.

---

## License

[Apache License 2.0](LICENSE)

---

## Related Links
- [DB-GPT Main Project](https://github.com/eosphoros-ai/DB-GPT)
![GitHub stars](https://img.shields.io/github/stars/eosphoros-ai/DB-GPT)
![License](https://img.shields.io/github/license/eosphoros-ai/DB-GPT)
