# learn_sql_query_basic — 学透 SQL 查询基础

这是一个**只讲 SELECT** 的 SQL 查询基础课。23 个独立的小练习目录，每个一个真实行业（书店、咖啡馆、宠物医院、网约车、足球联赛、城市天气……），每个都自带一份预生成的 `db.sqlite` 数据库。学完之后你能从"我只会 `SELECT *`"长到"能读懂窗口函数"。不教写入、不教建表、不教性能调优——刻意保持范围窄，把"查询"这一件事讲透。

## 什么是"learn-this-project"——30 秒看懂方法论

这是一个 learn-this-project 风格的仓库：一份**刻意收窄范围**的小型代码库，把一项技能从头到尾讲透。重点不是把代码跑起来，而是通过 6 个交互式 skill **吃透**这项技能：能跑通、能讲清、能为每个设计决策做辩护，最后产出一个发到自己 GitHub 上的**作品集版本**。

六个交互式 skill 串起整个流程：

- **`/learn-this-project-absorb`**——驻场导师。多模式：**Orient**（给你"哪些文件该读 / 哪些文件该跑"的地图）、**Context-dive**（你贴一个 `file:line`，它就这个点展开讲）、**Next-step**、**Build**（帮你扩展项目）。它是一个**按需召唤的导师，不是一个要从头跟到尾的课程**——你迷路 / 卡住 / 想加东西的时候才用。
- **`/learn-this-project-quiz`**——讨论式答题，每个答案按 **3 段标准**（去哪查 + 是什么 + 为什么）打分。**一句话回答即使事实正确也算 ⚠️ partial**。两种模式：题库模式（保底覆盖）和开放式（你点话题它生成新题）。
- **`/learn-this-project-elevate`**——这个项目"再做 3-6 个月"会怎么升级。每条升级方向都会走完：现状 → 资深版目标 → 替代方案 → 前置知识，并且**收敛到一个具体的"起步交付物"**，你可以拿着这个交付物回到 Absorb Build 模式真的把它造出来。
- **`/learn-this-project-interview`**——完整的项目模拟面试，每个回答至少推回一次。检验你能不能把这个项目讲给一个陌生人。
- **`/learn-this-project-demo`**——给你排一个真人 demo 脚本。最高价值的部分是那张**"绝对不能秀给观众看"的清单**（教学产物不能出现在演示画面里）。
- **`/learn-this-project-publish`**——把这份教学仓库改造成你 GitHub 上的作品集仓库。删教学产物 → 生成你照着抄就行的提交清单 → 用你自己的语气和你共同写新 README → 最后跑一遍"敌意扫描"审计。

**推荐顺序：absorb → quiz → elevate → interview → demo → publish**。但记住，这些 skill 是按需召唤的——你需要定位 / 上下文 / 帮助的时候再用，不要把它们当作"逐章打卡"的课程。

## 这个仓库里有什么

```
.
├── examples/
│   ├── README.md              ← 课程总览（22 课目录）
│   ├── 01_sharpen_your_tools/ ← 第 01 课：DBeaver + SQLite 上手（特殊形状）
│   ├── 02-select-basics/      ← 第 02 课：SELECT 入门（书店库存）
│   ├── 03-select-columns-and-aliases/  ← 列投影 + AS 别名（咖啡馆菜单）
│   ├── ...                    ← 04-21 各一个行业 + 一个 SQL 主题
│   ├── 22-window-functions-ranking/    ← 第 22 课：窗口函数·排名（足球联赛）
│   ├── 23-window-functions-aggregates/ ← 第 23 课：窗口函数·聚合（城市天气）
│   └── check_examples.py      ← 批量自检：每个 .sql 跑一遍
├── learn_sql_query_basic/
│   └── csv_to_sqlite.py       ← 共享 loader：CSV → SQLite（97 行）
├── docs/learn-this-project/   ← 6 个交互 skill 读的"知识库"（7 份分析文档）
├── mise.toml                  ← 工具链定义：Python 3.12 + uv
└── pyproject.toml             ← 依赖：polars + SQLAlchemy 2.x
```

每个 `examples/NN-<主题>/` 都是一个自包含的小目录，里面有：`README.md` + `README-cn.md`（双语）、`data/NN_<表名>.csv`（按 FK 依赖排过序的 CSV 种子）、**已经预先生成并 commit 进 git 的 `db.sqlite`**（这样你打开 DBeaver 就能直接查询，不用先跑 Python）、5 行胶水代码的 `gen_db.py`（数据库坏了用它重建）、还有 3-6 个 `example_NN.sql` 教学查询。每个 SQL 文件顶上都有两段注释：**"业务问题"**（这条查询想回答什么）和**"为什么这么写"**（这条查询体现了什么原则）——这是这门课的教学签名。

