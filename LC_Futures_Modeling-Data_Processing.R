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
