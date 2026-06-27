/**************************************************************************
 Proyecto : ENARES 
 Autora   : Alexandra Otero
 Fecha    : 27(06/2026
 CUESTIONARIO CSR02 - HOMBRES Y MUJERES
 Indicadores: 8.3.2, 8.3.7, 8.3.12, 8.3.13, 8.3.14, 8.3.15
**************************************************************************/

*========================================================================*
* 0. Configuración de rutas
*========================================================================*
clear all
set maxvar 10000

* 1. Identificar usuario de la computadora
display "`c(username)'"

* Detectar el usuario activo y asignar directorio base
else if "`c(username)'" == "Alexandra Otero" {
    global root "G:\Mi unidad\ENARES"
}

display "Directorio de trabajo: $root"

* Carpeta base PPoR (dofiles/outputs)
global ppor    "$root/PPoR"
cap mkdir "$ppor"
global dofiles "$ppor/Do Files"
global output  "$ppor/Outputs"
cap mkdir "$dofiles"
cap mkdir "$output"

* Data se mantiene en ENARES/Data/2024/CSR01
global data_2024 "$root/Data/2024"
global csr02_2024 "$data_2024/CSR02"

di as text "Root    : $root"
di as text "PPoR    : $ppor"
di as text "Outputs : $output"
di as text "Data24  : $csr02_2024"


*========================================================================*
* 1. Importación y estandarización
*========================================================================*
use "$csr02_2024/12_CRS02_CAP200.dta", clear
rename _all, lower
tempfile cap200
save `cap200'

use "$csr02_2024/14_CRS02_CAP400.dta", clear
rename _all, lower
tempfile cap400
save `cap400'

*========================================================================*
* 2. Consolidación de bases
*========================================================================*
use `cap200', clear
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id ///
    using `cap400', keep(master match)
tab _merge
drop _merge

*========================================================================*
* 3. Variable FLAG (identificar base original)
*========================================================================*
gen flag = 1
label variable flag "Base original"

*========================================================================*
* 4. Recodificación de departamento (Lima)
*========================================================================*
gen departamento_rec = departamento
replace departamento_rec = "LIMA METROPOLITANA" ///
    if departamento == "LIMA" & provincia == "LIMA"
replace departamento_rec = "LIMA PROVINCIAS" ///
    if departamento == "LIMA" & provincia != "LIMA"

*========================================================================*
* 5. Definir etiquetas de valores generales
*========================================================================*
label define lbl_indicador 0 "No fueron víctimas" 1 "SÍ fueron víctimas"
label define lbl_sino 0 "No" 1 "Sí"

