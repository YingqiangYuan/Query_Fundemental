# learn_sql_query_basic — 课程目录

> 22 节 SQL 查询基础课，每节一个真实行业 + 一个独立的 SQLite 数据库。本课程**只讲 SELECT**，不涉及任何写入或建表操作。

## 怎么用本教程

如果你还不会用 DBeaver / 命令行打开 `.sqlite` 文件，先做 [01 — 工具入门](./01_sharpen_your_tools/) 把环境跑通。后面所有课都假设你已经会这一步。

从 02 起按数字顺序学。每节都是一个独立的文件夹，`db.sqlite` 已经预先生成并 commit 进 git，**直接用 DBeaver 或 `sqlite3` 打开就行**（万一文件损坏，进对应文件夹跑 `python gen_db.py` 就能重新生成）。

每节文件夹的玩法：
1. 先读 `README-cn.md` 了解这节课的业务背景和表结构。
2. 在 DBeaver 里把表展开看看，对数据有个画面感。
3. 把 `example_01.sql` … `example_0N.sql` **一条一条**复制到你的 SQL 编辑器里跑，仔细看每个文件顶上的注释——它会告诉你这条查询想回答**什么业务问题**、以及**为什么这么写**。具体讲解都在那里，本目录文件只是一个总览。

想批量自查所有 SQL 还能不能跑：在仓库根目录跑 `python examples/check_examples.py`。

---

## 课程列表

### [02 — SELECT 基础](./02-select-basics/)
- **学什么:** 最最基础的 SELECT 怎么写，不带任何过滤
- **数据集:** 书店库存（`books`，20 行）
- **会学到:** `SELECT *`、`LIMIT`、`COUNT(*)`、`DISTINCT`

### [03 — 挑列与列别名](./03-select-columns-and-aliases/)
- **学什么:** 不再 `SELECT *`，只挑自己要的列，并给列改个友好的名字
- **数据集:** 咖啡馆菜单（`drinks`，30 行）
- **会学到:** `SELECT col1, col2, ...`、`AS` 别名、列的顺序与重命名

### [04 — WHERE 入门](./04-where-basics/)
- **学什么:** 用 WHERE 按单个条件筛行
- **数据集:** 健身房课表（`gym_classes`，40 行）
- **会学到:** `=`、`!=` / `<>`、`>`、`<`、`>=`、`<=`，顺便踩一个 `= NULL` 陷阱（下一节用 `IS NULL` 修）

### [05 — WHERE 的 AND / OR / NOT](./05-where-and-or-not/)
- **学什么:** 多条件组合，用括号控制优先级
- **数据集:** 酒店房型（`hotel_rooms`，50 行）
- **会学到:** `AND`、`OR`、`NOT`、括号改变运算优先级

### [06 — LIKE / IN / BETWEEN / IS NULL](./06-where-like-in-between-null/)
- **学什么:** WHERE 的便捷运算符，替代笨重的 AND/OR 长串
- **数据集:** 电影院场次（`showtimes`，50 行）
- **会学到:** `LIKE` 通配符（`%` 和 `_`）、`IN` / `NOT IN`、`BETWEEN`、`IS NULL` / `IS NOT NULL`

### [07 — ORDER BY](./07-order-by/)
- **学什么:** 控制结果行的排列顺序
- **数据集:** 流媒体内容库（`titles`，40 行）
- **会学到:** `ASC` / `DESC`、多列排序、混合方向、`NULLS LAST`、按列号排序

### [08 — LIMIT / OFFSET 与 Top-N](./08-limit-offset-top-n/)
- **学什么:** 只取前 N 行、分页大结果集
- **数据集:** 播客周榜（`chart_entries`，80 行）
- **会学到:** `LIMIT`、`OFFSET`、`ORDER BY + LIMIT` 的 Top-N 写法，以及没有 `ORDER BY` 的 `LIMIT` 是个坑

### [09 — 计算列与 CASE](./09-computed-columns-and-case/)
- **学什么:** 在 SELECT 里算出新列，用 CASE 做条件分支
- **数据集:** 外卖订单（`delivery_orders`，60 行）
- **会学到:** 算术运算、`||` 字符串拼接、`CASE WHEN ... THEN ... ELSE ... END`、`CASE` 用在 `ORDER BY` 里做自定义排序

### [10 — 内置函数](./10-builtin-functions/)
- **学什么:** SQLite 自带的字符串、数值、日期函数
- **数据集:** 公共图书馆借阅记录（`checkouts`，50 行）
- **会学到:** `UPPER` / `LOWER` / `LENGTH` / `TRIM` / `SUBSTR` / `REPLACE`、`ROUND` / `ABS` / `CAST`、`date()` / `strftime()`、`COALESCE` / `IFNULL`

### [11 — 聚合函数](./11-aggregate-functions/)
- **学什么:** 把多行压缩成一个汇总数（还没引入 GROUP BY）
- **数据集:** 个人银行流水（`transactions`，100 行）
- **会学到:** `COUNT(*)` vs `COUNT(col)`（NULL 的差异）、`SUM`、`AVG`、`MIN` / `MAX`、`COUNT(DISTINCT col)`

