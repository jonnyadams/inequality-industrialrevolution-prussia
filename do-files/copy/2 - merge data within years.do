
*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"


local years "1849 1858 1866 1883 1886 1888 1892 1896 1901"

foreach year of local years {

	cd "$data/initial files"

	local files: dir "$data/initial files" files "*`year'*"

	display `"`files'"'
	local count = 0

	tempfile merged`year'


	foreach file_x of local files { 
		use "$data/initial files/`file_x'", clear
		
		if `count' > 0 { 
			merge 1:1 kreiskey`year' using `merged`year'', nogen
		}
		
		save `merged`year'', replace
		local `++count'
		}
	
	capture drop _merge
	
	save "$data/year_merged/`year'", replace

}
