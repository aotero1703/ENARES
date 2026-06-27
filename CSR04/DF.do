/**************************************************************************
 Proyecto : ENARES
 Autora   : Alexandra Otero
 Fecha    : 09/11/2025
 Objetivo : Integrar CAP100+CAP200+CAP248, crear indicadores y guardar base
 Salida   : Outputs/base_indicadores_csr04_adolescentes_2024.dta
**************************************************************************/

clear all
set more off
version 16

display "Usuario activo: `c(username)'"
if "`c(username)'" == "vanessa" {
    global root "G:\Mi unidad\ENARES"
}
else if ("`c(username)'" == "Alexandra Otero") {
    global root "G:\Mi unidad\ENARES"
}
else {
    global root "G:\Mi unidad\ENARES"
}

* Carpeta base PPoR (dofiles/outputs)
global ppor    "$root/PPoR"
cap mkdir "$ppor"
global dofiles "$ppor/Do Files"
global output  "$ppor/Outputs"
cap mkdir "$dofiles"
cap mkdir "$output"

* Global de data 
global data_2024 "$root/Data/2024"
global csr04_2024 "$data_2024/CSR04"

di as text "Root    : $root"
di as text "PPoR    : $ppor"
di as text "Outputs : $output"
di as text "Data24  : $csr04_2024"

*-------------------------------*
* 1) Cargar y estandarizar caps
*-------------------------------*
use "$csr04_2024/20_CRS04_CAP200.dta", clear
rename _all, lower
tempfile cap200
save `cap200', replace

use "$csr04_2024/19_CRS04_CAP100.dta", clear
rename _all, lower
tempfile cap100
save `cap100', replace

use "$csr04_2024/21_CRS04_CAP248.dta", clear
rename _all, lower
tempfile cap248
save `cap248', replace

*-------------------------------*
* 2) Integrar CAPS en una sola
*-------------------------------*
use `cap200', clear

merge 1:1 id colegial_id ccdd ccpp ccdi codccpp using `cap100', keep(master match) nogen
merge 1:1 id colegial_id ccdd ccpp ccdi codccpp using `cap248', keep(master match) nogen

*---------------------------------------*
* 3) Variables demográficas y de contexto
*---------------------------------------*
* Edad (12–17)
gen byte edad_std = .
capture confirm variable edad
if !_rc replace edad_std = edad
else {
    capture confirm variable c3p101
    if !_rc replace edad_std = c3p101
}

* Sexo estandarizado: 1=Mujer, 2=Hombre
gen byte sexo_std = .
capture confirm variable sexo
if !_rc {
    replace sexo_std = sexo                          // asume 1=Mujer, 2=Hombre
}
else {
    capture confirm variable c3p102                  // suele ser 1=Hombre, 2=Mujer
    if !_rc replace sexo_std = cond(c3p102==2,1,cond(c3p102==1,2,.))
}

* Área (si existe)
capture drop area_rec
capture confirm variable area
if !_rc {
    gen byte area_rec = area
    label define lbl_area 1 "Urbano" 2 "Rural", replace
    label values area_rec lbl_area
}

* Nivel educativo (si existe c3p103)
capture drop nivel_educ
capture confirm variable c3p103
if !_rc {
    gen byte nivel_educ = .
    replace nivel_educ = 2 if inlist(c3p103,3,4,5,6)   // Primaria
    replace nivel_educ = 3 if inlist(c3p103,1,2)       // Secundaria
    label define lbl_ne 2 "2 Primaria" 3 "3 Secundaria", replace
    label values nivel_educ lbl_ne
}

* Departamento recod (Lima M/Lima Región)
capture drop departamento_rec
capture confirm variable departamento
if !_rc {
    gen strL departamento_rec = departamento
    capture confirm variable provincia
    if !_rc {
        replace departamento_rec = "LIMA METROPOLITANA" if departamento=="LIMA" & provincia=="LIMA"
        replace departamento_rec = "LIMA PROVINCIAS"        if departamento=="LIMA" & provincia!="LIMA"
    }
}

