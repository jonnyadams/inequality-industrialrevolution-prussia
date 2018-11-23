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
local yearlist "1849 1858 1866 1883 1886 1888 1892 1896 1901"

*KEEP ONLY YEARS DESIRABLE FOR THE ANALYSIS
keep *1849 *1858 *1866 *1883 *1886 *1888 *1892 *1896 *1901

*LOOP THROUGH THE YEARS
foreach year of local yearlist {

	duplicates tag kreiskey`year', gen(dup`year')
	}

*CREATE A TAG OF WHEN LATER YEARS HAVE HIGHER AGGREGATION THAN 1849
gen more_in_later = 0

foreach year of local yearlist {
	replace more_in_later = 1 if dup`year' > dup1849
}


*FOR 14 OBSERVATIONS, THE HIGHEST LEVEL OF GEOGRAPHIC AGGREGATION OCCURS IN 
*1866, NOT 1849. FOR THE REMAINING OBSERVATIONS, 1849 IS THE HIGHEST LEVEL OF AGGREGATION

*GENERATE A VARIABLE WHICH INDICATES WHEN THE HIGHEST LEVEL OF AGGREGATION IS IN 1849
gen county_highest = county1849
replace county_highest = county1866 if more_in_later

*CREATE A NEW KREISKEY USING THE AMENDED COUNTY GROUPINGS
egen kreiskey_highest = group(county_highest)

*REMOVE INTERMEDIATE VARIABLES
drop dup* more_in_later

*SORT DATA
sort kreiskey_highest

*SAVE DATASET
save "$data/county merge list", replace
