*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"


use "$data/agg data with vars", replace

local crops "yie1886_hec_sry_* yie1886_hec_wry_* yie1886_hec_wwh_* yie1886_hec_swh_*  yie1886_hec_oat_*  yie1886_hec_sba_* yie1886_hec_wba_*"

local crops_tot "yie1886_tot_sry_* yie1886_tot_wry_* yie1886_tot_wwh_* yie1886_tot_swh_*  yie1886_tot_oat_*  yie1886_tot_sba_* yie1886_tot_wba_*"

*REGRESS THE PROPORTION OF FACTORY WORKERS ON THE INEQUALITY
ivreg2 factory_workers pop1849_m_tot yie1886_tot_swh* ///
 (inequality_1858 = loam_prop), robust
 
/*
ivreg2 prop_fact_workers `crops_tot' ///
 (inequality_1858 = loam_prop), robust
 
ivreg2 factory_numbers yie1886_tot_swh_* ///
 (inequality_1858 = loam_prop), robust

ivreg2 factory_prop_1849 yie1886_hec_swh_str yie1886_hec_swh_gra ///
 (inequality_1858 = loam_prop), robust

ivreg2 prop_farm_workers yie1886_hec_swh_str yie1886_hec_swh_gra ///
 (inequality_1858 = loam_prop), robust
 
 ivreg2 steam_engines  yie1886_hec_swh_str yie1886_hec_swh_gra  pop1849_m_tot ///
 (inequality_1858 = loam_prop), robust
 
 ivreg2 engine_power  pop1849_m_tot `crops' ///
 (inequality_1858 = loam_prop), robust
 
 
 *REGRESS THE PROPORTION OF FACTORY WORKERS ON THE INEQUALITY
ivreg2 prop_fact_workers yie1886_tot_swh* ///
 (inequality_1882 = loam_prop), robust
 
ivreg2 factory_numbers yie1886_tot_swh_* ///
 (inequality_1882 = loam_prop), robust

ivreg2 factory_prop_1849 yie1886_hec_swh_str yie1886_hec_swh_gra ///
 (inequality_1882 = loam_prop), robust

ivreg2 prop_farm_workers yie1886_hec_swh_str yie1886_hec_swh_gra ///
 (inequality_1882 = loam_prop), robust
