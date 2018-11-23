*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

*IMPORT RAW IPEHD DATA ON MERGING COUNTIES
import delimited "$path/ipehd_complete/ipehd_merge_county", clear

*LIST OF YEARS TO LOOP THROUGH
local yearlist "1800 1849 1858 1866 1883 1886 1882 1888 1892 1896 1901"

*KEEP ONLY YEARS DESIRABLE FOR THE ANALYSIS
keep  *1800 *1849 *1858 *1866 *1883 *1886 *1882 *1888 *1892 *1896 *1901


*SORT DATA
sort kreiskey1800

drop county*

duplicates drop


*SAVE DATASET
save "$data/county merge list", replace
