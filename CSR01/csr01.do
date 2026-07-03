/**************************************************************************
 Proyecto : ENARES – Observatorio Nacional de Violencia (CSR01)
 Autora   : Alexandra Otero
 Fecha    : 09/11/2025
 Versión  : CONSOLIDADO — Base principal (mujeres) + Base niños 8.3.4
 Notas    : - Rutas de trabajo en ENARES/PPoR (dofiles/outputs)
           - Data se mantiene en ENARES/Data/2024/CSR01
           - Guarda dos .dta:
               1) $output/base_indicadores_csr01_mujeres_2024.dta
               2) $output/base_indicadores_csr01_ninos72m_2024.dta
           - CORRECCIÓN APLICADA: Indicador 8.3.16 (Dependencia económica)
**************************************************************************/

*========================================================================*
* 0) CONFIGURACIÓN DE RUTAS (PPoR)
*========================================================================*
clear all
set more off
set maxvar 10000
version 16

gl root "SE COLOCA LA RUTA"

* Carpeta base PPoR (dofiles/outputs)
global ppor    "$root/PPoR"
cap mkdir "$ppor"
global dofiles "$ppor/Do Files"
global output  "$ppor/Outputs"
cap mkdir "$dofiles"
cap mkdir "$output"

* Data se mantiene en ENARES/Data/2024/CSR01
global data_2024 "$root/Data/2024"
global csr01_2024 "$data_2024/CSR01"

di as text "Root    : $root"
di as text "PPoR    : $ppor"
di as text "Outputs : $output"
di as text "Data24  : $csr01_2024"

*========================================================================*
* 1) IMPORTACIÓN Y ESTANDARIZACIÓN (CSR01)
*========================================================================*
use "$csr01_2024/02_CRS01_CAP200.dta", clear
rename _all, lower
tempfile cap200
save `cap200'

use "$csr01_2024/03_CRS01_CAP300.dta", clear
rename _all, lower
tempfile cap300
save `cap300'

use "$csr01_2024/04_CRS01_CAP400.dta", clear
rename _all, lower
tempfile cap400
save `cap400'

use "$csr01_2024/05_CRS01_CAP402.dta", clear
rename _all, lower
tempfile cap402
save `cap402'

use "$csr01_2024/06_CRS01_CAP405.dta", clear
rename _all, lower
tempfile cap405
save `cap405'

use "$csr01_2024/07_CRS01_CAP411.dta", clear
rename _all, lower
tempfile cap411
save `cap411'

*========================================================================*
* 2) CONSOLIDACIÓN DE BASES
*    Claves: conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id
*========================================================================*
*global keyvars_csr01 "conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id"
use `cap300', clear
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap200', keep(master match) nogen
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap402', keep(master match) nogen
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap405', keep(master match) nogen
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap411', keep(master match) nogen
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap400', keep(master match)
tab _merge
drop _merge

*========================================================================*
* 3) RECODIFICACIONES BÁSICAS (dpto/estado civil)
*========================================================================*
capture drop departamento_rec
gen departamento_rec = departamento
replace departamento_rec = "LIMA METROPOLITANA" if departamento=="LIMA" & provincia=="LIMA"
replace departamento_rec = "LIMA PROVINCIAS"    if departamento=="LIMA" & provincia!="LIMA"

* Estado civil consolidado: 1 Act. unida / 2 Ant. unida / 3 Soltera
capture drop c1p302_n
gen c1p302_n = c1p302
recode c1p302_n (1/2=1) (3/5=2) (6=3)
label define lbl_c1p302_n 1 "Mujer actualmente unida" 2 "Mujer anteriormente unida" 3 "Mujer soltera", replace
label values c1p302_n lbl_c1p302_n
label var c1p302_n "Estado civil (consolidado)"

* Etiquetas genéricas
label define lbl_indicador 0 "No fueron víctimas" 1 "SÍ fueron víctimas", replace
label define lbl_sino 0 "No" 1 "Sí", replace

*========================================================================*
* 4) INDICADORES DE MUJERES — 8.2.1 / 8.2.2 / 8.2.3 / 8.2.5 / 8.2.6 / 8.2.12
*    + 8.3.1 (interparental) + 8.3.16 (dependencia económica)
*========================================================================*

* ---------- 8.2.1: Violencia psicológica ----------
gen violencia_psic_m_act_unida = 0
label var violencia_psic_m_act_unida "Violencia psicológica: Mujer actualmente unida"
label values violencia_psic_m_act_unida lbl_sino
forvalues i=1/20 {
    replace violencia_psic_m_act_unida = 1 if c1p302_n==1 & c1p402_`i'==1 & c1p402a_`i'==1
}
forvalues i=1/14 {
    replace violencia_psic_m_act_unida = 1 if c1p302_n==1 & c1p412_`i'==1 & c1p412a_5_`i'==1 & c1p412c_`i'==1
}

