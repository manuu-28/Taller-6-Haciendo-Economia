cd "C:\Users\prestamour\Downloads\Taller-6-Haciendo-Economia-main"

import excel "RawData\Datos_Juego.xlsx", sheet("datos") firstrow clear

* Ver las variables
describe

* Ver las primeras filas en formato tabla (como Excel)
browse

* Guardar base ya importada en formato nativo de Stata (.dta)
save "RawData\Datos_Juego.dta", replace

label define juego_lbl 1 "Con castigo" 2 "Sin castigo"
label values juego juego_lbl

* Traer la hoja "Public goods contributions" sin filtrar
import excel "RawData\Datos_Herrmann.xlsx", sheet("Public goods contributions") clear

* Ver tabla
browse

* Importar tabla "sin castigo"  
import excel "RawData\Datos_Herrmann.xlsx", sheet("Public goods contributions") cellrange(A2:Q12) firstrow clear

rename Period periodo
gen tratamiento = 0
label variable tratamiento "0 = Sin castigo, 1 = Con castigo"
save "RawData\sin_castigo.dta", replace

* Importar tabla "con castigo"
import excel "RawData\Datos_Herrmann.xlsx", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
rename Period periodo
gen tratamiento = 1
save "RawData\con_castigo.dta", replace

* Muestra en Results el nombre de las 16 columnas de países 
describe

* Carga la tabla sin castigo
use "RawData\sin_castigo.dta", clear
append using "RawData\con_castigo.dta"
label define trat_lbl 0 "Sin castigo" 1 "Con castigo"
label values tratamiento trat_lbl
save "RawData\Herrmann_long_paises.dta", replace

* Promedio de los 16 países en esa fila (período+tratamiento)
egen media_paises = rowmean(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)
* Desviación estándar entre esos 16 países
egen sd_paises   = rowsd(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)
* Valor mínimo entre los 16 países
egen min_paises  = rowmin(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)
* Valor máximo entre los 16 países
egen max_paises  = rowmax(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)
* Varianza = desviación estándar al cuadrado
gen var_paises   = sd_paises^2
* Rango = máximo menos mínimo
gen rango_paises = max_paises - min_paises

* Imprime Período 1 y Período 10, de cada tratamiento, con sus 6 estadísticas ya calculadas.
* Esto es lo que copias a la tabla resumen del Word (Parte 2.2.5).
list periodo tratamiento media_paises var_paises sd_paises min_paises max_paises rango_paises if inlist(periodo,1,10)


* GRÁFICO DE LÍNEAS: Una línea es "sin castigo" y otra "con castigo". Parte 2.2.1.
twoway (line media_paises periodo if tratamiento==0) (line media_paises periodo if tratamiento==1), ///
 legend(order(1 "Sin castigo" 2 "Con castigo")) xlabel(1(1)10) ///
 ytitle("Contribución promedio entre países") xtitle("Período") ///
 title("Contribución promedio por período")
 graph export "Resultados\linea_periodo_herrmann.png", replace width(1200)
 
* GRÁFICO DE COLUMNAS: Período 1 (sin/con castigo) y Período 10 (sin/con castigo). Parte 2.2.2.
 graph bar media_paises if inlist(periodo,1,10), over(periodo) over(tratamiento) ///
 ytitle("Contribución promedio entre países") ///
 title("Contribución promedio: Período 1 vs. Período 10")
 graph export "Resultados\barras_periodo1_10_herrmann.png", replace width(1200)

 
* (Parte 2.3)

* Sin castigo, período 1
use "RawData\sin_castigo.dta", clear
keep if periodo==1        
drop periodo tratamiento  
xpose, clear varname   
rename v1 sin_p1     
rename _varname pais  
save "RawData\t_sin_p1.dta", replace

* Sin castigo, período 10
use "RawData\sin_castigo.dta", clear
keep if periodo==10
drop periodo tratamiento
xpose, clear varname
rename v1 sin_p10
rename _varname pais
save "RawData\t_sin_p10.dta", replace

* Con castigo, período 1
use "RawData\con_castigo.dta", clear
keep if periodo==1
drop periodo tratamiento
xpose, clear varname
rename v1 con_p1
rename _varname pais
save "RawData\t_con_p1.dta", replace

* Con castigo, período 10
use "RawData\con_castigo.dta", clear
keep if periodo==10
drop periodo tratamiento
xpose, clear varname
rename v1 con_p10
rename _varname pais
save "RawData\t_con_p10.dta", replace

* Unir los cuatro en una sola base
use "RawData\t_sin_p1.dta", clear
merge 1:1 pais using "RawData\t_sin_p10.dta", nogen
merge 1:1 pais using "RawData\t_con_p1.dta", nogen
merge 1:1 pais using "RawData\t_con_p10.dta", nogen
save "RawData\comparacion_paises.dta", replace


* Parte 2.3.2 y 2.3.3
* Período 1: ¿difieren las contribuciones entre tratamientos?
* imprime en Results una tabla. Ese valor p es lo que responde la pregunta 2.3.2 
ttest sin_p1 == con_p1

* Período 10 
* Este resultado responde la pregunta 2.3.3.
ttest sin_p10 == con_p10



* Parte 2.1
use "RawData\Datos_Juego.dta", clear
preserve
collapse (mean) contribucion_eur, by(juego ronda)

twoway ///
 (line contribucion_eur ronda if juego==1) ///
 (line contribucion_eur ronda if juego==2), ///
 legend(order(1 "Con castigo" 2 "Sin castigo")) ///
 xlabel(1(1)10) ///
 ytitle("Contribución promedio (€)") xtitle("Período") ///
 title("Contribución promedio por período — Tu juego de clase")

graph export "Resultados\linea_periodo_datos_juego.png", replace width(1200)
restore
