*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"


use  "$data/aggregated dataset (all years)", clear

*CALCULATE THE PROPORTION OF TOTAL LAND AREA WHICH IS A LOAMY SOIL
gen loam_prop = (soil1866_are_loam_hig +soil1866_are_loam_riv) / soil1866_are_tot

gen sand_prop = (soil1866_are_san / soil1866_are_tot)

gen inequality_1849 = (land1849_far_ext_ov600 + land1849_far_ext_300to600) / ///
(land1849_far_ext_ov600 + land1849_far_ext_300to600 + ///
land1849_far_ext_30to300 + land1849_far_ext_5to30 + land1849_far_ext_un5)


*CALCULATE THE FRACTION OF LANDHOLDINGS WHICH ARE OVER 300 PM IN 1858
gen inequality_1858 = (land1858_far_ext_ov600 + land1858_far_ext_300to600) / ///
(land1858_far_ext_ov600 + land1858_far_ext_300to600 + ///
land1858_far_ext_30to300 + land1858_far_ext_5to30 + land1858_far_ext_und5)

*CALCULATE THE FRACTION OF LANDHOLDINGS WHICH ARE OVER 100 HA IN 1882
gen inequality_1882 = (land1882_far_ext_ov100) / ///
(land1882_far_ext_ov100 + land1882_far_ext_50to100 +land1882_far_ext_10to50 + ///
land1882_far_ext_2to10 + land1882_far_ext_1to2 + land1882_far_ext_un1)

gen factories_iron = fac1849_ironworks_factories
gen factories_steel = fac1849_steel_factories



*CALCULATE THE NUMBER OF LOOMS
gen loom_fabrics_1849 = fac1849_looms_silk_looms + fac1849_looms_cotton_looms + ///
fac1849_looms_linen_looms + fac1849_looms_wool_looms 

*CALCULATE THE NUMBER OF POWERLOOMS
gen factory_fabrics_1849 = fac1849_wool_cloth_looms + fac1849_halfwool_cloth_looms + ///
fac1849_cotton_looms + fac1849_linen_looms +  fac1849_silk_looms
/*
*ADD IN HANDLOOMS
replace factory_fabrics_1849 = factory_fabrics_1849 + fac1849_wool_cloth_handlooms + fac1849_halfwool_cloth_handlooms + ///
fac1849_cotton_handlooms + fac1849_linen_handlooms +  fac1849_silk_handlooms
*/

*CALCULATE THE PROPORTION OF FABRICS MANUFACTURED IN A FACTORY
gen factory_prop_1849 = factory_fabrics_1849 / (loom_fabrics_1849)

*CALCULATE THE TOTAL NUMBER OF 1849 FACTORY WORKERS
egen factory_workers = rowtotal(fac1849_*_workers)

*CALCULATE THE TOTAL NUMBER OF 1849 FACTORIES
egen factory_numbers = rowtotal(fac1849_*_factories)

*CALCULATE THE PROPORTION OF FACTORY WORKERS RELATIVE TO THE MALE ADULT POPULATION
gen prop_fact_workers = factory_workers / pop1849_tot

*PROPORTION OF POPULATION WITH FARMING AS THE MAIN OCCUPATION
gen prop_farm_workers = occ1849_farming_main_occu / pop1849_tot

*NUMBER OF LOOMS
egen number_looms = rowtotal(fac1849_*_looms)

*NUMBER OF HANDLOOMS
egen number_handlooms = rowtotal(fac1849_*_handlooms)


*TOTAL NUMBER OF STEAM ENGINES
egen steam_engines = rowtotal(steam1849_*_engines)

gen engines_pp = steam_engines / pop1849_tot

egen engine_power = rowtotal(steam1849_*_horsepower)

gen handloom_ratio =  number_handlooms / number_looms 

gen agriculture1882 = occ1882_se_agr_pr + occ1882_emp_agr_pr
gen agriculture1849 = occ1849_farming_main_occu

**** REMOVE UNNECESSARY VARIABLES ****

