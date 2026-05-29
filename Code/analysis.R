#' ---
#' title: "EDA Pegasus CSIRO CO2, CH4 Analysis Report"
#' author: "Peter Nyeunwoo Lee"
#' output:
#'   pdf_document:
#'     latex_engine: xelatex
#' ---

## Loading library ----

library(tidyverse)



## Raw file organisation ----

# Loading csv files to compare
df_co2 <- read.csv("CapeGrim_CO2_data_download.csv", skip = 24)

df_ch4 <- read.csv("CapeGrim_CH4_data_download.csv", skip = 24)


# Remove the rows that contain na
df_co2_new <- df_co2 %>%
  na.omit()

df_ch4_new <- df_ch4 %>%
  na.omit()



# 1. Join the two datasets horizontally based on dates
# If YYYY, MM, DD are common, they are used as keys for joining.
df_co2_ch4_bined <- left_join(df_co2_new, df_ch4_new, by = c("YYYY", "MM", "DD"))

# 2. Verify column names and perform unit conversion
df_clean <- df_co2_ch4_bined %>%
  na.omit()

# CO2, CH4 growth rate caculation (ppm per day)
df_clean <- df_clean %>%
  mutate(
    Calculated.GR.ppm.per.day = (CO2.ppm. - lag(CO2.ppm.)) / (DATE.x - lag(DATE.x)),
    Calculated.GR.ppb.per.day = (CH4.ppb. - lag(CH4.ppb.)) / (DATE.y - lag(DATE.y))
  )




## CO2 Univariate Analysis ----

# 1. Histogram: Understanding the 'shape' of the data 

ggplot(df_clean, aes(x = CO2.ppm.)) + 
  geom_histogram(color = "black", fill = "cyan2", bins = 30) + 
  labs(title = "Histogram of CO2 Concentration", x = "CO2 (PPM)", y = "Count") + 
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# 2. Descriptive Statistics and Five-Number Summary 

summary_stats <- df_clean %>%   
  summarise(
    Minimum = min(CO2.ppm., na.rm = TRUE), 
    Q1 = quantile(CO2.ppm., probs = 0.25, na.rm = TRUE), 
    Median = median(CO2.ppm., na.rm = TRUE), 
    Mean = mean(CO2.ppm., na.rm = TRUE), 
    Q3 = quantile(CO2.ppm., probs = 0.75, na.rm = TRUE), 
    Maximum = max(CO2.ppm., na.rm = TRUE), 
    IQR = IQR(CO2.ppm., na.rm = TRUE), 
    SD = sd(CO2.ppm., na.rm = TRUE)
  )
print(summary_stats)

# 3. Outlier Identification 

co2_iqr <- summary_stats$IQR
co2_lower_bound <- summary_stats$Q1 - (1.5 * co2_iqr)
co2_upper_bound <- summary_stats$Q3 + (1.5 * co2_iqr)

print("CO2 Lower bound for outliers:")
print(co2_lower_bound)

print("CO2 Upper bound for outliers:")
print(co2_upper_bound)

# 4. Boxplot: Visualizing Five-Number Summary and Outliers

ggplot(df_clean, aes(y = CO2.ppm.)) +
  geom_boxplot(fill = "cyan2", color = "black") +
  labs(title = "Boxplot of CO2 Gas", y = "PPM") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))



## CH4 (Methane)  Univariate Analysis ----

# 1. Histogram: Understanding the 'shape' of the data

ggplot(df_clean, aes(x = CH4.ppb.)) +
  geom_histogram(color = "black", fill = "green", bins = 30) +
  labs(title = "Distribution Histogram of CH4 (Methane) Gas",
       x = "Methane Concentration (ppb)",
       y = "Frequency") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# 2. Descriptive Statistics and Five-Number Summary

ch4_summary_stats <- df_clean %>%   
  summarise(
    Minimum = min(CH4.ppb.),
    Q1 = quantile(CH4.ppb., 0.25),      
    Median = median(CH4.ppb.), # Median (Q2)
    Mean = mean(CH4.ppb.),
    Q3 = quantile(CH4.ppb., 0.75),     
    Maximum = max(CH4.ppb.),
    IQR = IQR(CH4.ppb.),               
    Std_Dev = sd(CH4.ppb.) # Standard Deviation
  )

print("Descriptive Statistics Summary for CH4:")
print(ch4_summary_stats)

# 3. Outlier Identification: 1.5 x IQR Rule 

iqr_ch4 <- ch4_summary_stats$IQR
lower_ch4 <- ch4_summary_stats$Q1 - (1.5 * iqr_ch4)
upper_ch4 <- ch4_summary_stats$Q3 + (1.5 * iqr_ch4)

cat("CH4 Lower bound for outliers:", lower_ch4, "\n")
cat("CH4 Upper bound for outliers:", upper_ch4, "\n")

# 4. Boxplot Visualization

ggplot(df_clean, aes(y = CH4.ppb.)) +
  geom_boxplot(fill = "green", color = "black") +
  labs(title = "Boxplot of CH4 Gas",
       y = "Methane Concentration (ppb)") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# 5. Statistical Outlier Extraction

ch4_outliers <- boxplot.stats(df_clean$CH4.ppb.)$out
print("Detected Outliers within CH4 Data:")
print(ch4_outliers)




## CO2 vs CH4 Bivariate Analysis ----

# 1. Scatter Plot Visualization

ggplot(df_clean, aes(x = CO2.ppm., y = CH4.ppb., color = DATE.x)) +
  geom_point(size = 1, alpha = 0.6) +
  scale_color_gradient(low = "blue", high = "red") + 
  geom_smooth(method = "lm", color = "black", linetype = "dashed") + # Linear regression line
  labs(
    x = expression(CO[2]~Concentration~(ppm)),
    y = expression(CH[4]~Concentration~(ppb)),
    title = "Bivariate Analysis of Greenhouse Gases",
    subtitle = "Cape Grim Baseline Air Pollution Station (1985-2025)",
    color = "Year") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))


