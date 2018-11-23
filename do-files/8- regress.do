*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"


clear all
use  "$data/merged data for regression", replace


global controls "population_1849 yield_wheat"
global instrument soil_loam_pc
global inequality std_land_timespec1849

local indep_vars "prop_fact_workers engine_power factories_iron factories_steel factory_numbers "
local indep_vars "`indep_vars' steam_engines prop_farm_workers  loom_fabrics_1849 factory_fabrics_1849 factory_prop_1849"



foreach indep_var of local indep_vars {

	eststo ols`indep_var': reg `indep_var' $inequality $controls if `indep_var' !=., r

	eststo fs`indep_var': reg $inequality $instrument $controls if `indep_var' != ., r
	
	eststo ss`indep_var': ivreg2 `indep_var' $controls ($inequality = $instrument) if `indep_var' != .,r
	estadd scalar fstat =e(widstat)	
	
}

#delimit;
estout olsprop_fact_workers olsprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) replace;
#delimit cr


#delimit;
estout fsprop_fact_workers fsprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($instrument)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) append;
#delimit cr

#delimit;
estout ssprop_fact_workers ssprop_farm_workers using "$output/table2.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Factory Workers (Proportion)" "Farm Workers (Proportion)", numbers) append;
#delimit cr


#delimit;
estout olsengine_power olssteam_engines olsfactories_iron olsfactories_steel  using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Iron Factories" "Number of Steel Factories", numbers) replace;
#delimit cr

#delimit;
estout fsengine_power fssteam_engines fsfactories_iron fsfactories_steel  using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($instrument)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Iron Factories" "Number of Steel Factories", numbers) append;
#delimit cr

#delimit;
estout ssengine_power sssteam_engines ssfactories_iron ssfactories_steel using "$output/table3.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Engine Power" "Number of Steam Engines" "Number of Iron Factories" "Number of Steel Factories", numbers) append;
#delimit cr


#delimit;
estout olsloom_fabrics_1849 olsfactory_fabrics_1849 olsfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Power Loom-Loom Ratio", numbers) replace;
#delimit cr



#delimit;
estout fsloom_fabrics_1849 fsfactory_fabrics_1849 fsfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($instrument)
stats(N r2, fmt(%9.0f %9.2f) labels("Observations" "R-squared"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Power Loom-Loom Ratio", numbers) append;
#delimit cr

#delimit;
estout ssloom_fabrics_1849 ssfactory_fabrics_1849 ssfactory_prop_1849 using "$output/table4.xls",
style(tab) cells(b(star fmt(3)) se(fmt(3))) label collabels(none) 
starlevels(* 0.10 ** 0.05 *** 0.01) keep($inequality)
stats(N fstat, fmt(%9.0f %9.2f) labels("Observations" "First-stage F-stat"))
mlabels("Fabrics (Loom)" "Fabrics (Factory)" "Power Loom-Loom Ratio", numbers) append;
#delimit cr