gen violencia_psic_m_ant_unida = 0
label var violencia_psic_m_ant_unida "Violencia psicológica: Mujer anteriormente unida"
label values violencia_psic_m_ant_unida lbl_sino
forvalues i=1/20 {
    replace violencia_psic_m_ant_unida = 1 if c1p302_n==2 & c1p419_`i'==1 & c1p419a_`i'==1
}
forvalues i=1/14 {
    replace violencia_psic_m_ant_unida = 1 if c1p302_n==2 & c1p429_`i'==1 & (c1p429a_5_`i'==1 | c1p429a_24_`i'==1) & c1p429c_`i'==1
}

gen violencia_psic_m_sol_cpareja = 0
label var violencia_psic_m_sol_cpareja "Violencia psicológica: Mujer soltera con pareja actual"
label values violencia_psic_m_sol_cpareja lbl_sino
forvalues i=1/14 {
    replace violencia_psic_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p434b_`i'==1 & c1p434c_`i'==1
}
forvalues i=1/12 {
    replace violencia_psic_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p436_`i'==1 & c1p436a_5_`i'==1 & c1p436c_`i'==1
}

gen violencia_psic_m_sol_spareja = 0
label var violencia_psic_m_sol_spareja "Violencia psicológica: Mujer soltera sin pareja actual"
label values violencia_psic_m_sol_spareja lbl_sino
forvalues i=1/12 {
    replace violencia_psic_m_sol_spareja = 1 if c1p302_n==3 & c1p434a==2 & c1p436_`i'==1 & c1p436a_5_`i'==1 & c1p436c_`i'==1
}

gen indicador_8_2_1 = 0
replace indicador_8_2_1 = 1 if violencia_psic_m_act_unida==1 | violencia_psic_m_ant_unida==1 | ///
                             violencia_psic_m_sol_cpareja==1 | violencia_psic_m_sol_spareja==1
label var indicador_8_2_1 "Indicador 8.2.1: Violencia psicológica"
label values indicador_8_2_1 lbl_indicador

* ---------- 8.2.2: Violencia física (cualquier tipo) ----------
gen violencia_fisica_m_act_unida = 0
label var violencia_fisica_m_act_unida "Violencia física: Mujer actualmente unida"
label values violencia_fisica_m_act_unida lbl_sino
forvalues i=1/15 {
    replace violencia_fisica_m_act_unida = 1 if c1p302_n==1 & c1p404_`i'==1 & c1p404a_`i'==1
}
forvalues i=1/15 {
    replace violencia_fisica_m_act_unida = 1 if c1p302_n==1 & c1p411_`i'==1 & c1p411a_5_`i'==1 & c1p411c_`i'==1
}

gen violencia_fisica_m_ant_unida = 0
label var violencia_fisica_m_ant_unida "Violencia física: Mujer anteriormente unida"
label values violencia_fisica_m_ant_unida lbl_sino
forvalues i=1/15 {
    replace violencia_fisica_m_ant_unida = 1 if c1p302_n==2 & c1p421_`i'==1 & c1p421a_`i'==1
}
forvalues i=1/15 {
    replace violencia_fisica_m_ant_unida = 1 if c1p302_n==2 & c1p428_`i'==1 & (c1p428a_5_`i'==1 | c1p428a_24_`i'==1) & c1p428c_`i'==1
}

gen violencia_fisica_m_sol_cpareja = 0
label var violencia_fisica_m_sol_cpareja "Violencia física: Mujer soltera con pareja actual"
label values violencia_fisica_m_sol_cpareja lbl_sino
forvalues i=1/15 {
    replace violencia_fisica_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p434e_`i'==1 & c1p434f_`i'==1
}
forvalues i=1/15 {
    replace violencia_fisica_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p435_`i'==1 & c1p435a_5_`i'==1 & c1p435c_`i'==1
}

