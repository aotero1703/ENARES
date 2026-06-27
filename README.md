# 📊 ENARES 2024 — Reproducible Statistical Processing Pipeline

<div align="center">

### Automated workflows for processing the National Survey on Social Relations (ENARES 2024)

*Reproducible Stata scripts for generating official indicators, analytical datasets and Power BI-ready outputs.*

</div>

---

## 📌 Project Overview

This repository provides a fully reproducible **Stata pipeline** for processing the **2024 National Survey on Social Relations (ENARES)**.

The workflow automates data cleaning, indicator construction and output generation, producing datasets that can be directly used for statistical analyses, official reporting and interactive Power BI dashboards.

---

## 📦 Repository Outputs

Running the pipeline automatically generates:

- 📊 Official ENARES indicators
- 📁 Clean analytical datasets
- 📑 Publication-ready tables
- 📈 Outputs ready for Power BI dashboards
- 🔄 Reproducible statistical workflows

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

The following tables summarize the official ENARES indicators reproduced by this repository.

---

## 👩 CRS01 — Women aged 18 years and older

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|:-------------:|
| **8.2.1** | Psychological violence by partner/ex-partner (last 12 months) | 23.5% | 19.4% | 14.1% | ✔ |
| **8.2.2** | Physical violence by partner/ex-partner (last 12 months) | 5.6% | 6.3% | 4.4% | ✖ |
| **8.2.3** | Sexual violence by partner/ex-partner (last 12 months) | 4.3% | 4.5% | 2.4% | ✖ |
| **8.2.5** | Severe physical violence by partner/ex-partner | N.A. | N.A. | 1.2% | ✖ |
| **8.2.6** | Sexual violence by someone other than the partner | N.A. | N.A. | 3.2% | ✖ |
| **8.2.12** | Sexual harassment by someone other than the partner | N.A. | N.A. | 3.0% | ✖ |
| **8.3.1** | Women who experienced interparental violence | N.A. | N.A. | 34.1% | ✖ |
| **8.3.16** | Women economically dependent on their partner/ex-partner | N.A. | N.A. | 28.6% | ✖ |
| **8.3.4** | Physical or psychological punishment by the mother toward children under six years old | N.A. | N.A. | 29.7% | ✖ |

---

## 👥 CRS02 — Men and women aged 18 years and older

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|:-------------:|
| **8.3.2** | Men who experienced interparental violence | N.A. | N.A. | 34.0% | ✖ |
| **8.3.7** | Men who justify sexual assault against women | N.A. | N.A. | 56.5% | ✖ |
| **8.3.12** | Population that tolerates violence against women | N.A. | N.A. | 75.7% | ✖ |
| **8.3.13** | Men who justify sexual violence against women | N.A. | N.A. | 69.7% | ✖ |
| **8.3.14** | Population endorsing sexist beliefs | N.A. | N.A. | 87.4% | ✖ |
| **8.3.15** | Population endorsing sexist attitudes | N.A. | N.A. | 71.3% | ✖ |

---

## 🧒 CRS03 — Children aged 9–11 years

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|:-------------:|
| **8.3.5** | Physical or psychological violence by parents | 41.5% | 38.7% | 45.9% | ✔ |
| **8.3.8** | School violence victims | 50.1% | 47.4% | 44.0% | ✔ |
| **8.3.10** | Children who perpetrate school violence | N.A. | N.A. | 13.2% | ✖ |

---

## 🧑 CRS04 — Adolescents aged 12–17 years

| Code | Official indicator | 2015 | 2019 | 2024 | Comparability |
|------|--------------------|------:|------:|------:|:-------------:|
| **8.2.7** | Sexual violence by someone other than the partner | N.A. | N.A. | 22.4% | ✖ |
| **8.2.11** | Sexual violence before age 12 | N.A. | N.A. | 15.2% | ✖ |
| **8.2.13** | Sexual harassment by someone other than the partner | N.A. | N.A. | 21.7% | ✖ |
| **8.3.6** | Physical or psychological violence by parents | 38.9% | 40.5% | 43.6% | ✔ |
| **8.3.9** | Adolescent victims of school violence | 47.4% | 44.7% | 45.9% | ✔ |
| **8.3.11** | Male adolescents who perpetrate school violence | N.A. | N.A. | 19.0% | ✖ |

> **Note:** ✔ Comparable indicators can be directly compared across survey rounds. ✖ Indicators are not directly comparable because of methodological changes or because they were introduced in ENARES 2024.

---

# 🚀 Quick Start

1. Open **Stata 16** (or a newer version).
2. Download the ENARES microdata from the **INEI Microdata Portal**.
3. Configure the working directory by updating the `global root` macro.
4. Run the `.do` file corresponding to the desired **CRS module**.
5. The required project folders will be created automatically if they do not already exist.
6. All generated outputs will be stored in the `/outputs/` directory.
7. Use the resulting datasets to perform statistical analyses, prepare reports or develop interactive Power BI dashboards.

---

# 📊 Interactive Dashboard

The outputs generated by this repository can be explored through the interactive Power BI dashboard below.

🔗 **ENARES 2024 Indicators Dashboard**

https://app.powerbi.com/view?r=eyJrIjoiZDE4ZDg4MjAtNzRjMC00MGY5LTk3MjAtNGRhOTAxNDQ2NGNiIiwidCI6IjY4MTljNDYzLTVkZWItNDA3MC1hY2I2LTlmZGQzY2FhZTk4NCJ9

> **Recommendation:** Add a screenshot of the dashboard (`docs/dashboard_preview.png`) here so visitors can immediately see the final product.

---

# 📖 About ENARES

<p align="center">
<img src="docs/enares2024_cover.jpg" width="320">
</p>

The **National Survey on Social Relations (ENARES)** is conducted by the **National Institute of Statistics and Informatics (INEI)** in coordination with the **Ministry of Women and Vulnerable Populations (MIMP)**.

The survey provides nationally representative information on violence against women, children and adolescents, gender norms, discriminatory attitudes and social tolerance, supporting evidence-based public policies in Peru.

---

# ⚙ Methodological Notes

| Item | Description |
|------|-------------|
| **Source** | ENARES 2024 – INEI |
| **Survey Design** | National probabilistic household survey |
| **Coverage** | National |
| **Domains** | National, Urban/Rural and Department |
| **Expansion Factor** | `fac_pob` |
| **Software** | Stata 16+ |

---

# 📚 References

- INEI (2025). *Informe de los Principales Resultados de la Encuesta Nacional sobre Relaciones Sociales (ENARES) 2024.*
- Ministerio de la Mujer y Poblaciones Vulnerables (2025).
- Ley N.° 30364 – Ley para prevenir, sancionar y erradicar la violencia contra las mujeres y los integrantes del grupo familiar.

---

# ⭐ Citation

If you use this repository in research, teaching or policy analysis, please cite:

> Otero Flores, A. (2026). *ENARES 2024 — Reproducible Statistical Processing Pipeline*. GitHub Repository.

---

# 🤝 Contact

**Alexandra Otero Flores**

Economist | Government Analytics Fellow

- 💼 LinkedIn: https://www.linkedin.com/in/alexandra-otero-flores-31937214a/
- ✉️ Email: oterof.alexandra@pucp.edu.pe

---

<div align="center">

*"Data do not only describe violence—they help prevent it."*

**— Alexandra Otero Flores**

</div>
