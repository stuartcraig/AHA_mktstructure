/*------------------------------------------------------------- AHA_ms_hcount.do
File to compute HHIs using the Cooper et al. (2019) merger roster

Stuart Craig
*/

// Pre-load if not yet available -- other users will need to edit the path
	qui do ~/Dropbox/aha_comp/AHA_mktstructure/statacode/AHA_ms_main.do nodata


	cap confirm file ${ddMS}/AHA_ms_hcount.dta
	if _rc!=0 {
		clear
		forval y=2001/2014 {
			append using ${tMS}/AHA_ms_dmatrix_`y'.dta
		}
		tempfile dmatrix
		save `dmatrix'
		
		tempfile build
		loc ctr=0
		forval d=5(5)50 {
		qui {
			loc ++ctr
			use `dmatrix', clear
			keep if distance<=`d'
			keep l_id year r_sysid
			gduplicates drop
			qui gen hcount`d' = 1
			gcollapse (sum) hcount`d', by(l_id year) fast
			if `ctr'>1 merge 1:1 l_id year using `build', assert(3) nogen
			save `build', replace
		}
		di `d', _c
		}
		rename l_id id
		compress
		save ${ddMS}/AHA_ms_hcount.dta, replace
	}
	
exit