gen violencia_fisica_m_sol_spareja = 0
label var violencia_fisica_m_sol_spareja "Violencia física: Mujer soltera sin pareja actual"
label values violencia_fisica_m_sol_spareja lbl_sino
forvalues i=1/15 {
    replace violencia_fisica_m_sol_spareja = 1 if c1p302_n==3 & c1p434a==2 & c1p435_`i'==1 & c1p435a_5_`i'==1 & c1p435c_`i'==1
}

gen indicador_8_2_2 = 0
replace indicador_8_2_2 = 1 if violencia_fisica_m_act_unida==1 | violencia_fisica_m_ant_unida==1 | ///
                             violencia_fisica_m_sol_cpareja==1 | violencia_fisica_m_sol_spareja==1
label var indicador_8_2_2 "Indicador 8.2.2: Violencia física"
label values indicador_8_2_2 lbl_indicador

* ---------- 8.2.3: Violencia sexual por pareja ----------
gen viol_sexpareja_m_act_unida = 0
label var viol_sexpareja_m_act_unida "Violencia sexual por pareja: Mujer actualmente unida"
label values viol_sexpareja_m_act_unida lbl_sino
forvalues i=1/12 {
    replace viol_sexpareja_m_act_unida = 1 if c1p302_n==1 & c1p414_`i'==1 & c1p414a_`i'==1
}
forvalues i=1/20 {
    replace viol_sexpareja_m_act_unida = 1 if c1p302_n==1 & c1p415_`i'==1 & c1p415a_5_`i'==1 & c1p415c_`i'==1
}

gen viol_sexpareja_m_ant_unida = 0
label var viol_sexpareja_m_ant_unida "Violencia sexual por pareja: Mujer anteriormente unida"
label values viol_sexpareja_m_ant_unida lbl_sino
forvalues i=1/12 {
    replace viol_sexpareja_m_ant_unida = 1 if c1p302_n==2 & c1p431_`i'==1 & c1p431a_`i'==1
}
forvalues i=1/20 {
    replace viol_sexpareja_m_ant_unida = 1 if c1p302_n==2 & c1p432_`i'==1 & (c1p432a_5_`i'==1 | c1p432a_24_`i'==1) & c1p432c_`i'==1
}

gen viol_sexpareja_m_sol_cpareja = 0
label var viol_sexpareja_m_sol_cpareja "Violencia sexual por pareja: Mujer soltera con pareja actual"
label values viol_sexpareja_m_sol_cpareja lbl_sino
forvalues i=1/12 {
    replace viol_sexpareja_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p438_`i'==1 & c1p438a_`i'==1
}
forvalues i=1/20 {
    replace viol_sexpareja_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p439_`i'==1 & c1p439a_5_`i'==1 & c1p439c_`i'==1
}

gen viol_sexpareja_m_sol_spareja = 0
label var viol_sexpareja_m_sol_spareja "Violencia sexual por pareja: Mujer soltera sin pareja actual"
label values viol_sexpareja_m_sol_spareja lbl_sino
forvalues i=1/20 {
    replace viol_sexpareja_m_sol_spareja = 1 if c1p302_n==3 & c1p434a==2 & c1p439_`i'==1 & c1p439a_5_`i'==1 & c1p439c_`i'==1
}

gen indicador_8_2_3 = 0
replace indicador_8_2_3 = 1 if viol_sexpareja_m_act_unida==1 | viol_sexpareja_m_ant_unida==1 | ///
                             viol_sexpareja_m_sol_cpareja==1 | viol_sexpareja_m_sol_spareja==1
label var indicador_8_2_3 "Indicador 8.2.3: Violencia sexual (por pareja)"
label values indicador_8_2_3 lbl_indicador

