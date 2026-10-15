# 端到端数据分析项目：零售订单分析

基于 Kaggle 零售订单数据集（约 1 万条记录），完成 **数据清洗 → EDA 探索性分析 → SQL 业务挖掘 → 机器学习建模预测 → 可视化呈现** 的端到端数据分析项目，输出折扣定价与选品优化建议。

## Tech Stack

- **Python 3**：Pandas / NumPy / Matplotlib / Seaborn / Scikit-learn
- **数据库**：MySQL + SQLAlchemy（PyMySQL）
- **SQL**：窗口函数（ROW_NUMBER / LAG）、CTE、CASE 分桶、多维聚合
- **工具**：Jupyter Notebook、Kaggle API、Git

## Project Pipeline

### 1. 数据清洗（`notebooks/01_data_cleaning.ipynb`）
- 通过 Kaggle API 自动获取数据（9,994 条订单记录）
- 统一缺失值口径（将 'Not Available' / 'unknown' 识别为 NaN）、去重、列名规范化（snake_case）
- 基于业务逻辑构建 3 个派生指标：`discount`（折扣金额）、`sale_price`（实售价）、`profit`（利润）
- 保留 `discount_percent` 作为后续分析与建模的核心特征

### 2. EDA 探索性分析（`notebooks/02_eda.ipynb`）
- 月度销售趋势：发现明显年末旺季（11–12 月冲高）
- 品类 × 地区结构分析
- **折扣-利润散点图：提出"高折扣侵蚀利润"的核心业务假设**
- 相关性热力图：为建模特征筛选提供依据

### 3. SQL 业务挖掘（`sql_queries/business_analysis.sql`）
数据经 SQLAlchemy 分块写入 MySQL（`retail_db.df_orders`），编写 5 组分析查询：
- 销售额 Top 10 产品
- 各区域销量 Top 5 产品（窗口函数 ROW_NUMBER）
- 月度销售额环比增长率（LAG + CTE）
- **折扣分桶利润率统计（CASE WHEN，定量验证 EDA 提出的假设）**
- 各区域收入 / 利润 / 利润率全景（发现增收不增利区域）

### 4. 建模预测（`notebooks/04_modeling.ipynb`）
- **随机森林回归**预测订单利润：R² = 【填你的数字】，MAE = 【填你的数字】
- 特征重要性分析：`discount_percent` 为利润第一驱动因子，与 EDA / SQL 结论三方互证
- 附加**亏损订单分类模型**（RandomForestClassifier）：Recall = 【填你的数字】，可用于下单风险预警

### 5. 可视化呈现（`visualizations/`）
月度趋势、品类地区结构、折扣-利润关系、特征重要性等关键结论图表。


## Project Structure

```
retail-orders-analysis/
├── notebooks/
│   ├── 01_data_cleaning.ipynb     # 数据获取与清洗
│   ├── 02_eda.ipynb               # 探索性数据分析
│   └── 04_modeling.ipynb          # 利润预测与亏损分类模型
├── sql_queries/
│   └── business_analysis.sql      # 5 组业务分析 SQL
├── visualizations/                # 分析图表
├── data/
│   └── README.md                  # 数据说明（原始数据不上传）
├── requirements.txt
└── README.md
```

## Setup Instructions

1. 克隆仓库并安装依赖：
```bash
git clone https://github.com/【你的用户名】/retail-orders-analysis.git
cd retail-orders-analysis
pip install -r requirements.txt
```

2. 配置 Kaggle API：将 `access_token` 放入 `~/.kaggle/`（或手动从 Kaggle 下载 `ankitbansal06/retail-orders` 数据集至 `data/`）

3. 创建 MySQL 数据库：
```sql
CREATE DATABASE retail_db;
```
并修改 notebook 中连接串的用户名与密码。

4. 按序号依次运行 `notebooks/` 下的 Jupyter Notebook。

## Future Enhancements

- 引入 XGBoost / LightGBM 对比模型效果，网格搜索调参
- 基于 RFM 模型的客户分层分析
- 使用 Prophet 做销售额时间序列预测
- 用 Power BI 搭建交互式经营仪表盘
- 将亏损预警模型部署为 Streamlit 在线应用
