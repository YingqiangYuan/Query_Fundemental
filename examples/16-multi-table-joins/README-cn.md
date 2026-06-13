# Lesson 16 — 多表 JOIN（3 张表，甚至 4 张表）

> 真实业务里的查询很少只碰一张表。这节课我们把 INNER JOIN 和 LEFT JOIN 串起来，一次拉穿三四张表，回答"谁、看了谁、在哪个场馆、花了多少钱"这种完整问题。

## 我们要学什么

前面两节课你已经分别练过 `INNER JOIN`（[examples/14](../14-inner-join/)）和 `LEFT JOIN`（[examples/15](../15-left-join/)）。
这节课我们把它们**叠起来用**：

| 技巧 | 一句话 |
|------|--------|
| 三表 INNER JOIN | 一条 SQL 同时穿过三张表，按外键一步一步连接 |
| 四表 INNER JOIN | 再多加一张表 —— 模式完全一样，只是多写一行 `JOIN` |
| 混用 INNER 和 LEFT | 同一条查询里，有的表"必须匹配"，有的表"匹配不上也要保留" |
| 在多表 JOIN 之上聚合 | 把多张表拼成一个宽行流，再用 `GROUP BY` 折叠成报表（每个场馆/每个艺人的票房） |
| 可读性：按依赖顺序写 JOIN | 让人顺着外键链一眼看懂查询，5 张表以上时尤其重要 |

核心心智模型只有一个：**JOIN 是"把另一张表的列贴到当前结果上"**。
只要外键能连上，你就可以一直贴下去。

## 数据库故事

这节课的数据是一个小型**演唱会售票系统**：

| 表名 | 内容 | 行数 |
|------|------|------|
| `customers` | 买票的客户（姓名、邮箱、所在城市） | 20 |
| `venues` | 场馆信息（名字、城市、容量） | 6 |
| `events` | 演出场次（艺人、场馆 FK、演出日期） | 12 |
| `tickets` | 每张票一行（演出 FK、客户 FK、看台区、价格、购买日期） | 80 |

外键关系：
- `events.venue_id` → `venues.venue_id`
- `tickets.event_id` → `events.event_id`
- `tickets.customer_id` → `customers.customer_id`

我们故意让数据有一些"现实痕迹"：
- 有几个客户（在丹佛、迈阿密）一张票都没买 —— 用来验证 LEFT JOIN 是否真的把他们保留下来了。
- 有几个客户买了好几张（同一场两张、或者跨多场） —— 用来验证 `COUNT` 和 `SUM` 跨 JOIN 时算得对不对。

## 打开数据库

[db.sqlite](./db.sqlite) 已经预先生成好并提交进了 git，就在本目录下，你**不需要**自己跑生成脚本。
直接用 **DBeaver** 或者命令行 `sqlite3` 打开就行。

> **如果 [db.sqlite](./db.sqlite) 不小心坏了**：删掉它，再跑一次 [gen_db.py](./gen_db.py) 就能重新生成。
>
> ```bash
> python gen_db.py
> ```

## 先自己探索一下

正式开始前，强烈建议你先在 DBeaver 里点一点：

- 在左侧栏依次展开 `customers`、`venues`、`events`、`tickets`，预览每张表的前几行。
- 留意每张表上**哪一列是外键**（带 `_id` 后缀的那些通常就是）。
- 心里画一画三表/四表怎么连起来 —— 顺着 `tickets` 往外看：一边连到 `customers`，另一边连到 `events`，再从 `events` 跳到 `venues`。

把外键关系在脑子里走一遍，下面的 JOIN 语句会一下子变得直观很多。

## 跟着例子练

依次打开下面五个 SQL 文件，**一条一条**复制到你的 SQL 编辑器里执行：

- 每个文件最上面都有"业务问题 + 为什么这么写"的注释。**先读注释**，预想结果，再运行，最后对照。

| 文件 | 学到什么 |
|------|----------|
| [example_01.sql](./example_01.sql) | 三表 INNER JOIN —— `tickets` × `customers` × `events` |
| [example_02.sql](./example_02.sql) | 四表 INNER JOIN —— 再叠上 `venues`，给每张票一个完整的"剧情卡" |
| [example_03.sql](./example_03.sql) | 混用 LEFT JOIN + INNER JOIN —— 把没买过票的客户也保留下来 |
| [example_04.sql](./example_04.sql) | 在多表 JOIN 之上 `GROUP BY` —— 每个场馆的票房和售票数 |
| [example_05.sql](./example_05.sql) | 改一下 `GROUP BY` 就变成"每个艺人的票房"，顺便聊聊 JOIN 顺序怎么写更好读 |

## 关于 SQL 注释

你会发现每个 example 文件里都有一大堆以 `--` 开头的文字。SQL 有两种注释写法：

```sql
-- 单行注释：从 -- 到这一行结尾的内容都被数据库忽略。

/*
 * 块注释：可以跨多行。
 * 写长一点的说明很方便。
 */
```

数据库**会直接忽略**注释，所以你随便写，**不会影响**查询结果。
我们把"业务问题"和"为什么这么写"都用注释写在 SQL 旁边，方便你以后回头看的时候也能立刻想起这条 SQL 在干嘛。
