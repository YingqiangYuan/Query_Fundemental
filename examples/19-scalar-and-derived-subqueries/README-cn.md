# Lesson 19 — 标量子查询和派生表子查询

> 一个 SELECT 里塞另一个 SELECT —— 当"对比值"或"中间表"恰好是一个查询能算出来的东西时，子查询就上场了。

## 我们要学什么

上一节（[Lesson 18](../18-subqueries-in-where/)）我们把子查询塞进了 `WHERE`。
这节课，我们把子查询塞进 `SELECT` 和 `FROM`：

| 写法 | 一句话 | 长什么样 |
|------|--------|----------|
| **标量子查询**（在 SELECT 里） | 子查询返回一个数，外层每行都用它 | `SELECT ..., (SELECT AVG(x) FROM t) AS avg_x FROM t` |
| **派生表**（在 FROM 里） | 子查询返回一张小表，外层把它当表 JOIN | `FROM (SELECT subscriber_id, SUM(...) ...) AS agg` |
| **相关子查询**（在 SELECT 里） | 子查询引用外层每一行，逐行重新算 | `(SELECT AVG(x) FROM child WHERE child.fk = outer.id)` |
| **"先聚合再 JOIN"** | 相关子查询的清爽改写 | `LEFT JOIN (SELECT ... GROUP BY ...) AS agg ON ...` |

学完这四种姿势，你就具备了下节课（CTE / `WITH`）的全部前置直觉 ——
CTE 本质上就是把派生表"提取出来、起个名字"。

## 数据库故事

我们经营一个**每月订阅盒**生意（想想 Birchbox / Loot Crate 那种）：
- 订阅者每月会收到一个主题盒子（"Indie Snacks"、"Cozy Reads"、"Beauty Picks" …）。
- 每个订阅者属于一个套餐：`basic` / `premium` / `luxury` —— 套餐档次决定盒子里东西的数量和价值。

| 表 | 内容 | 行数 |
|----|------|------|
| `subscribers` | 每位订阅者一行（姓名、套餐、注册日期、城市） | 25 |
| `shipments` | 每次发货一行（外键 `subscriber_id`、发货日期、盒子主题、物品数量、申报价值） | 89 |

`shipments.subscriber_id` 指向 `subscribers.subscriber_id`。

## 打开数据库

`db.sqlite` 已经预先生成好并提交进了 git，就在本目录下。
直接用 **DBeaver** 或者 `sqlite3` 打开就行，**不需要**自己跑生成脚本。

> **如果 `db.sqlite` 不小心坏了**：删掉它，再跑一次 [gen_db.py](./gen_db.py) 就能重新生成。
>
> ```bash
> python gen_db.py
> ```

## 先自己探索一下

正式做例子前，强烈建议你先在 DBeaver 里手动逛一圈：

- 预览 `subscribers`：看看有多少种 `plan`、覆盖了哪些城市。
- 预览 `shipments`：看看 `declared_value` 的大致区间，`box_theme` 有哪些主题。
- 心里粗略估一下：luxury 套餐的盒子是不是真比 basic 贵几倍？
- 想象一下：如果让你"按订阅者算每人平均盒子价值"，你会怎么动手？

这种"先用眼睛过一遍数据再写 SQL"的习惯，会让接下来子查询的形状变得很自然 ——
你已经知道答案"长什么样"了，剩下的只是用 SQL 把它写出来。

## 跟着例子练

依次打开下面四个 SQL 文件，**一条一条**复制到你的 SQL 编辑器里执行：

| 文件 | 学到什么 |
|------|----------|
| [example_01.sql](./example_01.sql) | **标量子查询在 SELECT 里** —— 每行旁边挂一个"全局平均"做对比 |
| [example_02.sql](./example_02.sql) | **派生表在 FROM 里** —— 先按订阅者聚合 shipments，再 JOIN 回姓名 |
| [example_03.sql](./example_03.sql) | **相关子查询在 SELECT 里** —— 每位订阅者各算各的平均（直观但慢） |
| [example_04.sql](./example_04.sql) | **先聚合再 JOIN** —— example_03 的清爽改写，自然过渡到 CTE |

每个文件最上方都有一段注释，会先用日常人话写出"这条 SQL 在回答什么业务问题"，
再说明"为什么这么写"。**先读注释、预想结果、再运行、最后回头对照。**

注意例 03 和例 04 返回的是**同一份结果**，但写法不同 ——
这是这节课最重要的对照：同一个问题可以有多种 SQL 形状，
"哪种更易读、更可扩展"是你以后写查询永远在权衡的事。

## 关于 SQL 注释（小知识）

每个 example 文件里都有大量以 `--` 开头的文字。SQL 有两种注释写法：

```sql
-- 单行注释：从 -- 到这一行结尾的内容都被数据库忽略。

/*
 * 块注释：可以跨多行。
 * 写长一点的说明很方便。
 */
```

数据库会直接忽略注释，所以你随便写、随便加，**不会影响**查询结果。
我们把"业务问题"和"为什么这么写"都贴在 SQL 旁边 —— 以后回头看也能一眼想起这条 SQL 在干嘛。
