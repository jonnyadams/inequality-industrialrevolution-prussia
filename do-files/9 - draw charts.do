*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

ssc install blindschemes

clear all
use  "$data/merged data for regression", replace

# delimit ;
twoway (scatter soil_loam_pc std_land_timespec1849,
		msymbol(D))
		(lfit soil_loam_pc std_land_timespec1849)
		, 
		ytitle("Proportion of Loamy Soil")
		xtitle("Standardised Share of Large Estates")
		legend(off)
		scheme(plotplainblind)
		;
	
# delimit cr

graph export "$output/soil_land.png", width(3000) replace

histogram steam_engines, scheme(plotplain)

graph export "$output/steam_engines.png", width(3000) replace


# delimit ;
twoway (scatter prop_fact_workers prop_farm_workers,
		msymbol(D))
		(qfit prop_fact_workers prop_farm_workers)
		, 
		ytitle("Population Share Employed in Factories")
		xtitle("Population Share Employed in Agriculture")
		legend(off)
		scheme(plotplainblind)
		;
	
# delimit cr


graph export "$output/farm_fact.png", width(3000) replace


# delimit ;
twoway (scatter agriculture1882 agriculture1849 if agriculture1882 < 100000,
		msymbol(D))
		(function y = x if agriculture1849<100000, ra(agriculture1849) clpat(dash))
		, 
		ytitle("Agricultural Employees 1882")
		xtitle("Agricultural Employees 1849")
		legend(off)
		scheme(plotplainblind)
		ylabel(0 (20000) 100000)
		;
	
# delimit cr

graph export "$output/farm_decline.png", width(3000) replace


# delimit ;
graph hbar (asis) factory_prop_1849 if factory_prop_1849 > 0, over(kreiskey, label(nolabel) sort(factory_prop_1849) descending)
		legend(off)
		scheme(plotplainblind)
		ylabel(#10)
		;
	
# delimit cr

graph export "$output/fabric_prop.png", width(6000) replace



# delimit ;
twoway (scatter factory_prop_1849 loom_fabrics_1849,
		msymbol(D))
		, 
		legend(off)
		scheme(plotplainblind)
		;
	
# delimit cr

graph export "$output/loom_vol_vs_fac_prop.png", width(3000) replace



# delimit ;
twoway (scatter factory_fabrics_1849 loom_fabrics_1849,
		msymbol(D))
		(lfit factory_fabrics_1849 loom_fabrics_1849)
		,
		ytitle("Number of Fabric Power Looms (1849)")
		legend(off)
		scheme(plotplainblind)
		;
	
# delimit cr


graph export "$output/loom_vol_vs_fac_vol.png", width(3000) replace