* ---------- 8.2.5: Violencia física severa ----------
gen violencia_fissev_m_act_unida = 0
label var violencia_fissev_m_act_unida "Violencia física severa: Mujer actualmente unida"
label values violencia_fissev_m_act_unida lbl_sino
forvalues i=12/14 {
    replace violencia_fissev_m_act_unida = 1 if c1p302_n==1 & c1p404_`i'==1 & c1p404a_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_act_unida = 1 if c1p302_n==1 & c1p405_`i'==1 & c1p405a_`i'==1 & c1p405d_`i'==1
}
forvalues i=12/14 {
    replace violencia_fissev_m_act_unida = 1 if c1p302_n==1 & c1p411_`i'==1 & c1p411a_5_`i'==1 & c1p411c_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_act_unida = 1 if c1p302_n==1 & c1p411e_`i'==1 & c1p411f_`i'==1 & c1p411g_`i'==1
}

gen violencia_fissev_m_ant_unida = 0
label var violencia_fissev_m_ant_unida "Violencia física severa: Mujer anteriormente unida"
label values violencia_fissev_m_ant_unida lbl_sino
forvalues i=12/14 {
    replace violencia_fissev_m_ant_unida = 1 if c1p302_n==2 & c1p421_`i'==1 & c1p421a_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_ant_unida = 1 if c1p302_n==2 & c1p422_`i'==1 & c1p422a_`i'==1 & c1p422d_`i'==1
}
forvalues i=12/14 {
    replace violencia_fissev_m_ant_unida = 1 if c1p302_n==2 & c1p428_`i'==1 & (c1p428a_5_`i'==1 | c1p428a_24_`i'==1) & c1p428c_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_ant_unida = 1 if c1p302_n==2 & c1p428e_`i'==1 & c1p428f_`i'==1 & c1p428g_`i'==1
}

gen violencia_fissev_m_sol_cpareja = 0
label var violencia_fissev_m_sol_cpareja "Violencia física severa: Mujer soltera con pareja actual"
label values violencia_fissev_m_sol_cpareja lbl_sino
forvalues i=12/14 {
    replace violencia_fissev_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p434e_`i'==1 & c1p434f_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p434h_`i'==1 & c1p434i_`i'==1 & c1p434l_`i'==1
}
forvalues i=12/14 {
    replace violencia_fissev_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p435_`i'==1 & c1p435a_5_`i'==1 & c1p435c_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_sol_cpareja = 1 if c1p302_n==3 & c1p434a==1 & c1p435e_`i'==1 & c1p435f_`i'==1 & c1p435i_`i'==1
}

gen violencia_fissev_m_sol_spareja = 0
label var violencia_fissev_m_sol_spareja "Violencia física severa: Mujer soltera sin pareja actual"
label values violencia_fissev_m_sol_spareja lbl_sino
forvalues i=12/14 {
    replace violencia_fissev_m_sol_spareja = 1 if c1p302_n==3 & c1p434a==2 & c1p435_`i'==1 & c1p435a_5_`i'==1 & c1p435c_`i'==1
}
forvalues i=1/7 {
    replace violencia_fissev_m_sol_spareja = 1 if c1p302_n==3 & c1p434a==2 & c1p435e_`i'==1 & c1p435f_`i'==1 & c1p435i_`i'==1
}

gen indicador_8_2_5 = 0
replace indicador_8_2_5 = 1 if violencia_fissev_m_act_unida==1 | violencia_fissev_m_ant_unida==1 | ///
                             violencia_fissev_m_sol_cpareja==1 | violencia_fissev_m_sol_spareja==1
label var indicador_8_2_5 "Indicador 8.2.5: Violencia física severa"
label values indicador_8_2_5 lbl_indicador

* ---------- 8.2.6: Violencia sexual (no pareja) ----------
gen violencia_sexual_m_act_unida = 0
label var violencia_sexual_m_act_unida "Violencia sexual: Mujer actualmente unida"
label values violencia_sexual_m_act_unida lbl_sino
forvalues i=1/20 {
    replace violencia_sexual_m_act_unida = 1 if c1p302_n==1 & c1p415_`i'==1 & c1p415a_5_`i'!=1 & c1p415c_`i'==1
}

