*SET PATHS
global path "U:\dissertation\stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

clear all
use  "$data/merged data for regression", replace

#delimit;
global vars population_1849 inequality_1849
 soil_loam_pc sand_prop
 factories_iron factories_steel loom_fabrics_1849 factory_fabrics_1849
 factory_prop_1849 factory_numbers prop_fact_workers
 prop_farm_workers steam_engines 
 engine_power handloom_ratio  
;
#delimit cr

estpost summarize $vars
est store output


#delimit;
esttab output using "$output/summary table.csv", 
cells("mean sd min max count") replace label
noobs tex;
#delimit cr
