/**************************************************************************
 Proyecto : ENARES – Observatorio Nacional de Violencia
 Autora   : Alexandra Otero
 Fecha    : 09/08/25
 CUESTIONARIO CSR03 - NIÑAS Y NIÑOS DE 9 A 11 AÑOS
 Indicadores: 8.3.5, 8.3.8, 8.3.10
**************************************************************************/

*========================================================================*
* 0. Configuración de rutas
*========================================================================*
clear all
set maxvar 10000

* 1. Identificar usuario de la computadora
display "`c(username)'"

* Detectar el usuario activo y asignar directorio base
if "`c(username)'" == "dpvlv12" {
    global root "G:\Mi unidad\MIMP\Observatorio Nacional de Violencia\ENARES"
}
else if "`c(username)'" == "Alexandra Otero" {
    global root "G:\Mi unidad\MIMP\Observatorio Nacional de Violencia\ENARES"
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
global csr03_2024 "$data_2024/CSR03"

di as text "Root    : $root"
di as text "PPoR    : $ppor"
di as text "Outputs : $output"
di as text "Data24  : $csr03_2024"

*========================================================================*
* 1. Importación y estandarización
*========================================================================*
use "$csr03_2024/16_CRS03_CAP100.dta", clear
rename _all, lower
tempfile cap100
save `cap100'

use "$csr03_2024/17_CRS03_CAP200.dta", clear
rename _all, lower
tempfile cap200
save `cap200'

*========================================================================*
* 2. Consolidación de bases
*========================================================================*
use `cap200', clear
merge 1:1 id colegial_id ccdd ccpp ccdi codccpp using `cap100', keep(master match)
tab _merge
drop _merge

*========================================================================*
* 3. Recodificación de departamento (Lima)
*========================================================================*
gen departamento_rec = departamento
replace departamento_rec = "LIMA METROPOLITANA" ///
    if departamento == "LIMA" & provincia == "LIMA"
replace departamento_rec = "LIMA PROVINCIAS" ///
    if departamento == "LIMA" & provincia != "LIMA"

*========================================================================*
* 4. Definir etiquetas de valores generales
*========================================================================*
label define lbl_indicador 0 "No fueron víctimas" 1 "Sí fueron víctimas"
label define lbl_sino 0 "No" 1 "Sí"

*========================================================================*
* 5. INDICADOR 8.3.5: VIOLENCIA FÍSICA/PSICOLÓGICA POR MADRE/PADRE
*    (NIÑAS Y NIÑOS DE 9 A 11 AÑOS)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.5: VIOLENCIA POR MADRE/PADRE (9-11 AÑOS)"
di "{hline 80}"

*** 5.1 Componente: Violencia psicológica
gen violencia_psic = 0
label variable violencia_psic "Violencia psicológica"
label values violencia_psic lbl_sino

forvalues i = 1/11 {
    replace violencia_psic = 1 if c3p201_`i' == 1 & ///
        (inlist(c3p201a_`i', 1, 2, 3, 4, 19) | ///
         inlist(c3p201e_`i', 1, 2, 3, 4, 19) | ///
         (!inlist(c3p201a_`i', 1, 2, 3, 4, 19) & c3p201c_`i' == 1 & c3p201d_`i' == 1) | ///
         (!inlist(c3p201e_`i', 1, 2, 3, 4, 19) & c3p201f_`i' == 1)) ///
        & c3p203 == 1
}

*** 5.2 Componente: Violencia física
gen violencia_fis = 0
label variable violencia_fis "Violencia física"
label values violencia_fis lbl_sino

forvalues i = 1/7 {
    replace violencia_fis = 1 if c3p205_`i' == 1 & ///
        (inlist(c3p205a_`i', 1, 2, 3, 4, 19) | ///
         inlist(c3p205e_`i', 1, 2, 3, 4, 19) | ///
         (!inlist(c3p205a_`i', 1, 2, 3, 4, 19) & c3p205c_`i' == 1 & c3p205d_`i' == 1) | ///
         (!inlist(c3p205e_`i', 1, 2, 3, 4, 19) & c3p205f_`i' == 1)) ///
        & c3p207 == 1
}