*========================================================================*
* 6. INDICADOR 8.3.2: VIOLENCIA INTERPARENTAL EN LA NIÑEZ (HOMBRES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.2: VIOLENCIA INTERPARENTAL EN LA NIÑEZ (HOMBRES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_2 = 0
label variable indicador_8_3_2 "Indicador 8.3.2: Violencia interparental niñez (hombres)"

replace indicador_8_3_2 = 1 if c1p207 == 1 & ///
    (c2p441a_4 == 1 | c2p441a_5 == 1 | c2p441a_6 == 1)

replace indicador_8_3_2 = 0 if missing(indicador_8_3_2)
label values indicador_8_3_2 lbl_indicador

*** Filtro: Base original y hombres
gen filter_832 = (flag == 1 & c1p207 == 1)
label variable filter_832 "FILTRO: Base original y hombres"
label values filter_832 lbl_sino

*========================================================================*
* 7. INDICADOR 8.3.7: JUSTIFICACIÓN VIOLACIÓN SEXUAL (HOMBRES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.7: JUSTIFICACIÓN VIOLACIÓN SEXUAL (HOMBRES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_7 = 0
label variable indicador_8_3_7 "Indicador 8.3.7: Justificación violación sexual (hombres)"

replace indicador_8_3_7 = 1 if c1p207 == 1 & ( ///
    inlist(c2p401_7, 3, 4) | ///
    inlist(c2p401_14, 3, 4) | ///
    inlist(c2p401_17, 3, 4) | ///
    inlist(c2p401_20, 3, 4))

replace indicador_8_3_7 = 0 if missing(indicador_8_3_7)
label values indicador_8_3_7 lbl_indicador

*** Filtro: Base original y hombres
gen filter_837 = (flag == 1 & c1p207 == 1)
label variable filter_837 "FILTRO: Base original y hombres"
label values filter_837 lbl_sino

*========================================================================*
* 8. INDICADOR 8.3.12: TOLERANCIA A LA VIOLENCIA (HOMBRES Y MUJERES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.12: TOLERANCIA A LA VIOLENCIA (HOMBRES Y MUJERES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_12 = 0
label variable indicador_8_3_12 "Indicador 8.3.12: Tolerancia violencia contra mujeres"

replace indicador_8_3_12 = 1 if ( ///
    inlist(c2p401_1, 3, 4) | ///
    inlist(c2p401_2, 3, 4) | ///
    inlist(c2p401_3, 1, 2) | ///
    inlist(c2p401_4, 1, 2) | ///
    inlist(c2p401_5, 3, 4) | ///
    inlist(c2p401_6, 3, 4) | ///
    inlist(c2p401_7, 3, 4) | ///
    inlist(c2p401_8, 3, 4) | ///
    inlist(c2p401_9, 3, 4) | ///
    inlist(c2p401_11, 3, 4) | ///
    inlist(c2p401_12, 3, 4) | ///
    inlist(c2p401_13, 3, 4) | ///
    inlist(c2p401_14, 3, 4) | ///
    inlist(c2p401_15, 3, 4) | ///
    inlist(c2p401_16, 1, 2) | ///
    inlist(c2p401_17, 3, 4) | ///
    inlist(c2p401_18, 3, 4) | ///
    inlist(c2p401_19, 3, 4) | ///
    inlist(c2p401_20, 3, 4) | ///
    inlist(c2p401_21, 3, 4) | ///
    inlist(c2p401_22, 3, 4))

replace indicador_8_3_12 = 0 if missing(indicador_8_3_12)
label values indicador_8_3_12 lbl_indicador

*** No se aplica filtro específico (hombres y mujeres)

*========================================================================*
* 9. INDICADOR 8.3.13: JUSTIFICACIÓN VIOLENCIA SEXUAL (HOMBRES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.13: JUSTIFICACIÓN VIOLENCIA SEXUAL (HOMBRES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_13 = 0
label variable indicador_8_3_13 "Indicador 8.3.13: Justificación violencia sexual (hombres)"

replace indicador_8_3_13 = 1 if c1p207 == 1 & ( ///
    inlist(c2p401_2, 3, 4) | ///
    inlist(c2p401_7, 3, 4) | ///
    inlist(c2p401_8, 3, 4) | ///
    inlist(c2p401_13, 3, 4) | ///
    inlist(c2p401_14, 3, 4) | ///
    inlist(c2p401_16, 1, 2) | ///
    inlist(c2p401_17, 3, 4) | ///
    inlist(c2p401_19, 3, 4) | ///
    inlist(c2p401_20, 3, 4) | ///
    inlist(c2p401_22, 3, 4))

replace indicador_8_3_13 = 0 if missing(indicador_8_3_13)
label values indicador_8_3_13 lbl_indicador

*** Filtro: Base original y hombres
gen filter_8313 = (flag == 1 & c1p207 == 1)
label variable filter_8313 "FILTRO: Base original y hombres"
label values filter_8313 lbl_sino

*========================================================================*
* 10. INDICADOR 8.3.14: APROBACIÓN CREENCIAS SEXISTAS (HOMBRES Y MUJERES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.14: APROBACIÓN CREENCIAS SEXISTAS (HOMBRES Y MUJERES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_14 = 0
label variable indicador_8_3_14 "Indicador 8.3.14: Aprobación creencias sexistas"

replace indicador_8_3_14 = 1 if ( ///
    inlist(c2p401_10, 3, 4) | ///
    inlist(c2p401a_1, 3, 4) | ///
    inlist(c2p401a_2, 3, 4) | ///
    inlist(c2p401a_3, 3, 4) | ///
    inlist(c2p401a_4, 3, 4) | ///
    inlist(c2p401a_5, 3, 4) | ///
    inlist(c2p401a_6, 3, 4) | ///
    inlist(c2p401a_7, 3, 4) | ///
    inlist(c2p401a_8, 3, 4) | ///
    inlist(c2p401a_9, 3, 4) | ///
    inlist(c2p401a_10, 3, 4))

replace indicador_8_3_14 = 0 if missing(indicador_8_3_14)
label values indicador_8_3_14 lbl_indicador

*** No se aplica filtro específico (hombres y mujeres)

*========================================================================*
* 11. INDICADOR 8.3.15: APROBACIÓN ACTITUDES SEXISTAS (HOMBRES Y MUJERES)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.15: APROBACIÓN ACTITUDES SEXISTAS (HOMBRES Y MUJERES)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_15 = 0
label variable indicador_8_3_15 "Indicador 8.3.15: Aprobación actitudes sexistas"

replace indicador_8_3_15 = 1 if ( ///
    inlist(c2p401a_11, 3, 4) | ///
    inlist(c2p401a_12, 3, 4) | ///
    inlist(c2p401a_13, 3, 4) | ///
    inlist(c2p401a_14, 3, 4) | ///
    inlist(c2p401a_15, 3, 4))

replace indicador_8_3_15 = 0 if missing(indicador_8_3_15)
label values indicador_8_3_15 lbl_indicador

*** No se aplica filtro específico (hombres y mujeres)

*========================================================================*
* 12. Aplicar factor de expansión
*========================================================================*
svyset [pweight=factor_hym]

*========================================================================*
* 13. RESULTADOS DESCRIPTIVOS
*========================================================================*

*** Indicador 8.3.2: Violencia Interparental en la Niñez (Hombres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.2: VIOLENCIA INTERPARENTAL EN LA NIÑEZ (HOMBRES)"
di "{hline 80}"
svy, subpop(if filter_832==1): tab indicador_8_3_2, ci percent
svy, subpop(if filter_832==1): mean indicador_8_3_2
svy, subpop(if filter_832==1): proportion indicador_8_3_2

*** Indicador 8.3.7: Justificación Violación Sexual (Hombres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.7: JUSTIFICACIÓN VIOLACIÓN SEXUAL (HOMBRES)"
di "{hline 80}"
svy, subpop(if filter_837==1): tab indicador_8_3_7, ci percent
svy, subpop(if filter_837==1): mean indicador_8_3_7
svy, subpop(if filter_837==1): proportion indicador_8_3_7

*** Indicador 8.3.12: Tolerancia a la Violencia (Hombres y Mujeres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.12: TOLERANCIA A LA VIOLENCIA (HOMBRES Y MUJERES)"
di "{hline 80}"
svy: tab indicador_8_3_12, ci percent
svy: mean indicador_8_3_12
svy: proportion indicador_8_3_12

*** Indicador 8.3.13: Justificación Violencia Sexual (Hombres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.13: JUSTIFICACIÓN VIOLENCIA SEXUAL (HOMBRES)"
di "{hline 80}"
svy, subpop(if filter_8313==1): tab indicador_8_3_13, ci percent
svy, subpop(if filter_8313==1): mean indicador_8_3_13
svy, subpop(if filter_8313==1): proportion indicador_8_3_13

*** Indicador 8.3.14: Aprobación Creencias Sexistas (Hombres y Mujeres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.14: APROBACIÓN CREENCIAS SEXISTAS (HOMBRES Y MUJERES)"
di "{hline 80}"
svy: tab indicador_8_3_14, ci percent
svy: mean indicador_8_3_14
svy: proportion indicador_8_3_14

*** Indicador 8.3.15: Aprobación Actitudes Sexistas (Hombres y Mujeres)
di _n(2) "{hline 80}"
di "INDICADOR 8.3.15: APROBACIÓN ACTITUDES SEXISTAS (HOMBRES Y MUJERES)"
di "{hline 80}"
svy: tab indicador_8_3_15, ci percent
svy: mean indicador_8_3_15
svy: proportion indicador_8_3_15

*========================================================================*
* 14. Exportar base final
*========================================================================*
save "$output/base_indicadores_csr02_hombres_mujeres_2024.dta", replace


*========================================================================*
* FIN DEL SCRIPT
*========================================================================*
