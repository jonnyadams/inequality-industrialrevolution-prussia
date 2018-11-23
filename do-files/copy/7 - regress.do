*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"


clear all
use "$data/agg data with vars", replace

egen std_inequality = std(inequality_1858)

global controls "population_1849 yield_wheat"
global instrument loam_prop
 
local indep_vars "prop_fact_workers engine_power factory_numbers number_handlooms number_looms"
local indep_vars "`indep_vars' steam_engines prop_farm_workers handloom_ratio loom_fabrics_1849 factory_fabrics_1849 factory_prop_1849"

foreach indep_var of local indep_vars {

	eststo ols`indep_var': reg `indep_var' std_inequality $controls if `indep_var' !=., r

	eststo fs`indep_var': reg std_inequality $instrument $controls if `indep_var' != ., r
	
	eststo ss`indep_var': ivreg2 `indep_var' $controls (std_inequality = $instrument) if `indep_var' != .,r
	estadd scalar fstat =e(widstat)	
	
}
/*
#delimit;
estout olsprop_fact_workers olsprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) replace;
#delimit cr


#delimit;
estout fsprop_fact_workers fsprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(loam_prop)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) append;
#delimit cr

#delimit;
estout ssprop_fact_workers ssprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) append;
#delimit cr


#delimit;
estout olsengine_power olssteam_engines olsnumber_handlooms olsnumber_looms olshandloom_ratio  using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Handlooms" "Number of Looms" "Ratio of Handlooms to Looms", numbers) replace;
#delimit cr

#delimit;
estout fsengine_power fssteam_engines fsnumber_handlooms fsnumber_looms fshandloom_ratio  using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(loam_prop)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Handlooms" "Number of Looms" "Ratio of Handlooms to Looms", numbers) append;
#delimit cr

#delimit;
estout ssengine_power sssteam_engines ssnumber_handlooms ssnumber_looms sshandloom_ratio using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Handlooms" "Number of Looms" "Ratio of Handlooms to Looms", numbers) append;
#delimit cr


#delimit;
estout olsloom_fabrics_1849 olsfactory_fabrics_1849 olsfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Proportion Factory-made", numbers) replace;
#delimit cr



#delimit;
estout fsloom_fabrics_1849 fsfactory_fabrics_1849 fsfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(loam_prop)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Proportion Factory-made", numbers) append;
#delimit cr

#delimit;
estout ssloom_fabrics_1849 ssfactory_fabrics_1849 ssfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep(inequality_1858)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Proportion Factory-made", numbers) append;
#delimit cr

/*
 
ivreg2 prop_fact_workers yield_wheat ///
(inequality_1858 = loam_prop), robust
 
 
ivreg2 engine_power population_1849   yield_wheat ///
(inequality_1858 = loam_prop), robust 

ivreg2	factory_numbers population_1849  yield_wheat ///
(inequality_1858 = loam_prop), robust 

ivreg2 number_handlooms population_1849  yield_wheat ///
(inequality_1858 = loam_prop), robust 

ivreg2 number_looms population_1849  yield_wheat ///
(inequality_1858 = loam_prop), robust 

ivreg2 steam_engines  population_1849  yield_wheat ///
(inequality_1858 = loam_prop), robust 


ivreg2 prop_fact_workers yield_wheat ///
(inequality_1858 = loam_prop), robust

ivreg2 prop_farm_workers yield_wheat ///
(inequality_1858 = loam_prop), robust 

ivreg2 factory_prop_1849 yield_wheat ///
(inequality_1858 = loam_prop), robust

ivreg2 handloom_ratio yield_wheat ///
(inequality_1858 = loam_prop), robust


