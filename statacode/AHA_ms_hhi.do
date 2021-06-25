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


/*
------------------------------------

HHI calculation

------------------------------------
*/	
	
	cap confirm file ${ddMS}/AHA_ms_hhis.dta
	if _rc!=0 {
		clear
		forval y=2001/2014 {
			append using ${tMS}/AHA_ms_dmatrix_`y'.dta
		}
		// Merging on beds!
		gen id = r_id
		merge m:1 id year using ${ddMS}/HC_ext_mergerdata_public.dta, ///
			assert(3) nogen keepusing(bdtot)
		tempfile dmatrix
		save `dmatrix'
		
		tempfile build
		loc ctr=0
		forval d=5(5)50 {
		qui {
			loc ++ctr
			use `dmatrix', clear
			keep if distance<=`d'
			gcollapse (sum) beds=bdtot, by(l_id year r_sysid) fast
			gegen mkt_tot = total(beds), by(l_id year)
			gen sqsh = (beds/mkt_tot)^2
			gcollapse (sum) hhi`d'=sqsh, by(l_id year) fast
			if `ctr'>1 merge 1:1 l_id year using `build', assert(3) nogen
			save `build', replace
		}
		di `d', _c
		}
		rename l_id id
		compress
		save ${ddMS}/AHA_ms_hhis.dta, replace
	}
	
exit
