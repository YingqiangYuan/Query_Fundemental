# Lesson 23 — 窗口聚合、LAG 与 LEAD

> 既要每一行的细节，又要它所在分组的汇总值 —— 窗口聚合让 SQL 一次给你两样东西。

## 我们要学什么

上一节我们用窗口函数做了**排名**（`ROW_NUMBER`、`RANK`、`DENSE_RANK`）。
这一节我们换一类窗口函数：**聚合型**的窗口（`SUM`、`AVG` 加上 `OVER`），
还有两个非常实用的"挪一行"函数 —— `LAG` 和 `LEAD`。

| 构件 | 一句话 |
|------|--------|
| `AVG(...) OVER (PARTITION BY ...)` | 每行旁边贴上"它所在分组的平均值" |
| `SUM(...) OVER (... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` | 累计求和（running total） |
| `AVG(...) OVER (... ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` | 7 天滚动平均（rolling average） |
| `LAG(col) OVER (ORDER BY ...)` | 取"上一行"的值（昨天） |
| `LEAD(col) OVER (ORDER BY ...)` | 取"下一行"的值（明天） |
| `col - LAG(col) OVER (...)` | 日环比（day-over-day change）的经典写法 |

和 `GROUP BY` 最大的区别：
**窗口函数不会把行折叠**。你依然能看到每一天的原始记录，
旁边多了一列汇总信息，这正是窗口聚合最常用的场景。

## 数据库故事

这节课的练习数据是一个城市连续约 **6 个月**的每日气象观测，
风格上参考了波士顿这种四季分明、冬天会下雪的城市。

| 表名 | 内容 | 行数 |
|------|------|------|
| `weather_days` | 每天一行（日期、最高/最低气温、降水量、湿度、天气状况） | 181 |

字段说明：

- `reading_date` —— ISO 格式 `YYYY-MM-DD`，从 2024-11-01 到 2025-04-30，按时间排序。
- `temp_high_c` / `temp_low_c` —— 当日最高/最低气温（摄氏度）。
- `precipitation_mm` —— 当日降水量（毫米，雪也按融化后换算）。
- `humidity_pct` —— 当日平均相对湿度（百分数）。
- `condition` —— 天气状况，取 `sunny` / `cloudy` / `rain` / `snow` 四种之一。

只有一张表是故意的。窗口函数本身的关键在于
"如何在同一张表上既保留行又生成汇总"，多表关系反而会分散注意力。

## 打开数据库

`db.sqlite` 已经**预先生成好并提交进了 git**，就在本目录下，你**不需要自己跑生成脚本**。
直接把它用 **DBeaver**（图形界面）或者命令行 `sqlite3` 打开就行。
不会的话回 [examples/01-sharpen-your-tools](../01-sharpen-your-tools) 复习一下怎么连。

> **如果 `db.sqlite` 不小心坏了**：删掉它，再跑一次 [gen_db.py](./gen_db.py) 就能重新生成。
>
> ```bash
> python gen_db.py
> ```

## 先自己探索一下

正式开始前，**强烈建议你先自己动手点一点**：

- 在 DBeaver 左侧栏里展开 `weather_days`，双击表名预览数据。
- 看看每一列叫什么、是什么类型。
- 滚一滚那 181 行数据，留意：
  - 冬天的最高气温有没有出现负数？
  - `condition` 列里哪几个月 `snow` 出现得最多？
  - `precipitation_mm` 在晴天是不是都是 0？

对数据形成一个**直觉**之后，下面的窗口函数练习就会有"画面感"——
你能预想到一条 SQL 大概返回什么形状，再去验证它，比对着陌生数据猜要快得多。

## 跟着例子练

依次打开下面 6 个 SQL 文件，**一条一条**复制到你的 SQL 编辑器里执行：

- 每个文件最上面有一段注释，告诉你：
  - 这条 SQL 想回答**什么业务问题**（用日常人话写的）
  - 用了哪些 SQL 写法、**为什么**这么写
- **先读注释**，预想一下结果。
- **运行**它，看真实结果。
- 看完结果再读一遍注释，对照一下是不是和你想的一样。

| 文件 | 学到什么 |
|------|----------|
| [example_01.sql](./example_01.sql) | `AVG(...) OVER (PARTITION BY ...)` —— 每天旁边贴上"当月平均最高气温" |
| [example_02.sql](./example_02.sql) | `SUM(...) OVER (... UNBOUNDED PRECEDING ...)` —— 从第一天起的累计降水量 |
| [example_03.sql](./example_03.sql) | `AVG(...) OVER (... 6 PRECEDING ...)` —— 7 天滚动平均，给波动的温度做平滑 |
| [example_04.sql](./example_04.sql) | `LAG(...)` —— 在今天旁边显示昨天的最高气温 |
| [example_05.sql](./example_05.sql) | `LEAD(...)` —— 在今天旁边显示明天的最高气温 |
| [example_06.sql](./example_06.sql) | `col - LAG(col) OVER (...)` —— 日环比，找出温度波动最剧烈的几天 |

## 关于 SQL 注释（小知识）

你会发现每个 example 文件里都有一大堆以 `--` 开头的文字。
SQL 有两种注释写法：

```sql
-- 单行注释：从 -- 到这一行结尾的内容都被数据库忽略。

/*
 * 块注释：可以跨多行。
 * 写长一点的说明很方便。
 */
```

数据库**会直接忽略**注释，所以你随便写，**不会影响**查询结果。
我们在每个 example 文件里把"业务问题"和"为什么这么写"都用注释写在 SQL 旁边，
就是希望你以后回过头来看也能立刻想起这条 SQL 在干嘛——
注释和代码住在一起，比单独翻教程要省事得多。
