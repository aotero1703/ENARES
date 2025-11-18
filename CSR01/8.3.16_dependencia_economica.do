/**************************************************************************
 Proyecto : ENARES – Observatorio Nacional de Violencia
 Autora   : Alexandra Otero
 Fecha    : 09/08/25

***************************************************************************
 TÍTULO (Indicador 8.3.16):
PORCENTAJE DE MUJERES DE 18 AÑOS A MÁS, BAJO DEPENDENCIA ECONÓMICA DE PARTE DE SU PAREJA O EXPAREJA
 PROPÓSITO:
   - Importar, estandarizar y consolidar las bases necesarias (CAP200, CAP300, CAP411).
   - Construir el indicador 8.2.12 para mujeres de 18+ años.
   - Presentar una tabulación ponderada y exportar el resultado a Excel.
**************************************************************************/

*========================================================================*
* 0. Configuración de rutas
*========================================================================*

display "Usuario activo: `c(username)'"

if "`c(username)'" == "dpvlv12" {
    global root "G:\Mi unidad\MIMP\Observatorio Nacional de Violencia\ENARES"
}
else if ("`c(username)'" == "Alexandra Otero") {
    global root "H:\Mi unidad\MIMP\Observatorio Nacional de Violencia\ENARES"
}

display "Directorio raíz: $root"

* Rutas estándar
global dofiles  "$root/Do Files"
global output   "$root/Outputs"
global data_2024     "$root/Data/2024"

* Crear carpetas (si no existen)
cap mkdir "$root/Do Files"
cap mkdir "$root/Outputs"
cap mkdir "$root/Data/2024"

* Subcarpetas de Data
cap mkdir "$data_2024/CSR01"
cap mkdir "$data_2024/CSR02"
cap mkdir "$data_2024/CSR03"
cap mkdir "$data_2024/CSR04"

global csr01_2024 "$data_2024/CSR01"
global csr02_2024 "$data_2024/CSR02"
global csr03_2024 "$data_2024/CSR03"
global csr04_2024 "$data_2024/CSR04"

di "Carpeta do-files : $dofiles"
di "Carpeta datos    : $data_2024"
di "Carpeta outputs  : $output"

*========================================================================*
* 1. Importación y estandarización
*========================================================================*

use "$csr01_2024/03_CRS01_CAP300.dta", clear
rename _all, lower

* Guardar versión temporal con nombres en minúsculas
tempfile cap300
save `cap300'


use "$csr01_2024/05_CRS01_CAP402.dta", clear
rename _all, lower

* Guardar versión temporal con nombres en minúsculas
tempfile cap402
save `cap402'


* Reabrimos base principal para hacer merge
use `cap300', clear

* Realiza el merge (ejemplo por variable 'id')
merge 1:1 conglome ccdd ccpp ccdi codccpp nselv tohogar hogar_id persona_id using `cap402'

* Verificamos el resultado del merge
tab _merge

e
* ----------------------------------------------------------
* Indicador: Dependencia Económica
* ----------------------------------------------------------

* ----------------------------------------------------------
* 1. Variables de condición de unión
* ----------------------------------------------------------
gen mujer_unida      = inlist(c1p302, 1, 2)   // Casada o conviviente
gen mujer_exunida    = inlist(c1p302, 3, 4, 5) // Viuda, divorciada, separada/ex conviviente

* ----------------------------------------------------------
* 2. Caso 1: Mujer actualmente unida + esposo/conviviente
* ----------------------------------------------------------
gen aporta_c1p403c_c1 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p403c_c1 = 1 if inlist(c1p403c_c1_`i', 2, 3, 6)
}

gen aporta_c1p403c_c3 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p403c_c3 = 1 if inlist(c1p403c_c3_`i', 2)
}

gen aporta2_c1p403c_c1 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta2_c1p403c_c1 = 1 if inlist(c1p403c_c1_`i', 4)
}

gen aporta_c1p403c_c2 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p403c_c2 = 1 if inlist(c1p403c_c2_`i', 5)
}

gen caso1_mau = 0
replace caso1_mau = 1 if mujer_unida == 1 & ( ///
    (aporta_c1p403c_c1 == 1 & aporta_c1p403c_c3 == 1) | ///
    (aporta2_c1p403c_c1 == 1 & aporta_c1p403c_c2 == 1) )

* ----------------------------------------------------------
* 3. Caso 2: Mujer anteriormente unida
* ----------------------------------------------------------
gen aporta_c1p420c_c1 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p420c_c1 = 1 if inlist(c1p420c_c1_`i', 4, 5)
}

gen aporta_c1p420c_c2 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p420c_c2 = 1 if inlist(c1p420c_c2_`i', 2, 3) // corregido: era 23
}

gen aporta_c1p420c_c3 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta_c1p420c_c3 = 1 if inlist(c1p420c_c3_`i', 2)
}

gen aporta2_c1p420c_c1 = 0
foreach i in 1 2 3 4 5 6 {
    replace aporta2_c1p420c_c1 = 1 if inlist(c1p420c_c1_`i', 2, 3, 6)
}

gen caso2_mau = 0
replace caso2_mau = 1 if mujer_exunida == 1 & ( ///
    (aporta_c1p420c_c1 == 1 & aporta_c1p420c_c2 == 1 & aporta_c1p420c_c3 == 1) | ///
    (aporta2_c1p420c_c1 == 1 & aporta_c1p420c_c3 == 1) )

* ----------------------------------------------------------
* 4. Numerador, denominador e indicador
* ----------------------------------------------------------
gen num = (caso1_mau==1 | caso2_mau==1)
gen denom = (mujer_unida==1 | mujer_exunida==1)

gen dependencia_economica = .
replace dependencia_economica = (num / denom)
label var dependencia_economica "Indicador de dependencia económica (%)"

* ----------------------------------------------------------
* 5. Limpieza opcional
* ----------------------------------------------------------
order mujer_unida mujer_exunida caso1_mau caso2_mau num denom dependencia_economica


tab dependencia_economica [iw=factor_muj]