* Factor (si viene con otro nombre, ajústalo aquí)
capture confirm variable factor_alumnos
if _rc {
    di as result "(Aviso) No se encontró factor_alumnos."
}

*---------------------------------------*
* 4) Filtro universo adolescentes 12–17
*---------------------------------------*
keep if inrange(edad_std,12,17)

*---------------------------------------*
* 5) Indicadores (NOMBRES FINALES que usa el exportador)
*     - indicador_8_3_6
*     - indicador_8_3_9
*     - indicador_8_2_7  (solo mujeres)
*     - indicador_8_2_13 (solo mujeres)
*     - indicador_8_2_11 (solo mujeres)
*     - indicador_8_3_11 (solo hombres)
*---------------------------------------*

label define lbl_vict 0 "No fueron víctimas" 1 "Sí fueron víctimas", replace

* -------- 8.3.6: Violencia física/psicológica de padres --------
gen byte v_psic_836 = 0
forvalues i=1/11 {
    capture confirm variable c3p201_`i'
    if !_rc replace v_psic_836 = 1 if c3p201_`i'==1 & c3p203==1 & ///
        ( inlist(c3p201a_`i',1,2,3,4,19) | inlist(c3p201e_`i',1,2,3,4,19) | ///
          (!inlist(c3p201a_`i',1,2,3,4,19) & c3p201c_`i'==1 & c3p201d_`i'==1) | ///
          (!inlist(c3p201e_`i',1,2,3,4,19) & c3p201f_`i'==1) )
}

gen byte v_fis_836 = 0
forvalues i=1/7 {
    capture confirm variable c3p205_`i'
    if !_rc replace v_fis_836 = 1 if c3p205_`i'==1 & c3p207==1 & ///
        ( c3p205a_`i'==1 | c3p205c_`i'==1 | c3p205e_`i'==1 | c3p205d_`i'==1 | c3p205f_`i'==1 )
}

gen byte v_fis_priv_836 = 0
capture confirm variable c3p121
if !_rc replace v_fis_priv_836 = 1 if c3p121==1

gen byte v_fis_negl_836 = 0
forvalues i=1/6 {
    capture confirm variable c3p216a_`i'
    if !_rc replace v_fis_negl_836 = 1 if c3p216a_`i'==1 & c3p216a_`i'c==1
}
forvalues i=1/5 {
    capture confirm variable c3p216c_`i'
    if !_rc replace v_fis_negl_836 = 1 if c3p216c_`i'==1 & c3p216c_`i'c==1
}

gen byte indicador_8_3_6 = (v_psic_836==1 | v_fis_836==1 | v_fis_priv_836==1 | v_fis_negl_836==1)
label var indicador_8_3_6 "8.3.6 Violencia de padres (fís/psic) contra adolescentes"
label values indicador_8_3_6 lbl_vict

* -------- 8.3.9: Violencia escolar sufrida --------
gen byte v_psic_839 = 0
forvalues i=1/14 {
    capture confirm variable c3p223_`i'
    if !_rc replace v_psic_839 = 1 if c3p223_`i'==1 & c3p225==1 & ///
        inlist(1, c3p223a_`i', c3p223c_`i', c3p223e_`i')
}

gen byte v_fis_839 = 0
forvalues i=1/10 {
    capture confirm variable c3p227_`i'
    if !_rc replace v_fis_839 = 1 if c3p227_`i'==1 & c3p229==1 & ///
        inlist(1, c3p227a_`i', c3p227c_`i', c3p227e_`i')
}

gen byte v_sex_839 = 0
forvalues i=1/16 {
    capture confirm variable c4p248_`i'
    if !_rc replace v_sex_839 = 1 if c4p248_`i'==1 & c4p248c_`i'==1 & ///
        (c4p248a_27_`i'==1 | c4p248a_28_`i'==1)
}

gen byte indicador_8_3_9 = (v_psic_839==1 | v_fis_839==1 | v_sex_839==1)
label var indicador_8_3_9 "8.3.9 Violencia escolar sufrida"
label values indicador_8_3_9 lbl_vict

* -------- 8.2.7: Violencia sexual NO pareja (mujeres) --------
gen byte indicador_8_2_7 = 0
forvalues i=1/16 {
    capture confirm variable c4p248_`i'
    if !_rc replace indicador_8_2_7 = 1 if sexo_std==1 & c4p248_`i'==1 & c4p248a_26_`i'!=1 & c4p248c_`i'==1
}
label var indicador_8_2_7 "8.2.7 Violencia sexual (NO pareja) - mujeres"
label values indicador_8_2_7 lbl_vict

* -------- 8.2.13: Acoso sexual NO pareja (mujeres) --------
gen byte indicador_8_2_13 = 0
local items_acoso "1 2 3 4 6 7 9 13 14"
foreach i of local items_acoso {
    capture confirm variable c4p248_`i'
    if !_rc replace indicador_8_2_13 = 1 if sexo_std==1 & c4p248_`i'==1 & c4p248a_26_`i'!=1 & c4p248c_`i'==1
}
capture confirm variable c4p248_o_12
if !_rc {
    replace indicador_8_2_13 = 1 if sexo_std==1 & upper(c4p248_o_12)=="ACOSO SEXUAL" & c4p248a_26_12!=1 & c4p248c_12==1
}
label var indicador_8_2_13 "8.2.13 Acoso sexual (NO pareja) - mujeres"
label values indicador_8_2_13 lbl_vict

* -------- 8.2.11: Violación sexual antes de los 12 (mujeres) --------
gen byte indicador_8_2_11 = .
replace indicador_8_2_11 = 0 if sexo_std==1
forvalues i=1/16 {
    capture confirm variable c4p248_`i'
    if !_rc replace indicador_8_2_11 = 1 if sexo_std==1 & c4p248_`i'==1 & c4p248a_26_`i'!=1 & c4p248b_`i'<12
}
label var indicador_8_2_11 "8.2.11 Violación antes de los 12 - mujeres"
label values indicador_8_2_11 lbl_vict

* -------- 8.3.11: Hombres que ejercen violencia escolar --------
gen byte indicador_8_3_11 = 0
capture confirm variable c3p233a
if !_rc replace indicador_8_3_11 = 1 if sexo_std==2 & c3p233a==1 & ///
    (c3p233_1==1 | c3p233_1a==1 | c3p233_2==1 | c3p233_2a==1 | c3p233_3==1)
label var indicador_8_3_11 "8.3.11 Hombres que ejercen violencia escolar"
label values indicador_8_3_11 lbl_vict

*---------------------------------------*
* 6) Mantener solo campos necesarios
*---------------------------------------*
keep id colegial_id ccdd ccpp ccdi codccpp ///
     edad_std sexo_std area_rec nivel_educ departamento_rec ///
     factor_alumnos ///
     indicador_8_3_6 indicador_8_3_9 indicador_8_2_7 indicador_8_2_13 indicador_8_2_11 indicador_8_3_11

order id colegial_id edad_std sexo_std departamento_rec area_rec nivel_educ factor_alumnos ///
      indicador_8_3_6 indicador_8_3_9 indicador_8_2_7 indicador_8_2_13 indicador_8_2_11 indicador_8_3_11

label var edad_std "Edad (años)"
label var sexo_std "Sexo (1 Mujer / 2 Hombre)"

*---------------------------------------*
* 7) Guardar base integrada
*---------------------------------------*
save "$output/base_indicadores_csr04_adolescentes_2024.dta", replace

di as result _n "✓ Base integrada guardada en:"
di as result      "$output/base_indicadores_csr04_adolescentes_2024.dta"

tab indicador_8_3_6 [iw=factor_alumnos], missing

svyset: tab indicador_8_3_6, ci percent
svyset: mean indicador_8_3_6
estat sd
svyset: proportion indicador_8_3_6


