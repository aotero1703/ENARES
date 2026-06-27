# 📊 ENARES 2024 Processing Pipeline

<div align="center">

### Automated processing of the National Survey on Social Relations (ENARES 2024)

Reproducible Stata workflows for generating official indicators and analytical datasets.

![Stata](https://img.shields.io/badge/Stata-16+-1F5AA6?style=flat-square)
![INEI](https://img.shields.io/badge/Source-INEI-blue?style=flat-square)
![Power BI](https://img.shields.io/badge/Visualization-Power%20BI-F2C811?style=flat-square)
![Reproducible Research](https://img.shields.io/badge/Reproducible-Research-success?style=flat-square)

</div>

---

## 📌 Project Overview

This repository contains a fully reproducible workflow to process the **2024 National Survey on Social Relations (ENARES)**.

The scripts automate data cleaning, indicator construction and dataset generation, producing outputs that can be directly used for statistical analysis, official reporting and interactive Power BI dashboards.

> 📷 **Recommendation:** Add a screenshot of your dashboard here (`docs/dashboard_preview.png`).

---

## 🗂 Repository Structure

```text
ENARES/
│
├── CRS01/
├── CRS02/
├── CRS03/
├── CRS04/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── outputs/
│
├── docs/
│
└── README.md
```

---

## 👥 ENARES 2024 Modules

| Module | Target population | Main topic |
|---------|------------------|------------|
| 👩 **CRS01** | Women aged 18 years and older | Intimate partner violence, sexual harassment and economic dependency |
| 👥 **CRS02** | Men and women aged 18 years and older | Social tolerance and sexist beliefs |
| 🧒 **CRS03** | Children aged 9–11 years | Violence at home and school |
| 🧑 **CRS04** | Adolescents aged 12–17 years | Violence at home, school and sexual violence |

---

# 📈 Official ENARES Indicators

## CRS01 — Women aged 18 years and older

| Code | Indicator | 2015 | 2019 | 2024 | Comparability |
|------|-----------|------|------|------|---------------|
| 8.2.1 | Psychological violence by partner/ex-partner | 23.5% | 19.4% | 14.1% | ✔ Comparable |
| ... | ... | ... | ... | ... | ... |

*(Continue with the remaining indicator tables.)*

---

## 🚀 Quick Start

1. Open **Stata 16** or a newer version.
2. Download the corresponding microdata from the **INEI Microdata Portal**.
3. Update the `global root` directory.
4. Run the `.do` file of the desired **CRS module**.
5. The required project folders will be created automatically.
6. All generated outputs will be saved in the `/outputs/` directory.
7. The outputs can be used directly for dashboards, reports or additional analyses.

---

## 📊 Interactive Dashboard

Explore the interactive Power BI dashboard:

👉 **ENARES 2024 Indicators Dashboard**

https://app.powerbi.com/view?r=eyJrIjoiZDE4ZDg4MjAtNzRjMC00MGY5LTk3MjAtNGRhOTAxNDQ2NGNiIiwidCI6IjY4MTljNDYzLTVkZWItNDA3MC1hY2I2LTlmZGQzY2FhZTk4NCJ9

---

## 📖 About ENARES 2024

<p align="center">

<img src="docs/enares2024_cover.jpg" width="320">

</p>

The **National Survey on Social Relations (ENARES)** is conducted by the **National Institute of Statistics and Informatics (INEI)** and generates official statistics on violence against women, children and adolescents, gender norms and social tolerance in Peru.

---

## ⚙ Methodological Notes

| Item | Description |
|------|-------------|
| **Source** | ENARES 2024 – INEI |
| **Coverage** | National |
| **Domains** | National, Urban/Rural and Department |
| **Expansion factor** | `fac_pob` |
| **Software** | Stata 16+ |

---

## 📚 References

- INEI (2025). *Informe de los Principales Resultados – ENARES 2024.*
- Ministerio de la Mujer y Poblaciones Vulnerables (2025).
- Ley N.° 30364.

---

## ⭐ Citation

If you use this repository in your research, teaching or policy analysis, please cite:

> Otero Flores, A. (2026). **ENARES 2024 Processing Pipeline**. GitHub Repository.

---

## 🤝 Contact

If you have questions, suggestions or would like to collaborate, feel free to connect.

- 💼 LinkedIn: https://www.linkedin.com/in/alexandra-otero-flores-31937214a/
- ✉️ Email: oterof.alexandra@pucp.edu.pe

## 💬 Frase que nos guía

> “Los datos no solo describen la violencia: ayudan a prevenirla.”  
> — *Alexandra Otero Flores* 🌸

---
