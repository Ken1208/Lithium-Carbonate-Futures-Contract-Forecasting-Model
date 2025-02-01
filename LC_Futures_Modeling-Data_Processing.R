# Loading and Cleaning Data (All files were downloaded from Guangzhou Futures Exchange official website)
data2025 = read.csv('ALLFUTURES2025.csv', header = FALSE)
data2024 = read.csv('ALLFUTURES2024.csv', header = FALSE)
data2023 = read.csv('ALLFUTURES2023.csv', header = FALSE)
data2023 <- data2023[-1, ]
rownames(data2023) <- NULL
colnames(data2023) <- data2023[1, ]
data2023 <- data2023[-1, ]
rownames(data2023) <- NULL
data2024 <- data2024[-1, ]
rownames(data2024) <- NULL
colnames(data2024) <- data2024[1, ]
data2024 <- data2024[-1, ]
rownames(data2024) <- NULL
data2025 <- data2025[-1, ]
rownames(data2025) <- NULL
colnames(data2025) <- data2025[1, ]
data2025 <- data2025[-1, ]
rownames(data2025) <- NULL
combined_data <- rbind(data2023, data2024, data2025)
data <- subset(combined_data, 品种名称 == "碳酸锂")  # Select Lithium Carbonate
# write.csv(data, "lc_data.csv", row.names = FALSE)

par(family = "PingFang SC")  

# Convert Variable Type
library(dplyr)
data <- data %>%
  mutate(
    交易日期 = as.Date(as.character(交易日期), format = "%Y%m%d"),    # add trading date
    交割月份 = as.Date(paste0("20", substr(as.character(交割月份), 1, 2), "-", 
                          substr(as.character(交割月份), 3, 4), "-01"))
  )
numeric_columns <- c("前结算价", "开盘价", "最高价", "最低价", "收盘价", "结算价", 
                     "涨跌", "涨跌1", "成交量", "持仓量", "持仓量变化", "成交额")
data[numeric_columns] <- lapply(data[numeric_columns], as.numeric)
str(data)
head(data)

library(tidyr)
data <- data %>% drop_na()

for (contract in contracts) {
  contract_data <- data %>% filter(合约代码 == contract)
  contract_data <- contract_data %>% arrange(交易日期)
  
  # Add features for the next day's prices and directions
  contract_data <- contract_data %>%
    mutate(
      Next_Day_Closing_Price = lead(收盘价, 1),
      Next_Day_Opening_Price = lead(开盘价, 1),
      Next_Day_Highest_Price = lead(最高价, 1),
      Next_Day_Lowest_Price = lead(最低价, 1),
      Next_Day_Settlement_Price = lead(结算价, 1),
      Price_Up_or_Down = ifelse(涨跌 > 0, "Up", "Down"),   # 1 if 涨跌 > 0, otherwise 0
      Price_Up_or_Down1 = ifelse(涨跌1 > 0, "Up", "Down"),  # 1 if 涨跌1 > 0, otherwise 0
      Next_Day_Price_Up_or_Down = lead(Price_Up_or_Down, 1),
      Next_Day_Price_Up_or_Down1 = lead(Price_Up_or_Down1, 1),
      Next_Day_Price_Up_or_Down_Num = ifelse(Next_Day_Price_Up_or_Down == "Up", 1, 0)
    )
  
  
  contract_datasets[[contract]] <- contract_data
}

