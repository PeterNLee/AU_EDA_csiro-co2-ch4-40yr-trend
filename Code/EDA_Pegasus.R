#' ---
#' Title: "EDA Pegasus CSIRO CO2, CH4 Analysis Report"
#' Author: "Peter Nyeunwoo Lee"
#' Last modified: "29 May 2026"
#' ---





## Loading library ----

library(tidyverse)






## Raw file organisation ----

# Loading CO2, CH4 csv files to compare
df_co2 <- read.csv("CapeGrim_CO2_data_download.csv", skip = 24)

df_ch4 <- read.csv("CapeGrim_CH4_data_download.csv", skip = 24)


# Remove the rows that contain na
df_co2_new <- df_co2 %>%
  na.omit()

df_ch4_new <- df_ch4 %>%
  na.omit()


# Join the two datasets horizontally based on dates
# If YYYY, MM, DD are common, they are used as keys for joining.
df_co2_ch4_bined <- left_join(df_co2_new, df_ch4_new, by = c("YYYY", "MM", "DD"))

# Delete those rows that omit either value of the gases
df_clean <- df_co2_ch4_bined %>%
  na.omit()

# CO2, CH4 growth rate caculation (ppm per day), these are to be used for ANOVA test
df_clean <- df_clean %>%
  mutate(
    Calculated.GR.ppm.per.day = (CO2.ppm. - lag(CO2.ppm.)) / (DATE.x - lag(DATE.x)),
    Calculated.GR.ppb.per.day = (CH4.ppb. - lag(CH4.ppb.)) / (DATE.y - lag(DATE.y))
  )






## Univariate Analysis ----

# CO2 Univariate Analysis

# 1. Histogram: Understanding the 'shape' of the data 

ggplot(df_clean, aes(x = CO2.ppm.)) + 
  geom_histogram(color = "black", fill = "deepskyblue", bins = 30) + 
  labs(title = expression(Statistical~Distribution~of~Baseline~CO[2]~Concentration), 
       x = expression(CO[2]~Concentration~(ppm)), 
       y = "Frequency") + 
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

print("Descriptive Statistics Summary for CO2:")
print(summary_stats)

# 3. Outlier Identification 

co2_iqr <- summary_stats$IQR
co2_lower_bound <- summary_stats$Q1 - (1.5 * co2_iqr)
co2_upper_bound <- summary_stats$Q3 + (1.5 * co2_iqr)

print("CO2 Lower bound for outliers:")
print(co2_lower_bound)

print("CO2 Upper bound for outliers:")
print(co2_upper_bound)

# 4. Boxplot: Visualising Five-Number Summary and Outliers

ggplot(df_clean, aes(y = CO2.ppm.)) +
  geom_boxplot(fill = "deepskyblue", color = "black") +
  labs(title = expression(Statistical~Distribution~of~Baseline~CO[2]~Concentration), 
       y = expression(CO[2]~Concentration~(ppm))) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))







# CH4 Univariate Analysis

# 1. Histogram: Understanding the 'shape' of the data

ggplot(df_clean, aes(x = CH4.ppb.)) +
  geom_histogram(color = "black", fill = "darkgreen", bins = 30) +
  labs(title = expression(Statistical~Distribution~of~Baseline~CH[4]~Concentration), 
       x = expression(CH[4]~Concentration~(ppb)),
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
  geom_boxplot(fill = "darkgreen", color = "black") +
  labs(title = expression(Statistical~Distribution~of~Baseline~CH[4]~Concentration), 
       y = expression(CH[4]~Concentration~(ppb))) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))






## CO2 vs CH4 Bivariate Analysis ----

# 1. Scatter Plot Visualization