*** 5.3 Componente: Violencia física por negligencia - Privación necesidades básicas
gen violencia_fis_01 = 0
label variable violencia_fis_01 "Violencia física por negligencia: Privación necesidades básicas"
label values violencia_fis_01 lbl_sino

replace violencia_fis_01 = 1 if c3p121 == 1

*** 5.4 Componente: Violencia física por negligencia - Falta supervisión/abandono
gen violencia_fis_02 = 0
label variable violencia_fis_02 "Violencia física por negligencia: Falta supervisión/abandono"
label values violencia_fis_02 lbl_sino

replace violencia_fis_02 = 1 if ///
    (c3p120b == 1 & inlist(c3p120c, 1, 2, 3, 4)) | ///
    (c3p120d1 == 1 & inlist(c3p120d2, 1, 2, 3, 4))

*** 5.5 Componente: Violencia física por negligencia - Desprotección familiar
gen violencia_fis_03 = 0
label variable violencia_fis_03 "Violencia física por negligencia: Desprotección familiar"
label values violencia_fis_03 lbl_sino

replace violencia_fis_03 = 1 if ///
    (c3p216a_1 == 1 & c3p216a_1c == 1) | ///
    (c3p216a_2 == 1 & c3p216a_2c == 1) | ///
    (c3p216a_3 == 1 & c3p216a_3c == 1) | ///
    (c3p216a_4 == 1 & c3p216a_4c == 1) | ///
    (c3p216a_5 == 1 & c3p216a_5c == 1) | ///
    (c3p216a_6 == 1 & c3p216a_6c == 1) | ///
    (c3p216c_1 == 1 & c3p216c_1c == 1) | ///
    (c3p216c_2 == 1 & c3p216c_2c == 1) | ///
    (c3p216c_3 == 1 & c3p216c_3c == 1) | ///
    (c3p216c_4 == 1 & c3p216c_4c == 1) | ///
    (c3p216c_5 == 1 & c3p216c_5c == 1)

*** 5.6 Indicador consolidado
gen indicador_8_3_5 = 0
label variable indicador_8_3_5 "Indicador 8.3.5: Violencia física/psicológica por madre/padre"

replace indicador_8_3_5 = 1 if ///
    violencia_psic == 1 | violencia_fis == 1 | ///
    violencia_fis_01 == 1 | violencia_fis_02 == 1 | violencia_fis_03 == 1

replace indicador_8_3_5 = 0 if missing(indicador_8_3_5)
label values indicador_8_3_5 lbl_indicador

*========================================================================*
* 6. INDICADOR 8.3.8: VIOLENCIA ESCOLAR RECIBIDA
*    (NIÑAS Y NIÑOS DE 9 A 11 AÑOS)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.8: VIOLENCIA ESCOLAR RECIBIDA (9-11 AÑOS)"
di "{hline 80}"

*** 6.1 Componente: Violencia psicológica escolar
gen violencia_psic_esc = 0
label variable violencia_psic_esc "Violencia psicológica escolar"
label values violencia_psic_esc lbl_sino

forvalues i = 1/14 {
    replace violencia_psic_esc = 1 if c3p223_`i' == 1 & ///
        (c3p223a_`i' == 1 | c3p223c_`i' == 1 | c3p223e_`i' == 1) ///
        & c3p225 == 1
}

*** 6.2 Componente: Violencia física escolar
gen violencia_fis_esc = 0
label variable violencia_fis_esc "Violencia física escolar"
label values violencia_fis_esc lbl_sino

forvalues i = 1/10 {
    replace violencia_fis_esc = 1 if c3p227_`i' == 1 & ///
        (c3p227a_`i' == 1 | c3p227c_`i' == 1 | c3p227e_`i' == 1) ///
        & c3p229 == 1
}