gen violencia_sexual_m_ant_unida = 0
label var violencia_sexual_m_ant_unida "Violencia sexual: Mujer anteriormente unida"
label values violencia_sexual_m_ant_unida lbl_sino
forvalues i=1/20 {
    replace violencia_sexual_m_ant_unida = 1 if c1p302_n==2 & c1p432_`i'==1 & c1p432a_5_`i'!=1 & c1p432a_24_`i'!=1 & c1p432c_`i'==1
}

gen violencia_sexual_m_soltera = 0
label var violencia_sexual_m_soltera "Violencia sexual: Mujer soltera"
label values violencia_sexual_m_soltera lbl_sino
forvalues i=1/20 {
    replace violencia_sexual_m_soltera = 1 if c1p302_n==3 & c1p439_`i'==1 & c1p439a_5_`i'!=1 & c1p439c_`i'==1
}

gen indicador_8_2_6 = 0
replace indicador_8_2_6 = 1 if violencia_sexual_m_act_unida==1 | violencia_sexual_m_ant_unida==1 | violencia_sexual_m_soltera==1
label var indicador_8_2_6 "Indicador 8.2.6: Violencia sexual (no pareja)"
label values indicador_8_2_6 lbl_indicador

* ---------- 8.2.12: Acoso sexual (no pareja) ----------
gen acoso_sexual_m_act_unida = 0
label var acoso_sexual_m_act_unida "Acoso sexual: Mujer actualmente unida"
label values acoso_sexual_m_act_unida lbl_sino
foreach i in 5 6 10 12 13 14 15 16 17 {
    replace acoso_sexual_m_act_unida = 1 if c1p302_n==1 & c1p415_`i'==1 & c1p415a_5_`i'!=1 & c1p415c_`i'==1
}
replace acoso_sexual_m_act_unida = 1 if c1p302_n==1 & c1p415_o_20=="ACOSO SEXUAL" & c1p415a_5_20!=1 & c1p415c_20==1

gen acoso_sexual_m_ant_unida = 0
label var acoso_sexual_m_ant_unida "Acoso sexual: Mujer anteriormente unida"
label values acoso_sexual_m_ant_unida lbl_sino
foreach i in 5 6 10 12 13 14 15 16 17 {
    replace acoso_sexual_m_ant_unida = 1 if c1p302_n==2 & c1p432_`i'==1 & c1p432a_5_`i'!=1 & c1p432a_24_`i'!=1 & c1p432c_`i'==1
}
replace acoso_sexual_m_ant_unida = 1 if c1p302_n==2 & c1p432_o_20=="ACOSO SEXUAL" & c1p432a_5_20!=1 & c1p432a_24_20!=1 & c1p432c_20==1

gen acoso_sexual_m_soltera = 0
label var acoso_sexual_m_soltera "Acoso sexual: Mujer soltera"
label values acoso_sexual_m_soltera lbl_sino
foreach i in 5 6 10 12 13 14 15 16 17 {
    replace acoso_sexual_m_soltera = 1 if c1p302_n==3 & c1p439_`i'==1 & c1p439a_5_`i'!=1 & c1p439c_`i'==1
}
replace acoso_sexual_m_soltera = 1 if c1p302_n==3 & c1p439_o_20=="ACOSO SEXUAL" & c1p439a_5_20!=1 & c1p439c_20==1

gen indicador_8_2_12 = 0
replace indicador_8_2_12 = 1 if acoso_sexual_m_act_unida==1 | acoso_sexual_m_ant_unida==1 | acoso_sexual_m_soltera==1
label var indicador_8_2_12 "Indicador 8.2.12: Acoso sexual (no pareja)"
label values indicador_8_2_12 lbl_indicador

* ---------- 8.3.1: Violencia interparental en la niñez ----------
gen byte indicador_8_3_1 = 0
replace indicador_8_3_1 = 1 if (cap441a_4==1 | cap441a_5==1 | cap441a_6==1)
label var indicador_8_3_1 "Indicador 8.3.1: Violencia interparental en la niñez"
label values indicador_8_3_1 lbl_indicador

* ---------- 8.3.16: Dependencia económica (CORREGIDO) ----------
gen dep_econ_m_act_unida = 0
label var dep_econ_m_act_unida "Dependencia económica: Mujer actualmente unida"
label values dep_econ_m_act_unida lbl_sino

