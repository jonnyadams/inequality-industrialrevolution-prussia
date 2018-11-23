*SET PATHS
global path "M:\dissertation\dissertation\stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

clear all
use  "$data/merged data for regression", replace

#delimit;
global vars population_1849
 loam_prop sand_prop
 factories_iron factories_steel loom_fabrics_1849 factory_fabrics_1849
 factory_prop_1849 factory_numbers prop_fact_workers
 prop_farm_workers steam_engines 
 engine_power handloom_ratio soil_loam_pc 
;
#delimit cr

estpost tabstat $vars, statistics(mean sd min max count) listwise
est store output
/*
#delimit;
estout sumpopulation_1849 using "$output/table1.xls",
style(tex) cells(mean(fmt(3)) sd(fmt(3)) max(fmt(3)) 
min(fmt(3)) count(fmt(0))) label title("Summary Statistics")
replace;
#delimit cr
*/
#delimit;
esttab output using "$output/table1.csv", cells("$vars") replace label
noobs;
#delimit cr

#delimit;
esttab output using "$output/table1-test.csv", cells("mean sd min max count") replace label;
#delimit cr
/*
x
#delimit;
estout output using "$output/table1.xls",
style(tab) cells(se(transpose) max(transpose) min(transpose))  label title("Summary Statistics")
replace;
#delimit cr
*/
