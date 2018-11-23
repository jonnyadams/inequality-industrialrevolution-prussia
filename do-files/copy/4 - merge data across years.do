*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

*local year 1849


*LIST OF YEARS TO LOOP THROUGH
local yearlist "1849 1858 1866 1883 1888 1892 1896 1901"

*NEED TO LOOP THROUGH 1886 SEPARATELY, AS THAT YEAR CONTAINS YIELD FIGURES
*THEREFORE IT IS INAPPROPRIATE TO AGGREGATE THE SUM OF YIELDS, NEED TO TAKE THE 
*WEIGHTED AVERAGE ACROSS COUNTIES.


foreach year of local yearlist {
	
	*USE LIST OF COUNTIES
	use "$data/county merge list", clear
	keep kreiskey`year' county`year' county_highest kreiskey_highest

	duplicates drop

	*DROP THE OBS WHERE THE KREISKEY IS MISSING
	drop if kreiskey_highest == . 

	*CHECK THAT THE KREISKEY OF THE YEAR WE WANT TO MERGE IS A UNIQUE IDENTIFIER
	isid kreiskey`year'

	*SAVE AS TEMPFILE
	tempfile countymerge
	save `countymerge', replace

	*LOAD THE MAIN DATA
	use "$data/year_merged/`year'", clear

	*MERGE WITH THE COUNTY LISTS
	merge 1:1 kreiskey`year' using `countymerge'

	drop _m 
	
	*DROP THE VARIABLES NO LONGER NECESSARY
	drop county county`year' rb kreiskey`year'
	
	*OBTAIN A LIST OF THE VARIABLES, EXCLUDING THE VARIABLES WHICH WE WISH TO COLLAPSE
	*BY
	ds county_highest kreiskey_highest, not

	*STORE THIS LIST AS A LOCAL VARIABLE
	local vars `r(varlist)'
	
	*COLLAPSE THE DATA AS THE SUM ACROSS THE DISAGGREGATED COUNTIES
	
	** NOTE - I NEED TO CHECK HERE THAT IT IS A SUITABLE PROCEDURE TO SUM ACROSS 
	*COUNTIES, RATHER THAN TAKING THE AVERAGE
	collapse (sum) `vars', by(county_highest kreiskey_highest)
	
	*SAVE DATASET
	save "$data/year_merged_summed/`year'", replace

 }

*** NOW DEAL WITH 1886 ***

local year 1886

*USE LIST OF COUNTIES
use "$data/county merge list", clear
keep kreiskey`year' county`year' county_highest kreiskey_highest

duplicates drop

*DROP THE OBS WHERE THE KREISKEY IS MISSING
drop if kreiskey_highest == . 

*CHECK THAT THE KREISKEY OF THE YEAR WE WANT TO MERGE IS A UNIQUE IDENTIFIER
isid kreiskey`year'

*SAVE AS TEMPFILE
tempfile countymerge
save `countymerge', replace


*LOAD THE MAIN DATA
use "$data/year_merged/`year'", clear

*MERGE WITH THE COUNTY LISTS
merge 1:1 kreiskey`year' using `countymerge'

drop _m 

*DROP THE VARIABLES NO LONGER NECESSARY
drop county county`year' rb kreiskey`year'

*SINCE THE YIELDS ARE GIVEN IN VALUES PER HECTARE, TO COLLAPSE ACROSS COUNTIES
*CORRECTLY WE WILL FIRST CREATE A FIGURE FOR THE IMPLIED TOTAL AREA OF CROPS BEING
*PLANTED, THEN COLLAPSE ACROSS THAT VALUE

*LIST ALL THE CROP YIELD VARIABLES
ds yie1886_hec*

*STORE THE LIST AS A LOCAL VARIABLE
local crops `r(varlist)'

*ADJUST THE LIST TO REFER TO THE SPECIFIC CROPS - REMOVING THE "yie1886_hec_" PREFIX
local crops `"`=subinstr("`crops'", "yie1886_hec_", "", .)'"'

*LOOP THROUGH ALL THE CROPS, AND CALCULATE THE IMPLIED AREA AS THE PRODUCT OF THE 
*TOTAL YIELD AND THE YIELD PER HECTARE
foreach crop_x of local crops {
	gen impl_area_`crop_x' =  yie1886_tot_`crop_x' / yie1886_hec_`crop_x'
	}

*REMOVE THE YIELD VARIABLES (THESE WILL BE RECREATED AFTER THE COLLAPSE
drop yie1886_hec_* 

*GET A LIST OF VARIABLES TO COLLAPSE
ds county_highest kreiskey_highest, not

*STORE THIS LIST AS A LOCAL VARIABLE
local vars `r(varlist)'

*COLLAPSE ACROSS COUNTIES TO THE HIGHEST KREISKEY 
collapse (sum) `vars', by(county_highest kreiskey_highest)

*NOW THAT WE HAVE COLLAPSED THE DATA, WE CAN NOW RECREATE THE YIELD PER HECTARE
foreach crop_x of local crops {
	gen yie1886_hec_`crop_x' = yie1886_tot_`crop_x' / impl_area_`crop_x'
	}

*REMOVE THE IMPLIED AREA VARIABLES, NO LONGER NECESSARY
drop impl_area*	
	
*SAVE DATASET
save "$data/year_merged_summed/1886", replace


*LOAD THE 1849 DATA
use "$data/year_merged_summed/1849", clear
 
 

*LIST OF YEARS TO LOOP THROUGH
local yearlist "1858 1866 1883 1886 1888 1892 1896 1901"

*LOOP THROUGH ALL YEARS EXCEPT 1849
foreach year of local yearlist {
	
	display `year'
	
	*MERGE BASED ON THE HIGH LEVEL KREISKEY
	merge 1:1 kreiskey_highest using "$data/year_merged_summed/`year'"
	drop _m

}

*SAVE THE DATASET
save "$data/aggregated dataset (all years)", replace
