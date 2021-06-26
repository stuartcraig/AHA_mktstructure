/*------------------------------------------------------------ AHA_ms_dmatrix.do
Creates the distance matrix used for all other analysis

Stuart Craig
*/

	forval y=2001/2014 {
	qui {
	// Saving to temp directory (large intermediate files)
	cap confirm file ${tMS}/AHA_ms_dmatrix_`y'.dta
	if _rc!=0 {
		// The full joinby is quite large, do each year at a time to save RAM
		use if year==`y' using ${ddMS}/HC_ext_mergerdata_public.dta, clear
		
		// Create a RHS version of the hospitals
		keep id year sysid lat lon
		rename * r_*
		rename r_year year
		tempfile r
		save `r'
		
		// LHS version are the market centroids
		rename r_* l_*
		
		// Create full pairwise combo
		cross using `r'
		geodist r_lat r_lon l_lat l_lon, generate(distance) miles
		
		// Never going to consider markets to be larger than 200m
		keep if distance<=200
		keep ?_id ?_sysid year distance
		compress
		save ${tMS}/AHA_ms_dmatrix_`y'.dta, replace
	}
	}
	di `y', _c
	}

exit