### [12 — GROUP BY](./12-group-by/)
- **学什么:** 按某个列分组，再对每组分别聚合
- **数据集:** 便利店销售（`sales`，120 行）
- **会学到:** `GROUP BY`、多列分组、`GROUP BY + ORDER BY` 按聚合值排序、"必须出现在 GROUP BY 或被聚合" 规则

### [13 — HAVING vs WHERE](./13-having-vs-where/)
- **学什么:** 按聚合值筛选分组；理清整条 SELECT 语句的子句顺序
- **数据集:** 运动手环每日日志（`daily_logs`，150 行）
- **会学到:** `HAVING`、`WHERE` 与 `HAVING` 的位置和职责差别、`SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT` 完整顺序

### [14 — INNER JOIN](./14-inner-join/)
- **学什么:** 两张表通过主外键拼到一起
- **数据集:** 宠物医院（`pets` + `visits`，20 + 40 行）
- **会学到:** `INNER JOIN ... ON ...`、表别名、列限定避免歧义、`JOIN` 默认就是 `INNER JOIN`

### [15 — LEFT JOIN](./15-left-join/)
- **学什么:** 保留左表所有行；用 LEFT JOIN + IS NULL 找出"没有匹配"的反连接
- **数据集:** 网约车（`drivers` + `rides`，15 + 50 行；其中 3 个司机零行程）
- **会学到:** `LEFT JOIN`、`IS NULL` 反连接、`COUNT(col)` vs `COUNT(*)` 的差异、`RIGHT JOIN` 的等价改写

### [16 — 多表 JOIN](./16-multi-table-joins/)
- **学什么:** 三张到四张表连续 join 出一个宽报表
- **数据集:** 演唱会票务（`customers` + `venues` + `events` + `tickets`，20 + 6 + 12 + 80 行）
- **会学到:** 3-4 表 join、INNER 和 LEFT 混用、跨多 join 的聚合（如按场馆/艺人统计票房）、join 顺序对可读性的影响

### [17 — 自连接 (self-join)](./17-self-join/)
- **学什么:** 一张表连自己，处理层级结构
- **数据集:** 零售连锁组织架构（`staff` 自引用，20 行，3 层管理）
- **会学到:** 自连接（同表不同别名）、`IS NULL` 找树顶、统计直接下属人数、二级 hop（员工→经理→大老板）

### [18 — WHERE 里的子查询](./18-subqueries-in-where/)
- **学什么:** 在 WHERE 里用子查询做"成员判定"
- **数据集:** 约会 app（`users` + `matches`，30 + 54 行）
- **会学到:** `IN (subquery)`、`NOT IN` + NULL 陷阱（返回 0 行）、`EXISTS` / `NOT EXISTS`（NULL-safe 替代）、与标量比较的子查询

### [19 — 标量与派生表子查询](./19-scalar-and-derived-subqueries/)
- **学什么:** 在 SELECT 和 FROM 里用子查询
- **数据集:** 订阅盒子（`subscribers` + `shipments`，25 + 89 行）
- **会学到:** SELECT 里的标量子查询、FROM 里的派生表、相关子查询、"先聚合再 join" 的常见模式

### [20 — CTE (WITH 公共表表达式)](./20-cte-with/)
- **学什么:** 把中间结果命名出来，让多步查询读得像散文
- **数据集:** 房产中介（`agents` + `listings` + `transactions`，10 + 40 + 20 行）
- **会学到:** 单个 `WITH`、多个 CTE 串联、把嵌套子查询重构成 CTE、CTE join 回基础表

### [21 — 集合运算](./21-set-operations/)
- **学什么:** 把两个查询的结果集合并、求交、求差
- **数据集:** 咖啡店堂食 vs 外带（`dine_in_orders` + `takeout_orders`，30 + 30 行）
- **会学到:** `UNION ALL`、`UNION`（带去重）、`INTERSECT`、`EXCEPT`、列数与类型必须匹配的规则

### [22 — 窗口函数 (一)：排名](./22-window-functions-ranking/)
- **学什么:** 不压缩行数也能"看到别人"——给每行算个排名
- **数据集:** 足球联赛比赛记录（`match_results`，80 行）
- **会学到:** `ROW_NUMBER()`、`RANK()` 和 `DENSE_RANK()` 在平局上的区别、`PARTITION BY` 分组内排名、"每组 Top-N" 写法

### [23 — 窗口函数 (二)：聚合 + LAG/LEAD](./23-window-functions-aggregates/)
- **学什么:** 累计、滚动、环比——把聚合函数用作窗口函数
- **数据集:** 城市天气日记录（`weather_days`，181 行，6 个月）
- **会学到:** `SUM/AVG OVER (PARTITION BY ...)`、累计求和（`ROWS BETWEEN UNBOUNDED PRECEDING ...`）、滚动平均、`LAG` / `LEAD`、日/月环比计算