* Mujeres actualmente unidas: evalúa si CUALQUIERA de las 6 decisiones cumple
replace dep_econ_m_act_unida = 1 if c1p302_n==1 & ( ///
    (inlist(c1p403c_c1_1,2,3,6) & c1p403c_c3_1==2) | ///
    (inlist(c1p403c_c1_2,2,3,6) & c1p403c_c3_2==2) | ///
    (inlist(c1p403c_c1_3,2,3,6) & c1p403c_c3_3==2) | ///
    (inlist(c1p403c_c1_4,2,3,6) & c1p403c_c3_4==2) | ///
    (inlist(c1p403c_c1_5,2,3,6) & c1p403c_c3_5==2) | ///
    (inlist(c1p403c_c1_6,2,3,6) & c1p403c_c3_6==2) | ///
    (inlist(c1p403c_c1_1,4,5) & c1p403c_c2_1==5) | ///
    (inlist(c1p403c_c1_2,4,5) & c1p403c_c2_2==5) | ///
    (inlist(c1p403c_c1_3,4,5) & c1p403c_c2_3==5) | ///
    (inlist(c1p403c_c1_4,4,5) & c1p403c_c2_4==5) | ///
    (inlist(c1p403c_c1_5,4,5) & c1p403c_c2_5==5) | ///
    (inlist(c1p403c_c1_6,4,5) & c1p403c_c2_6==5) ///
)

gen dep_econ_m_ant_unida = 0
label var dep_econ_m_ant_unida "Dependencia económica: Mujer anteriormente unida"
label values dep_econ_m_ant_unida lbl_sino

* Mujeres anteriormente unidas: evalúa si CUALQUIERA de las 6 decisiones cumple
replace dep_econ_m_ant_unida = 1 if c1p302_n==2 & ( ///
    (inlist(c1p420c_c1_1,4,5) & c1p420c_c2_1==23 & c1p420c_c3_1==2) | ///
    (inlist(c1p420c_c1_2,4,5) & c1p420c_c2_2==23 & c1p420c_c3_2==2) | ///
    (inlist(c1p420c_c1_3,4,5) & c1p420c_c2_3==23 & c1p420c_c3_3==2) | ///
    (inlist(c1p420c_c1_4,4,5) & c1p420c_c2_4==23 & c1p420c_c3_4==2) | ///
    (inlist(c1p420c_c1_5,4,5) & c1p420c_c2_5==23 & c1p420c_c3_5==2) | ///
    (inlist(c1p420c_c1_6,4,5) & c1p420c_c2_6==23 & c1p420c_c3_6==2) | ///
    (inlist(c1p420c_c1_1,2,3,6) & c1p420c_c3_1==2) | ///
    (inlist(c1p420c_c1_2,2,3,6) & c1p420c_c3_2==2) | ///
    (inlist(c1p420c_c1_3,2,3,6) & c1p420c_c3_3==2) | ///
    (inlist(c1p420c_c1_4,2,3,6) & c1p420c_c3_4==2) | ///
    (inlist(c1p420c_c1_5,2,3,6) & c1p420c_c3_5==2) | ///
    (inlist(c1p420c_c1_6,2,3,6) & c1p420c_c3_6==2) ///
)

gen indicador_8_3_16 = 0
replace indicador_8_3_16 = 1 if (dep_econ_m_act_unida==1 | dep_econ_m_ant_unida==1)
label var indicador_8_3_16 "Indicador 8.3.16: Dependencia económica"
label values indicador_8_3_16 lbl_indicador

*========================================================================*
* 5) FILTROS PARA EXPORTADOR (MUJERES)
*========================================================================*
capture drop filter
gen byte filter = (c1p208_a>=18 & !missing(factor_muj))
label var filter "FILTRO: Mujeres 18+ con factor no missing"
label define lbl_filter 0 "Not Selected" 1 "Selected", replace
label values filter lbl_filter

