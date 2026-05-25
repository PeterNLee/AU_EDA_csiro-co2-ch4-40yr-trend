# AU_EDA_csiro-co2-ch4-40yr-trend
40-year trend analysis of atmospheric CO2 and CH4 using CSIRO data.


# 📊 Engineering Data Analytics: Greenhouse Gas Analysis Project

**Course:** ENGI 5006 Engineering Data Analytics (2026)  
**Group Name:** Pegasus 
**Group Members:**  
*   Peter Nyeunwoo Lee (a3191921)

---

## 📝 Abstract
This project investigates the long-term trends and relationship between two major greenhouse gases, Carbon Dioxide ($CO_2$) and Methane ($CH_4$). Using atmospheric data from the Cape Grim Baseline Air Pollution Station in Tasmania (1985–2025), we perform comprehensive data analytics including univariate and bivariate analysis. A linear regression model is developed to quantify growth rates and provide atmospheric concentration predictions for the year 2035. [1, 2]

## 🔑 Keywords
Greenhouse Gases, Linear Regression, $CO_2$, $CH_4$, Environmental Engineering, Data Analytics. [3]

---

## 📁 Repository Structure
Following the course guidelines, this repository is organized as follows: [3]
*   `/data`: Contains raw and cleaned datasets (`csiro_co2_ch4_final.csv`).
*   `/scripts`: R scripts for data cleaning, visualization, and regression modeling.
*   `/outputs`: Generated plots (histograms, boxplots, scatterplots) and the final PDF report.
*   `README.md`: This project overview file.

---

## 🔍 Introduction
Global climate change, driven by increasing greenhouse gas concentrations, is one of the most significant engineering challenges of our time. This study analyzes 40 years of high-quality baseline data to identify growth patterns and the statistical correlation between $CO_2$ and $CH_4$. [4, 5]

## 📊 Data
*   **Source:** Cape Grim Baseline Air Pollution Station (Tasmania).
*   **Cleaning:** The raw data was processed to remove missing values (NAs) and standardize variable names for reproducibility. [4, 6, 7]
*   **Study Area:** A map showing the station's location is included in the full project report. [4]

## 🧪 Methods
Our analytical framework follows the ENGI 5006 syllabus: [4]
1.  **Univariate Analysis:** We analyzed the distribution of $CO_2$ (ppm) and $CH_4$ (ppb) using Histograms and Boxplots, identifying outliers via the $1.5 \times IQR$ rule. [8, 9]
2.  **Bivariate Analysis:** The relationship was explored using Scatterplots and the Correlation Coefficient ($r$) to assess direction, strength, and form. [10, 11]
3.  **Linear Regression:** We modeled the concentrations over time ($y = \beta_0 + \beta_1x + \epsilon$). Assumptions (Linearity, Constant Spread, Normality, and Independence) were validated using Residuals vs. Fitted and Normal Q-Q plots. [12-15]

## 📈 Results
*   **Correlation:** A strong positive linear relationship was confirmed between $CO_2$ and $CH_4$. [16, 17]
*   **Model Performance:** Regression diagnostics showed that the linear assumptions were reasonably satisfied. [18, 19]
*   **Predictions:** Based on the fitted model, we estimated 95% Prediction Intervals (PI) for greenhouse gas levels in 2035, while being mindful of the risks of over-extrapolation. [20, 21]

## 🏁 Conclusion
The results demonstrate a consistent and statistically significant increase in both $CO_2$ and $CH_4$ levels over the past four decades. These findings emphasize the urgency of ongoing monitoring and the development of engineering solutions to mitigate atmospheric pollution. [22]

---

## ⚙️ How to Run
1.  Clone this repository to your local machine.
2.  Ensure **RStudio** and the `tidyverse` library are installed.
3.  Open the project and set the working directory to the root folder.
4.  Run the scripts in the `/scripts` folder to reproduce all plots and statistical outputs.

---

## 📚 Bibliography
*   Data Source: Cape Grim Baseline Air Pollution Station.
*   *Note: Course materials (Topic Notes, Forums) are used for methodology but not cited as primary literature sources as per instructions.* [22]

--------------------------------------------------------------------------------