ggplot(df_clean, aes(x = CO2.ppm., y = CH4.ppb., color = DATE.x)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red", linetype = "dashed") +
  scale_color_gradient(low = "darkblue", high = "yellowgreen") + 
  labs(
    x = expression(CO[2]~Concentration~(ppm)),
    y = expression(CH[4]~Concentration~(ppb)),
    title = expression(Bivariate~Analysis~of~CO[2]~and~CH[4]),
    color = "Year") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))


# 2. Correlation Analysis

r_bivariate <- cor(df_clean$CO2.ppm., df_clean$CH4.ppb., use = "complete.obs")
print("Correlation coefficient (r):")
print(r_bivariate)






## ANOVA Analysis ----

# Data preparation for analysis

decade_data <- df_clean %>%
  filter(YYYY >= 1986 & YYYY <= 2025) %>%
  mutate(Decade = case_when(
    YYYY <= 1995 ~ "1986-1995",
    YYYY <= 2005 ~ "1996-2005",
    YYYY <= 2015 ~ "2006-2015",
    TRUE ~ "2016-2025"
  )) %>%
  mutate(Decade = as.factor(Decade))

# CO2 ANOVA test

# 1. Pre Analysis assumption Validation 

# Assumption 1: Observations within each group are normally distributed

ggplot(decade_data, aes(sample = Calculated.GR.ppm.per.day, group = Decade)) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  theme_bw() +
  labs(x = "Theoretical", y = "Sample", title = expression(QQ~Plot~of~CO[2]~Growth~Rates~by~Decade)) +
  facet_wrap(~ Decade, ncol = 2, scales = 'free') +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Assumption 2: The groups have a constant variance

co2_summary <- decade_data %>% 
  group_by(Decade) %>% 
  summarise(n = n(),
            mean = mean(Calculated.GR.ppm.per.day),
            sd = sd(Calculated.GR.ppm.per.day))

r <- max(co2_summary$sd) / min(co2_summary$sd)

print(r)


# 2. Testing hypothesis

co2_aov_model <- aov(Calculated.GR.ppm.per.day ~ Decade, data = decade_data)
summary(co2_aov_model)


# 3. Tukey HSD test

TukeyHSD(co2_aov_model)


# 4. Boxplot (CO2 growth rate by decade)

ggplot(decade_data, aes(y = Calculated.GR.ppm.per.day, fill = Decade)) +
  geom_boxplot() +
  labs(y = "Growth Rate (ppm/day)", fill= "Decade", title = expression(CO[2]~Growth~Rates~by~Decade))+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))+
  scale_fill_manual(values = c("#00BFFF", "#00A0AA", "#008255", "#006400"))




# CH4 ANOVA Analysis

# 1. Pre Analysis assumption Validation

# Assumption 1: Observations within each group are normally distributed

ggplot(decade_data, aes(sample = Calculated.GR.ppb.per.day, group = Decade)) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  theme_bw() +
  labs(x = "Theoretical", y = "Sample", title = expression(QQ~Plot~of~CH[4]~Growth~Rates~by~Decade)) +
  facet_wrap(~ Decade, ncol = 2, scales = 'free') +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))


#Assumption 2. The groups have a constant variance

ch4_summary <- decade_data %>% 
  group_by(Decade) %>% 
  summarise(n = n(),
            mean = mean(Calculated.GR.ppb.per.day),
            sd= sd(Calculated.GR.ppb.per.day))

r <- max(ch4_summary$sd) / min(ch4_summary$sd)

print(r)


# 2. Testing hypothesis

ch4_aov_model <- aov(Calculated.GR.ppb.per.day ~ Decade, data = decade_data)

summary(ch4_aov_model)


# 3. Boxplot (CH4 growth rate by decade)

ggplot(decade_data, aes(y = Calculated.GR.ppb.per.day, fill = Decade)) +
  geom_boxplot() +
  labs(, y = "Growth Rate (ppb/day)", fill= "Decade", title = expression(CH[4]~Growth~Rates~by~Decade))+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))+
  scale_fill_manual(values = c("#00BFFF", "#00A0AA", "#008255", "#006400"))