## 技术栈 + 启动

| 工具 | 版本 | 用途 |
| :--- | :--- | :--- |
| `mise` | 最新 | 工具链管理器，钉死 Python / uv 版本 + 项目任务 |
| Python | 3.12 | 由 `mise.toml` 钉死 |
| `uv` | 最新 | 包管理器 |
| polars | `>=1.40.1,<2.0.0` | 读 CSV + 推断 dtype |
| SQLAlchemy | `>=2.0.33,<2.1.0` | Core 层建表 + 批量插入 |
| DBeaver Community（或 `sqlite3` CLI） | 任意近期版本 | 学习者侧的 SQL 编辑器 |

从仓库根目录跑：

```bash
mise install          # 一次性：按 mise.toml 钉版本
mise run venv-create  # 等价于 uv venv → .venv/
mise run inst         # 等价于 uv sync --all-extras
```

之后随时可以跑：

```bash
python examples/check_examples.py    # 批量自检所有教学 SQL
```

打开任意一节课的 `db.sqlite` 用 DBeaver 或 `sqlite3 examples/02-select-basics/db.sqlite` 就能开始查询了——**不需要先跑 Python 才能写 SQL**。

## 推荐学习节奏

| Skill | 一句话用法 |
| :---- | :--------- |
| `/learn-this-project-absorb` | **Orient** 拿地图 → **Context-dive** 贴 `file:line` 解释具体点 → **Build** 自己加东西 |
| `/learn-this-project-quiz` | 题库模式刷一轮（10 题）；薄弱处用开放式模式深挖；按"去哪查 + 是什么 + 为什么"自审 |
| `/learn-this-project-elevate` | 选 1-2 个升级方向（如"加 pytest 快照测试"、"加 Postgres CI 通道"），收敛到具体起步交付物 |
| `/learn-this-project-interview` | 完整跑一轮模拟面试；看 debrief 里的 3 个薄弱点回去补 |
| `/learn-this-project-demo` | 走完 5 分钟版本；把"绝对不能秀"清单背熟（24 个 `README-cn.md`、`docs/learn-this-project/`、5 个兄弟 skill 都在里面） |
| `/learn-this-project-publish` | Transform 模式：填新仓库名 → 删教学产物 → 生成 commit cheat-sheet → 和你一起写新 README → 最后跑 Audit |

> **如果你做过早期版本的 learn-this-project 课程**：现在 absorb 是多模式（不是线性走流程）、quiz 按 3 段标准打分（不是 80% 通过率）、elevate 会收敛到具体可建的起步交付物、publish 是新增的第 6 个 skill。下面的描述是当前行为。

## 把这个仓库变成你自己的作品集

学完之后用 `/learn-this-project-publish` 把这个仓库**改造成你 GitHub 上的作品集仓库**。基本规则：**敌意读者不能看出来这是教学仓库**。Publish skill 会替你处理：

- 把所有"这是教学产物"的文件删掉（24 个 `README-cn.md`、`docs/learn-this-project/`、5 个兄弟 skill 等等——只保留 `lesson-smith-learn-this-project-meta` 作为"展示学习方法"的加分项）；
- 生成 `tmp/publish-commit-plan.md`——一份依赖顺序排好的 10-15+ 提交清单，你照着复制粘贴运行 `git add / git commit`，**skill 本身不碰 git**；
- 用 D 模式（co-write）和你共同写英文版 `README.md`——它问，你答，它起草，你改稿，**不会编造你没说过的话**；
- 最后跑一遍 Audit（敌意扫描），出 0 个 🔴 HIGH RISK 才算过关。

整个过程在你自己的电脑上完成，新 GitHub repo 由你亲手创建并 `git push`——这是你"发布"这个动作的归属。

## 学透了的样子

学完这门课你应该：能从一句中文业务问题（"哪个品类的回头客最多？"、"每个司机本月跑了几趟车？"）反向写出对应的 SELECT；能解释每节课为什么选了那个行业 / 那张数据表 / 那种 SQL 模式；能在 DBeaver 里盲打出 `GROUP BY ... HAVING ...`、各种 `JOIN`、子查询、CTE、窗口函数；能讲清这门课**不**教什么（写入、建表、索引、跨方言差异），以及自己接下来要学什么。最终你有一个干净的、能拿出来给面试官看的 GitHub 仓库，里面是**你**的版本——而不是教程的版本。
