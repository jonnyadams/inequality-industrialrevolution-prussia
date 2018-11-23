*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

use "$data/land-concentration.dta", clear

global controlsols 	pop_urban_pc rel_prot_pc edu_schools_dens indu_pc agri_pc pop_young_old pop_nogerman_pc inheritance land_pc

keep kreiskey1800 soil_loam_pc year land_bigestates indu_pc agri_pc std_land_timespec $controlsols

reshape wide soil_loam_pc land_bigestates std_land_timespec $controlsols, j(year) i(kreiskey1800)

drop soil_loam_pc1849 soil_loam_pc1864 soil_loam_pc1886 soil_loam_pc1896

rename soil_loam_pc1816 soil_loam_pc


regress std_land_timespec1849 soil_loam_pc

global controlsols1849 pop_urban_pc1849 rel_prot_pc1849 edu_schools_dens1849 indu_pc1849 agri_pc1849 pop_young_old1849 pop_nogerman_pc1849 inheritance1849 land_pc1849


regress std_land_timespec1849 soil_loam_pc $controlsols1849 

save "$data/cinnirella data", replace