## Linear Regression Model ----

# CO2 Linear Regression Model

# 1. Make Linear regression model

co2_model <- lm(CO2.ppm. ~ DATE.x, data = df_clean)

print("Summary of CO2 Linear Regression model")
summary(co2_model)


# 2. Check Linear Regression Assumptions

# Assumption 1. Linearity and Constant Spread based on Residuals vs Fitted Plot

ggplot(df_clean, aes(x = fitted(co2_model), y = residuals(co2_model))) +
  geom_point() +
  geom_abline(slope = 0, intercept = 0, color = "red") +
  labs(x = "Fitted", y = "Residuals", title = expression(Residuals~vs~Fitted~Plot~of~CO[2])) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# Assumption 2. Normality based on Normal Q-Q Plot of Residuals

ggplot(mapping = aes(sample = residuals(co2_model))) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  labs(x = "Theoretical", y = "Sample", title = expression(Normal~QQ~Plot~of~CO[2])) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# 3. Create future data frames and calculate Predicted data

future_data <- data.frame(DATE.x = c(2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035))

future_data$predicted_co2 <- predict(object = lm(data = df_clean, formula = CO2.ppm. ~ DATE.x), newdata = future_data)


# 4. Visualisation of both current data and predicted data

ggplot() +
  geom_line(data = df_clean, aes(x = DATE.x, y = CO2.ppm.), alpha = 0.4) + # current data
  geom_smooth(data = df_clean, aes(x = DATE.x, y = CO2.ppm.), method = "lm", color = "darkblue", se = FALSE) +
  geom_point(data = future_data, aes(x = DATE.x, y = predicted_co2), color = "red") +
  labs(title = expression(CO[2]~Observations~(1985-2025)~and~Predictions~(2026-2035)), 
       x = "Year", 
       y = expression(CO[2]~Concentration~(ppm))) +
  theme_bw() + 
  theme(plot.title = element_text(face = "bold", hjust = 0.5))



# CH4 Linear Regression Model

# 1. Make Linear regression model

ch4_model <- lm(CH4.ppb. ~ DATE.y, data = df_clean)

print("Summary of CH4 Linear Regression model")
summary(ch4_model)


# 2. Check Linear Regression Assumptions

# Assumption 1. Linearity and Constant Spread based on Residuals vs Fitted Plot

ggplot(df_clean, aes(x = fitted(ch4_model), y = residuals(ch4_model))) +
  geom_point() +
  geom_abline(slope = 0, intercept = 0, color = "red") +
  labs(x = "Fitted", y = "Residuals", title = expression(Residuals~vs~Fitted~Plot~of~CH[4])) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# Assumption 2: Normality based on Normal Q-Q Plot of Residuals

ggplot(mapping = aes(sample = residuals(ch4_model))) +
  stat_qq(distribution = stats::qnorm) +
  stat_qq_line(distribution = stats::qnorm, color = "red") +
  labs(x = "Theoretical", y = "Sample", title = expression(Normal~QQ~Plot~of~CH[4])) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# 3. Create future data frames and calculate Predicted data

future_data$predicted_ch4 <- predict(object = lm(data = df_clean, formula = CH4.ppb. ~ DATE.x), newdata = future_data)


# 4. Visualisation of both current data and predicted data

ggplot() +
  geom_line(data = df_clean, aes(x = DATE.y, y = CH4.ppb.), alpha = 0.4) + # current data
  geom_smooth(data = df_clean, aes(x = DATE.y, y = CH4.ppb.), method = "lm", color = "darkblue", se = FALSE) +
  geom_point(data = future_data, aes(x = DATE.x, y = predicted_ch4), color = "red") +
  labs(title = expression(CH[4]~Observations~(1985-2025)~and~Predictions~(2026-2035)), 
       x = "Year", 
       y = expression(CH[4]~Concentration~(ppb))) +
  theme_bw() + 
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

