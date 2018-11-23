*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

use "$data/agg data with vars", replace

merge 1:1 kreiskey1800 using "$data/cinnirella data" 

drop if _m != 3

drop *1816 *1864 *1886 *1896 _merge

lab var std_land_timespec1849 "Share of Large Estates (1858)"
lab var soil_loam_pc "Proportion of Loamy Soil"

save "$data/merged data for regression", replace
