# AU_EDA_csiro-co2-ch4-40yr-trend
40-year trend analysis of atmospheric CO2 and CH4 using CSIRO data.

---

# 📊 Engineering Data Analytics: Greenhouse Gas Analysis Project

**Course:** ENGI 5006 Engineering Data Analytics (2026)  
**Group Name:** Pegasus 
**Group Members:**  
*   Peter Nyeunwoo Lee (a3191921)
*   Adam Athar Syed (a1992415)
*   Maneesha Wanigasekara (a3189269)
*   Sanket Santosh Salunkhe (a3188843)
*   Mohammed Shalahuddin Abdul Aziz (a2611760)
*   Jiaqi Wu (a1991498)
  
---

## 📝 Abstract
This project investigates the long-term trends and relationship between two major greenhouse gases, Carbon Dioxide ($CO_2$) and Methane ($CH_4$). Using atmospheric data from the Cape Grim Baseline Air Pollution Station in Tasmania (1985–2025), we perform comprehensive data analytics including univariate, bivariate analysis and ANOVA analysis. A linear regression model is developed to quantify growth rates and provide atmospheric concentration predictions.

---

## 🔑 Keywords
greenhouse gases, carbon dioxide, methane, Cape Grim, predictive model.

---

## 📁 Repository Structure
Following the course guidelines, this repository is organized as follows:
*   `/Data`: Contains raw datasets.
*   `/Code`: R scripts for data cleaning, visualisation, and regression modeling.
*   `/Outputs`: Generated plots (histograms, boxplots, scatterplots) and the final PDF report.
*   `README.md`: This project overview file.

---

## 🔍 Introduction
Global climate change, driven by increasing greenhouse gas concentrations, is one of the most significant engineering challenges of our time. This study analyzes 40 years of high-quality baseline data to identify growth patterns and the statistical correlation between $CO_2$ and $CH_4$.

---

## ⚙️ How to Run
1.  Clone this repository to your local machine.
2.  Download the two raw data files from `/Data`.
3.  Ensure **RStudio** and the `tidyverse` library are installed. (Version 2026.04.0+526)
4.  Open the project and set the working directory to the root folder.
5.  Run the scripts in the `/Code` folder to reproduce all plots and statistical outputs.

---

## 📊 Data
*   **Source:** Cape Grim Baseline Air Pollution Station (Tasmania).
*   **Cleaning:** The raw data was processed to remove missing values (NAs) and standardise variable names for reproducibility.
*   **Study Area:** A map showing the station's location is included in the full project report.

---

## 🧪 Methods
Our analytical framework follows the ENGI 5006 syllabus:
1.  **Univariate Analysis:** We analysed the distribution of $CO_2$ (ppm) and $CH_4$ (ppb) using Histograms and Boxplots, identifying outliers via the $1.5 \times IQR$ rule.
2.  **Bivariate Analysis:** The relationship was explored using Scatterplots and the Correlation Coefficient ($r$) to assess direction, strength, and form.
3.  **ANOVA Analysis:** We examined the changes in $CO_2$ (ppm/day) and $CH_4$ (ppb/day) mean growth rates across four decades. Assumptions (Normality and constant Variance) were validated using Q-Q plots and variance checks.
4.  **Linear Regression:** We modeled the concentrations over time. Assumptions (Linearity, Constant Spread, Normality, and Independence) were validated using Residuals vs. Fitted and Normal Q-Q plots.

---

## 📚 Bibliography
*   Data Source: Cape Grim Baseline Air Pollution Station. (2025). Atmospheric composition & chemistry. CSIRO. Retrieved May 29, 2026, from https://www.csiro.au/greenhouse-gases/
*   *Note: Course materials (Topic Notes, Forums) are used for methodology but not cited as primary literature sources as per instructions.*

--------------------------------------------------------------------------------
