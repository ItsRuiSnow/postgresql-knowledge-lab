# PostgreSQL Knowledge Lab

一个面向 PostgreSQL 零基础学习者的实践项目。第一阶段只聚焦关系模型、主键/外键、多对多关系、JOIN 和约束验证；后续计划扩展为 Python 后端与 AI 知识库。

**当前状态：第 01 课的学习脚本。** 目前还没有 Web 前端、FastAPI API 或 AI/RAG 功能。

## 目录

```text
.
├── .env.example                # 本地环境变量样例（不包含真实密码）
├── .gitignore
├── compose.yaml                # PostgreSQL 18 本地开发环境
├── README.md
├── docs/
│   └── lesson-01.md            # 概念、目标和思考题
└── sql/
    ├── 01_schema.sql           # 创建 documents、tags、document_tags
    ├── 02_seed.sql             # 3 篇文档、3 个标签、4 条关联
    ├── 03_queries.sql          # SELECT、JOIN、聚合
    ├── 04_verify.sql           # 自动检查数据是否符合预期
    ├── 05_cascade_experiment.sql # 删除/级联/回滚实验
    ├── 06_negative_foreign_key.sql # 预期失败：无效外键
    └── 07_negative_duplicate.sql   # 预期失败：重复关联
```

## 环境要求

- Windows PowerShell（示例命令），或能运行 Docker Compose 的终端
- Docker Desktop，Docker Compose v2

## 第一次启动

在项目根目录执行：

```powershell
Copy-Item .env.example .env
```

然后打开 `.env`，将 `POSTGRES_PASSWORD` 改成仅用于本地的自定义密码。**不要将 `.env` 提交到 Git。**

```powershell
docker compose up -d
docker compose ps
```

等容器通过健康检查后，初始化第一课数据库（只需在全新数据卷执行一次）：

```powershell
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/01_schema.sql
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/02_seed.sql
```

## 查询与验证

```powershell
# 运行三种查询：查看文档、标签 JOIN、按标签计数
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/03_queries.sql

# 运行自动断言：成功时看到 Lesson 01 checks passed
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/04_verify.sql

# 在事务中删除文档，观察级联删除，并 ROLLBACK 恢复
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/05_cascade_experiment.sql
```

以下两条测试**预期报错**，应分别运行；数据库拒绝错误写入，才是测试成功：

```powershell
# 外键违反约束：文档 999 不存在
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/06_negative_foreign_key.sql

# 联合主键违反约束：文档 1 与标签 10 已有关联
docker compose exec db psql -U learner -d knowledge_lab -v ON_ERROR_STOP=1 -f /workspace/sql/07_negative_duplicate.sql
```

再执行 `04_verify.sql`，确认两次错误插入均未改变数据。

> 注意：`01_schema.sql` 与 `02_seed.sql` 是第一课的初始化脚本，不是可反复执行的迁移脚本。不要对已有真实业务数据库执行这些练习脚本。

## DBeaver 连接参数（可选）

| 字段 | 值 |
| --- | --- |
| Host | `127.0.0.1` |
| Port | `55432` |
| Database | `knowledge_lab` |
| User | `learner` |
| Password | 你自己写入 `.env` 的密码 |

仅将 PostgreSQL 端口绑定在本机 `127.0.0.1`，不对外网开放。

## 停止环境

```powershell
docker compose down
```

上面的命令保留数据库卷。**`docker compose down -v` 将删除本项目数据库卷及其中数据，请不要随意执行。**

## 后续课程方向

- 第 02 课：关系建模、约束与规范化
- 第 03 课：索引与 `EXPLAIN ANALYZE`
- 第 04 课：事务、并发与 MVCC
- 第 05 课：FastAPI、SQLAlchemy、Alembic
- 第 06 课：JSONB、全文检索、pgvector 与 AI 知识库

详见 [第 01 课](docs/lesson-01.md)。

## 验证声明

此仓库包含可执行脚本及预期结果；是否成功仍需在你的 Docker/PostgreSQL 环境中实际运行。不要将尚未执行的脚本视为已经通过集成测试。