capture drop filter_dep_econ
gen byte filter_dep_econ = (c1p302_n <= 2)
label var filter_dep_econ "FILTRO: Mujeres actualmente o anteriormente unidas"
label values filter_dep_econ lbl_filter
e
*========================================================================*
* 6) BLOQUE NIÑOS — INDICADOR 8.3.4 (Se guarda en base aparte)
*========================================================================*
preserve
    * Si el peso trae "Ñ", normalizamos el nombre para evitar problemas
    capture confirm variable factor_niÑos
    if !_rc rename factor_niÑos factor_ninos

    * Identificador temporal para reshape
    capture drop id_temp
    gen id_temp = _n

    * Reshape largo — ajustar si tu cuestionario usa otra codificación
    reshape long c1p443_@_1 c1p443_@_2, i(id_temp) j(orden_nino)

    rename c1p443_*_1 c1p443_x_1
    rename c1p443_*_2 c1p443_x_2

    label var orden_nino  "Orden del niño"
    label var c1p443_x_1  "Castigo físico/psicológico - Opción 1"
    label var c1p443_x_2  "Castigo físico/psicológico - Opción 2"

    gen byte ninos_contab = .
    replace ninos_contab = 1 if orden_nino <= cap441b_n
    replace ninos_contab = 0 if missing(ninos_contab)
    label define lbl_contab 0 "No" 1 "Sí", replace
    label values ninos_contab lbl_contab
    label var ninos_contab "Niños existentes contabilizados"

    gen indicador_8_3_4 = .
    replace indicador_8_3_4 = 1 if cap441b==1 & cap442==1 & (c1p443_x_1==1 | c1p443_x_2==1)
    replace indicador_8_3_4 = 0 if missing(indicador_8_3_4)
    label var indicador_8_3_4 "Indicador 8.3.4: Castigo físico/psicológico menores 72 meses"
    label values indicador_8_3_4 lbl_indicador

    gen byte filter_ninos = (cap441b==1 & ninos_contab==1)
    label var filter_ninos "FILTRO: Niños contabilizados"
    label values filter_ninos lbl_filter

    * Guardar base de niños
    order conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id ///
          departamento departamento_rec provincia area ///
          orden_nino ninos_contab filter_ninos indicador_8_3_4 factor_ninos
    label var factor_ninos "Peso muestral — niños <72 meses"
    save "$output/base_indicadores_csr01_ninos72m_2024.dta", replace

    di as result "✓ Base NIÑOS 8.3.4 guardada en:"
    di as txt    "  $output/base_indicadores_csr01_ninos72m_2024.dta"
restore

*========================================================================*
* 7) EXPORTAR BASE PRINCIPAL (MUJERES)
*========================================================================*
order conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id ///
      departamento departamento_rec provincia area c1p302_n c1p434a ///
      indicador_8_2_1 indicador_8_2_2 indicador_8_2_3 indicador_8_2_5 ///
      indicador_8_2_6 indicador_8_2_12 indicador_8_3_1 indicador_8_3_16 ///
      filter filter_dep_econ factor_muj
label var factor_muj "Peso muestral — mujeres"

save "$output/base_indicadores_csr01_mujeres_2024.dta", replace

di as result _n "==============================================="
di as result     "✓✓ Proceso COMPLETADO (CSR01 – Consolidado)"
di as result     " - Mujeres : $output/base_indicadores_csr01_mujeres_2024.dta"
di as result     " - Niños   : $output/base_indicadores_csr01_ninos72m_2024.dta"
di as result     "==============================================="

*========================================================================*
* 8) VERIFICACIÓN DE RESULTADOS (OPCIONAL)
*========================================================================*
di as result _n "=== VERIFICACIÓN DE INDICADORES ==="

* 8.2.1: Violencia psicológica
tab indicador_8_2_1 if filter==1 [iw=factor_muj]

* 8.2.2: Violencia física
tab indicador_8_2_2 if filter==1 [iw=factor_muj]

* 8.2.3: Violencia sexual por pareja
tab indicador_8_2_3 if filter==1 [iw=factor_muj]

* 8.2.5: Violencia física severa
tab indicador_8_2_5 if filter==1 [iw=factor_muj]

* 8.2.6: Violencia sexual (no pareja)
tab indicador_8_2_6 if filter==1 [iw=factor_muj]

* 8.2.12: Acoso sexual
tab indicador_8_2_12 if filter==1 [iw=factor_muj]

* 8.3.1: Violencia interparental en la niñez
tab indicador_8_3_1 if filter==1 [iw=factor_muj]

* 8.3.16: Dependencia económica (debe dar ~28.6%)
di as result _n "=== INDICADOR 8.3.16 - DEPENDENCIA ECONÓMICA ==="
tab indicador_8_3_16 if filter_dep_econ==1 [iw=factor_muj]
tab indicador_8_3_16 c1p302_n if filter_dep_econ==1 [iw=factor_muj], row

di as result _n "✓ Verificación completada."