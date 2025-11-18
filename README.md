
---

## 👥 Poblaciones y módulos ENARES 2024

| Módulo | Población objetivo | Temática principal |
|--------|--------------------|--------------------|
| **CRS01** | Mujeres de 18+ años | Violencia por pareja, acoso y dependencia económica |
| **CRS02** | Hombres y mujeres de 18+ años | Tolerancia social y creencias sexistas |
| **CRS03** | Niñas y niños 9–11 años | Violencia en hogar y escuela |
| **CRS04** | Adolescentes 12–17 años | Violencia en hogar, escuela y sexual |

---

# Indicadores oficiales ENARES – Valores 2015, 2019 y 2024

## Módulo CRS01 – Mujeres de 18 años a más

| Código | Indicador | 2015 | 2019 | 2024 | Nota de comparabilidad |
|--------|-----------|-------|--------|--------|---------------------------|
| 8.2.1 | Violencia psicológica por pareja/expareja (últimos 12 meses) | 23.5% | 19.4% | 14.1% | Comparable, incluye expareja |
| 8.2.2 | Violencia física por pareja/expareja (últimos 12 meses) | 5.6% | 6.3% | 4.4% | No comparable |
| 8.2.3 | Violencia sexual por pareja/expareja (últimos 12 meses) | 4.3% | 4.5% | 2.4% | No comparable |
| 8.2.5 | Violencia física severa por pareja/expareja | N.D. | N.D. | 1.2% | No comparable |
| 8.2.6 | Violencia sexual por agresor distinto a la pareja | N.D. | N.D. | 3.2% | No comparable |
| 8.2.12 | Acoso sexual por agresor distinto a la pareja | N.D. | N.D. | 3.0% | No comparable |
| 8.3.1 | Violencia interparental vivida por mujeres | N.D. | N.D. | 34.1% | No comparable |
| 8.3.16 | Mujeres bajo dependencia económica de su pareja/expareja | N.D. | N.D. | 28.6% | No comparable |
| 8.3.4 | Castigo físico/psicológico ejercido por la madre a niñas/os < 6 años | N.D. | N.D. | 29.7% | No comparable |

---

## Módulo CRS02 – Hombres y mujeres de 18 años a más

| Código | Indicador | 2015 | 2019 | 2024 | Nota de comparabilidad |
|--------|-----------|-------|--------|--------|---------------------------|
| 8.3.2 | Hombres que vivieron violencia interparental | N.D. | N.D. | 34.0% | No comparable |
| 8.3.7 | Hombres que justifican la violación sexual contra las mujeres | N.D. | N.D. | 56.5% | No comparable (crítico) |
| 8.3.12 | Personas que toleran la violencia contra las mujeres | N.D. | N.D. | 75.7% | No comparable (crítico) |
| 8.3.13 | Hombres que justifican la violencia sexual contra las mujeres | N.D. | N.D. | 69.7% | No comparable (crítico) |
| 8.3.14 | Creencias sexistas aprobadas | N.D. | N.D. | 87.4% | No comparable (crítico) |
| 8.3.15 | Actitudes sexistas aprobadas | N.D. | N.D. | 71.3% | No comparable (crítico) |

---

## Módulo CRS03 – Niñas y niños de 9 a 11 años

| Código | Indicador | 2015 | 2019 | 2024 | Nota de comparabilidad |
|--------|-----------|-------|--------|--------|---------------------------|
| 8.3.5 | Violencia física/psicológica ejercida por madre/padre | 41.5% | 38.7% | 45.9% | Comparable con ajustes 2024 |
| 8.3.8 | Violencia escolar (víctimas) | 50.1% | 47.4% | 44.0% | Comparable, revisar agresor de otro colegio |
| 8.3.10 | Niñas/os que ejercen violencia escolar | N.D. | N.D. | 13.2% | No comparable |

---

## Módulo CRS04 – Adolescentes de 12 a 17 años

| Código | Indicador | 2015 | 2019 | 2024 | Nota de comparabilidad |
|--------|-----------|-------|--------|--------|---------------------------|
| 8.2.7 | Violencia sexual (agresor no pareja) | N.D. | N.D. | 22.4% | No comparable |
| 8.2.11 | Violencia sexual antes de los 12 años | N.D. | N.D. | 15.2% | No comparable |
| 8.2.13 | Acoso sexual (agresor no pareja) | N.D. | N.D. | 21.7% | No comparable |
| 8.3.6 | Violencia física/psicológica ejercida por madre/padre | 38.9% | 40.5% | 43.6% | Comparable con ajustes 2024 |
| 8.3.9 | Adolescentes víctimas de violencia escolar | 47.4% | 44.7% | 45.9% | Comparable con ajustes 2024 |
| 8.3.11 | Adolescentes hombres que ejercen violencia escolar | N.D. | N.D. | 19.0% | No comparable |


---

## ⚙️ Cómo usar las sintaxis

1. Abrir **Stata 16+**.  
2. Configurar la ruta de trabajo (`global root`).  
3. Ejecutar el archivo `.do` del módulo CRS correspondiente.  
4. Los resultados se guardan automáticamente en `/outputs/`.  
5. Puedes combinar las bases para generar tablas o dashboards.

---

## 📈 Visualización interactiva

Consulta los resultados en Power BI:  
👉 **[Tablero de Indicadores ENARES 2024 – PPoR 1002](https://app.powerbi.com/view?r=eyJrIjoiZDE4ZDg4MjAtNzRjMC00MGY5LTk3MjAtNGRhOTAxNDQ2NGNiIiwidCI6IjY4MTljNDYzLTVkZWItNDA3MC1hY2I2LTlmZGQzY2FhZTk4NCJ9)**  

---

## 🧠 Metodología base

- **Fuente:** ENARES 2024 – INEI  
- **Periodo de referencia:** Últimos 12 meses (excepto violencia antes de los 12 años)  
- **Cobertura:** Nacional, urbano/rural y departamental  
- **Unidades de análisis:** Mujeres (18+), hombres (18+), niñas/os (9–11), adolescentes (12–17)  
- **Ponderación:** Factor de expansión `fac_pob`

---

## 📚 Referencias

- **INEI (2025)** – *Informe de los Principales Resultados de la ENARES 2024.*  
- **MIMP (2025)** – *Programa Presupuestal orientado en Resultados: Reducción de la Violencia contra la Mujer.*  
- **Ley 30364** – Ley para prevenir, sancionar y erradicar la violencia contra las mujeres y los integrantes del grupo familiar.  

---

## 💬 Frase que nos guía

> “Los datos no solo describen la violencia: ayudan a prevenirla.”  
> — *Alexandra Otero Flores* 🌸

---
