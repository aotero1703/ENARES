# 📊 ENARES 2024 — Reproducible Stata Processing Pipeline

<div align="center">

### Automated workflows for processing the National Survey on Social Relations (ENARES 2024)

Reproducible scripts for generating official indicators, analytical datasets and Power BI-ready outputs.

![Stata](https://img.shields.io/badge/Stata-16+-1F5AA6?style=flat-square)
![INEI](https://img.shields.io/badge/Data-INEI-blue?style=flat-square)
![Survey](https://img.shields.io/badge/Survey-ENARES%202024-success?style=flat-square)
![Power BI](https://img.shields.io/badge/Visualization-Power%20BI-F2C811?style=flat-square)
![Reproducible Research](https://img.shields.io/badge/Reproducible-Research-success?style=flat-square)

<br>

| 📊 Indicators | 👥 Modules | 💻 Software | 📈 Dashboard |
|:-------------:|:----------:|:-----------:|:------------:|
| **24 Official Indicators** | **4 Population Modules** | **Stata 16+** | **Power BI Ready** |

</div>

---

## 📌 Project Overview

This repository contains a fully reproducible workflow for processing the **2024 National Survey on Social Relations (ENARES)**.

Using **Stata**, the pipeline automates data cleaning, indicator construction and dataset generation, producing outputs that can be directly used for statistical analyses, official reporting and interactive Power BI dashboards.

---

## 🗂 Repository Structure

```text
ENARES/
│
├── CRS01/
│   ├── CRS01.do
│   └── README.md
│
├── CRS02/
│   ├── CRS02.do
│   └── README.md
│
├── CRS03/
│   ├── CRS03.do
│   └── README.md
│
├── CRS04/
│   ├── CRS04.do
│   └── README.md
│
├── data/
│   ├── raw/
│   └── processed/
│
├── outputs/
│
└── README.md
```

---

# 👥 ENARES 2024 Modules

| Module | Target population | Main topic |
|---------|------------------|------------|
| 👩 **CRS01** | Women aged 18 years and older | Intimate partner violence, sexual harassment and economic dependency |
| 👥 **CRS02** | Men and women aged 18 years and older | Social tolerance and sexist beliefs |
| 🧒 **CRS03** | Children aged 9–11 years | Violence at home and school |
| 🧑 **CRS04** | Adolescents aged 12–17 years | Violence at home, school and sexual violence |

---

# 📈 Official ENARES Indicators

## 👩 CRS01 — Women aged 18 years and older

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|---------------|
| 8.2.1 | Psychological violence by partner/ex-partner (last 12 months) | 23.5% | 19.4% | 14.1% | ✔ |
| 8.2.2 | Physical violence by partner/ex-partner (last 12 months) | 5.6% | 6.3% | 4.4% | ✖ |
| 8.2.3 | Sexual violence by partner/ex-partner (last 12 months) | 4.3% | 4.5% | 2.4% | ✖ |
| 8.2.5 | Severe physical violence by partner/ex-partner | N.A. | N.A. | 1.2% | ✖ |
| 8.2.6 | Sexual violence by someone other than the partner | N.A. | N.A. | 3.2% | ✖ |
| 8.2.12 | Sexual harassment by someone other than the partner | N.A. | N.A. | 3.0% | ✖ |
| 8.3.1 | Women who experienced interparental violence | N.A. | N.A. | 34.1% | ✖ |
| 8.3.16 | Women economically dependent on their partner/ex-partner | N.A. | N.A. | 28.6% | ✖ |
| 8.3.4 | Physical or psychological punishment by the mother toward children under six years old | N.A. | N.A. | 29.7% | ✖ |

---

## 👥 CRS02 — Men and women aged 18 years and older

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|---------------|
| 8.3.2 | Men who experienced interparental violence | N.A. | N.A. | 34.0% | ✖ |
| 8.3.7 | Men who justify sexual assault against women | N.A. | N.A. | 56.5% | ✖ |
| 8.3.12 | Population that tolerates violence against women | N.A. | N.A. | 75.7% | ✖ |
| 8.3.13 | Men who justify sexual violence against women | N.A. | N.A. | 69.7% | ✖ |
| 8.3.14 | Population endorsing sexist beliefs | N.A. | N.A. | 87.4% | ✖ |
| 8.3.15 | Population endorsing sexist attitudes | N.A. | N.A. | 71.3% | ✖ |

---

## 🧒 CRS03 — Children aged 9–11 years

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|---------------|
| 8.3.5 | Physical or psychological violence by parents | 41.5% | 38.7% | 45.9% | ✔ |
| 8.3.8 | School violence victims | 50.1% | 47.4% | 44.0% | ✔ |
| 8.3.10 | Children who perpetrate school violence | N.A. | N.A. | 13.2% | ✖ |

---

## 🧑 CRS04 — Adolescents aged 12–17 years

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|---------------|
| 8.2.7 | Sexual violence by someone other than the partner | N.A. | N.A. | 22.4% | ✖ |
| 8.2.11 | Sexual violence before age 12 | N.A. | N.A. | 15.2% | ✖ |
| 8.2.13 | Sexual harassment by someone other than the partner | N.A. | N.A. | 21.7% | ✖ |
| 8.3.6 | Physical or psychological violence by parents | 38.9% | 40.5% | 43.6% | ✔ |
| 8.3.9 | Adolescent victims of school violence | 47.4% | 44.7% | 45.9% | ✔ |
| 8.3.11 | Male adolescents who perpetrate school violence | N.A. | N.A. | 19.0% | ✖ |

> **Note:** Comparability refers to whether the indicator can be directly compared across survey rounds.

---

# 🚀 Quick Start

1. Open **Stata 16** or later.
2. Download the ENARES microdata from the INEI Microdata Portal.
3. Update the `global root` directory.
4. Run the corresponding `.do` file.
5. The repository structure will be generated automatically.
6. Processed datasets and outputs will be stored in `/outputs/`.
7. Use the generated outputs for statistical analyses, reports or Power BI dashboards.

---

# 📊 Interactive Dashboard

Explore the interactive dashboard:

👉 **ENARES 2024 Indicators Dashboard**

https://app.powerbi.com/view?r=eyJrIjoiZDE4ZDg4MjAtNzRjMC00MGY5LTk3MjAtNGRhOTAxNDQ2NGNiIiwidCI6IjY4MTljNDYzLTVkZWItNDA3MC1hY2I2LTlmZGQzY2FhZTk4NCJ9

---

# 📖 About ENARES

<p align="center">
<img src="docs/enares2024_cover.jpg" width="320">
</p>

The National Survey on Social Relations (ENARES) is conducted by the **National Institute of Statistics and Informatics (INEI)** in coordination with the **Ministry of Women and Vulnerable Populations (MIMP)**. The survey provides official statistics on violence against women, children and adolescents, gender norms and social tolerance in Peru.

---

# ⚙ Methodological Notes

| Item | Description |
|------|-------------|
| **Source** | ENARES 2024 – INEI |
| **Coverage** | National |
| **Domains** | National, Urban/Rural and Department |
| **Expansion factor** | `fac_pob` |
| **Software** | Stata 16+ |

---

# 📚 References

- INEI (2025). *Informe de los Principales Resultados – ENARES 2024.*
- Ministerio de la Mujer y Poblaciones Vulnerables (2025).
- Ley N.º 30364.

---

# ⭐ Citation

If you use this repository in research, teaching or policy analysis, please cite:

> Otero Flores, A. (2026). *ENARES 2024 Reproducible Stata Processing Pipeline*. GitHub Repository.

---

# 🤝 Contact

**Alexandra Otero Flores**

Economist | Government Analytics Fellow

💼 LinkedIn: https://www.linkedin.com/in/alexandra-otero-flores-31937214a/

✉️ Email: oterof.alexandra@pucp.edu.pe

---

> *"Data do not only describe violence—they help prevent it."*  
> **— Alexandra Otero Flores**
