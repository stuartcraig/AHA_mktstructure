/*---------------------------------------------------------------- AHA_ms_hhi.do
File to compute HHIs using the Cooper et al. (2019) merger roster

Stuart Craig
*/


qui do ~/Dropbox/aha_comp/AHA_mktstructure/statacode/AHA_ms_main.do nodata


/*
------------------------------------

Build the distance matrices

------------------------------------
*/
	
	forval y=2001/2014 {
	qui {
	cap confirm file ${tMS}/AHA_ms_dmatrix_`y'.dta
	if _rc!=0 {
		use if year==`y' using ${ddMS}/HC_ext_mergerdata_public.dta, clear
		keep id year sysid lat lon
		rename * r_*
		rename r_year year
		tempfile r
		save `r'
		rename r_* l_*
		cross using `r'
		geodist r_lat r_lon l_lat l_lon, generate(distance) miles
		keep if distance<=200
		keep ?_id ?_sysid year distance
		compress
		save ${tMS}/AHA_ms_dmatrix_`y'.dta, replace
	}
	}
	di `y', _c
	}


exit