*** 6.3 Indicador consolidado
gen indicador_8_3_8 = 0
label variable indicador_8_3_8 "Indicador 8.3.8: Violencia escolar recibida"

replace indicador_8_3_8 = 1 if violencia_psic_esc == 1 | violencia_fis_esc == 1

replace indicador_8_3_8 = 0 if missing(indicador_8_3_8)
label values indicador_8_3_8 lbl_indicador

*========================================================================*
* 7. INDICADOR 8.3.10: VIOLENCIA ESCOLAR EJERCIDA
*    (NIÑAS Y NIÑOS DE 9 A 11 AÑOS)
*========================================================================*
di _n(2) "{hline 80}"
di "CALCULANDO INDICADOR 8.3.10: VIOLENCIA ESCOLAR EJERCIDA (9-11 AÑOS)"
di "{hline 80}"

*** Creación del indicador
gen indicador_8_3_10 = 0
label variable indicador_8_3_10 "Indicador 8.3.10: Violencia escolar ejercida"

replace indicador_8_3_10 = 1 if ///
    (c3p233_1 == 1 | c3p233_1a == 1 | ///
     c3p233_2 == 1 | c3p233_2a == 1 | ///
     c3p233_3 == 1) & c3p233a == 1

replace indicador_8_3_10 = 0 if missing(indicador_8_3_10)
label values indicador_8_3_10 lbl_indicador

*========================================================================*
* 8. Aplicar factor de expansión
*========================================================================*
svyset [pweight=factor_alumnos]

*========================================================================*
* 9. RESULTADOS DESCRIPTIVOS
*========================================================================*

*** Indicador 8.3.5: Violencia por Madre/Padre
di _n(2) "{hline 80}"
di "INDICADOR 8.3.5: VIOLENCIA FÍSICA/PSICOLÓGICA POR MADRE/PADRE"
di "{hline 80}"

** Componentes individuales
tab violencia_psic [iw=factor_alumnos], missing
tab violencia_fis [iw=factor_alumnos], missing
tab violencia_fis_01 [iw=factor_alumnos], missing
tab violencia_fis_02 [iw=factor_alumnos], missing
tab violencia_fis_03 [iw=factor_alumnos], missing

** Indicador consolidado
tab indicador_8_3_5 [iw=factor_alumnos], missing
svy: tab indicador_8_3_5, ci percent
svy: mean indicador_8_3_5
estat sd
svy: proportion indicador_8_3_5

*** Indicador 8.3.8: Violencia Escolar Recibida
di _n(2) "{hline 80}"
di "INDICADOR 8.3.8: VIOLENCIA ESCOLAR RECIBIDA"
di "{hline 80}"

** Componentes individuales
tab violencia_psic_esc [iw=factor_alumnos], missing
tab violencia_fis_esc [iw=factor_alumnos], missing

** Indicador consolidado
tab indicador_8_3_8 [iw=factor_alumnos], missing
svy: tab indicador_8_3_8, ci percent
svy: mean indicador_8_3_8
estat sd
svy: proportion indicador_8_3_8

*** Indicador 8.3.10: Violencia Escolar Ejercida
di _n(2) "{hline 80}"
di "INDICADOR 8.3.10: VIOLENCIA ESCOLAR EJERCIDA"
di "{hline 80}"

tab indicador_8_3_10 [iw=factor_alumnos], missing
svy: tab indicador_8_3_10, ci percent
svy: mean indicador_8_3_10
estat sd
svy: proportion indicador_8_3_10

*========================================================================*
* 10. Exportar base final
*========================================================================*
save "$output/base_indicadores_csr03_ninos_911_2024.dta", replace



*========================================================================*
* FIN DEL SCRIPT
*========================================================================*