drop rel*
drop dis*
drop occ1849*
drop mill*
drop buil1849*
drop edu*
drop wage1892*
drop yie1896*
drop wage1901*
drop ani*
drop occ1882*
/*
drop yie1886_tot*
drop fac1849*
drop steam1849*
drop land*
drop misc1858_area

*KEEP YIELDS FOR THE FOLLOWING CROPS:
*winter wheat, winter rye, summer barley, oats and potatoes

drop yie1886*str

drop yie1886_hec_swh_gra yie1886_hec_wsp_gra yie1886_hec_ssp_gra yie1886_hec_wei_gra yie1886_hec_sei_gra
drop yie1886_hec_sry_gra yie1886_hec_wba_gra yie1886_hec_pea_fru yie1886_hec_fbe_fru yie1886_hec_vet_fru yie1886_hec_lup_fru
drop yie1886_hec_pot_dis-yie1886_hec_whi_hec yie1886_hec_buc_gra

drop pop1849_families-pop1849_f_tot 

*drop soil*

**** RENAMING ****

ren yie1886_hec_wwh_gra yield_wheat
ren yie1886_hec_wry_gra yield_rye
ren yie1886_hec_sba_gra yield_barley
ren yie1886_hec_oat_gra yield_oats
ren yie1886_hec_pot_tub yield_potatoes

ren pop1849_tot population_1849


*/
drop yie1886_hec*
drop fac1849*
drop steam1849*
drop land*
drop misc1858_area


*KEEP YIELDS FOR THE FOLLOWING CROPS:
*winter wheat, winter rye, summer barley, oats and potatoes

drop yie1886*str

drop yie1886_tot_swh_gra yie1886_tot_wsp_gra yie1886_tot_ssp_gra yie1886_tot_wei_gra yie1886_tot_sei_gra
drop yie1886_tot_sry_gra yie1886_tot_wba_gra yie1886_tot_pea_fru yie1886_tot_fbe_fru yie1886_tot_vet_fru yie1886_tot_lup_fru
drop yie1886_tot_pot_dis-yie1886_tot_whi_hec yie1886_tot_buc_gra

drop pop1849_families-pop1849_f_tot 

drop soil*

**** RENAMING ****

ren yie1886_tot_wwh_gra yield_wheat
ren yie1886_tot_wry_gra yield_rye
ren yie1886_tot_sba_gra yield_barley
ren yie1886_tot_oat_gra yield_oats
ren yie1886_tot_pot_tub yield_potatoes

ren pop1849_tot population_1849
*/
**** LABELLING ****


lab var kreiskey1800 "Kreiskey"
lab var population_1849 "Population 1849"
lab var yield_wheat "Yield (Winter Wheat) 1886"
lab var yield_rye "Yield (Winter Rye) 1886"
lab var yield_barley "Yield (Summer Barley) 1886"
lab var yield_oats "Yield (Oats) 1886"
lab var yield_potatoes "Yield (Potatoes) 1886"
lab var loam_prop "Proportion of Loamy Soil"
lab var sand_prop "Proportion of Sandy Soil"
lab var inequality_1849 "Share of Large Estates (1849)"
lab var inequality_1858 "Share of Large Estates (1858)"
lab var inequality_1882 "Share of Large Estates (1882)"
lab var loom_fabrics_1849 "Number of Fabric Looms (1849)"
lab var factory_fabrics_1849 "Number of Fabric Power Looms (1849)"
lab var factory_prop_1849 "Power Looms-Looms Ratio"
lab var factory_workers "Number of Workers in Factories"
lab var factory_numbers "Number of Factories"
lab var prop_fact_workers "Proportion of Workers in Factory"
lab var prop_farm_workers "Proportion of Workers in Agriculture"
lab var number_looms "Number of Looms"
lab var number_handlooms "Number of Handlooms"
lab var steam_engines "Number of Steam Engines"
lab var engines_pp "Steam Engines per Capita"
lab var engine_power "Steam Engine Power (HP)"
lab var handloom_ratio "Ratio of Handlooms to Looms"
lab var factories_iron "Ironworks"
lab var factories_steel "Steelworks"



save "$data/agg data with vars", replace
