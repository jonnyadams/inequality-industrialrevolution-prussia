
*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

cd "$rawdata"

*GET LIST OF FILES IN THE RAW DATA DIRECTORY
local files: dir "$rawdata" files *
/*
local files `""'
local files `" `files' ipehd_1849_indu_fac ipehd_1849_indu_tec ipehd_1849_indu_trans "'
local files `" `files' ipehd_1858_agri_land ipehd_1866_agri_soils "'
local files `" `files' ipehd_1882_agri_land ipehd_1886_agri_yields ipehd_1886_wag_wages"'
local files `" `files' ipehd_1892_wag_wages ipehd_1896_agri_yields ipehd_1901_wag_wages"'
local files `" `files' "'
local files `" `files' "'
local files `" `files' "'
local files `" `files' "'
*/
*LOOP THROUGH THE FILES
foreach file_x of local files { 
	
	display "Importing `file_x'"
	
	*IMPORT THE DATA
	import delimited "$rawdata/`file_x'", clear 
	
	ds kreiskey
	local year = regexr("`r(varlist)'", "kreiskey", "")
	display "`year'"
	
	*REMOVE THE .CSV TO SAVE AS A STATA DATASET
	local clean_name `"`=regexr("`file_x'", ".csv", "")'"'
	
	local clean_name `"`=regexr("`clean_name'", "[0-9][0-9][0-9][0-9]", "`year'")'"'
	
	*SAVE THE DATASET
	save "$data/initial files/`clean_name'", replace

}