# 2. Correlation Analysis

r_value <- cor(df_clean$CO2.ppm., df_clean$CH4.ppb., use = "complete.obs")
cat("Correlation coefficient (r):", r_value, "\n")

# 3. Consolidated Summary Statistics

gas_summary <- df_clean %>%
  pivot_longer(cols = c(CO2.ppm., CH4.ppb.), 
               names_to = "Gas_Type", 
               values_to = "Concentration") %>%
  group_by(Gas_Type) %>%
  summarise(
    n = n(),
    Mean = mean(Concentration, na.rm = TRUE),
    Median = median(Concentration, na.rm = TRUE),
    SD = sd(Concentration, na.rm = TRUE),
    IQR = IQR(Concentration, na.rm = TRUE),
    Min = min(Concentration, na.rm = TRUE),
    Max = max(Concentration, na.rm = TRUE)
  )

print(gas_summary)

# 4. Outlier Detection using 1.5 x IQR Rule

df_outliers <- df_clean %>%
  summarise(
    CO2_Lower = quantile(CO2.ppm., 0.25) - 1.5 * IQR(CO2.ppm.),
    CO2_Upper = quantile(CO2.ppm., 0.75) + 1.5 * IQR(CO2.ppm.),
    CH4_Lower = quantile(CH4.ppb., 0.25) - 1.5 * IQR(CH4.ppb.),
    CH4_Upper = quantile(CH4.ppb., 0.75) + 1.5 * IQR(CH4.ppb.)
  )

print(df_outliers)




## Linear Regression Analysis ----

# 1. Make Linear regression model

co2_model <- lm(CO2.ppm. ~ DATE.x, data = df_clean)
ch4_model <- lm(CH4.ppb. ~ DATE.y, data = df_clean)

# 2. Checking Linear Regression Assumptions

### 2.1 CO2 Model Diagnostics ###

# Linearity and Constant Spread: Residuals vs Fitted Plot

ggplot(df_clean, aes(x = fitted(co2_model), y = residuals(co2_model))) +
  geom_point() +
  geom_abline(slope = 0, intercept = 0, color = "red") +
  labs(x = "Fitted", y = "Residuals", title = "CO2 Model: Residuals vs Fitted Plot") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# Normality: Normal Q-Q Plot of Residuals

ggplot(mapping = aes(sample = residuals(co2_model))) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  labs(x = "Theoretical", y = "Sample", title = "CO2 Model: Normal Q-Q Plot") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

### 2.2 CH4 Model Diagnostics ###

# Linearity and Constant Spread: Residuals vs Fitted Plot

ggplot(df_clean, aes(x = fitted(ch4_model), y = residuals(ch4_model))) +
  geom_point() +
  geom_abline(slope = 0, intercept = 0, color = "red") +
  labs(x = "Fitted", y = "Residuals", title = "CH4 Model: Residuals vs Fitted Plot") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# Normality: Normal Q-Q Plot of Residuals

ggplot(mapping = aes(sample = residuals(ch4_model))) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  labs(x = "Theoretical", y = "Sample", title = "CH4 Model: Normal Q-Q Plot") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# 3. Create future data frames and calculate 'Prediction Intervals'

future_co2_df <- tibble(DATE.x = seq(2026, 2036 - 1/12, by = 1/12))
future_ch4_df <- tibble(DATE.y = seq(2026, 2036 - 1/12, by = 1/12))

# Calculate fit (prediction line), lwr (lower bound), and upr (upper bound) at a 95% confidence level

co2_pred_int <- predict(co2_model, newdata = future_co2_df, interval = "prediction", level = 0.95)
ch4_pred_int <- predict(ch4_model, newdata = future_ch4_df, interval = "prediction", level = 0.95)

# Combine the interval matrices with the future data frames

future_co2_df <- cbind(future_co2_df, co2_pred_int)
future_ch4_df <- cbind(future_ch4_df, ch4_pred_int)


# 4. CO2 visualization (both current data and prediction interval)

ggplot() +
  geom_line(data = df_clean, aes(x = DATE.x, y = CO2.ppm.), alpha = 0.4) + # current data
  # Shading the prediction interval (geom_ribbon is placed first to layer it underneath the line)
  geom_ribbon(data = future_co2_df, aes(x = DATE.x, ymin = lwr, ymax = upr), 
              fill = "red", alpha = 0.15) + # 95% prediction interval ribbon
  geom_line(data = future_co2_df, aes(x = DATE.x, y = fit), color = "red", linewidth = 1) + # prediction data (fit)
  labs(title = "CO2 Observations and 2035 Predictions (with 95% PI)", x = "Year", y = "CO2 (ppm)") +
  theme_bw() + 
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# 5. CH4 visualization (both current data and prediction interval)

ggplot() +
  geom_line(data = df_clean, aes(x = DATE.y, y = CH4.ppb.), alpha = 0.4) + # current data
  # Shading the prediction interval
  geom_ribbon(data = future_ch4_df, aes(x = DATE.y, ymin = lwr, ymax = upr), 
              fill = "blue", alpha = 0.15) + # 95% prediction interval ribbon
  geom_line(data = future_ch4_df, aes(x = DATE.y, y = fit), color = "blue", linewidth = 1) + # prediction data (fit)
  labs(title = "CH4 Observations and 2035 Predictions (with 95% PI)", x = "Year", y = "CH4 (ppb)") +
  theme_bw() + 
  theme(plot.title = element_text(face = "bold", hjust = 0.5))
