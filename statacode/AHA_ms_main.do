/*--------------------------------------------------------------- AHA_ms_main.do
Main control file for market structure measurement code

Stuart Craig
*/
args nodata


/*
--------------------------------------------

Settings

--------------------------------------------
*/

	global rootdir 	"~/Dropbox/aha_comp/AHA_mktstructure"
	global scMS	 	"${rootdir}/statacode"
	global ddMS		"${rootdir}/deriveddata"
	global rdMS		"${rootdir}/rawdata"
	global  tMS		"${rootdir}/temp"
	global  oMS		"${rootdir}/output"
	*cap mkdir ${tMS} // if you pulled down the github repo, you might not have this
	foreach stub in sc dd rd t o {
		cap mkdir ${`stub'MS}
	}
	adopath + ${scMS}/ado
	set scheme RR, perm
	graph set window fontface "Times"
	if "`nodata'"=="nodata" exit


/*
--------------------------------------------

Data generation

--------------------------------------------
*/

// Setting up the distance matrix
	qui do ${scMS}/AHA_ms_dmatrix.do

// Caclulating HHIs
	qui do ${scMS}/AHA_ms_hhis.do

// Calculating counts of hospitals
	qui do ${scMS}/AHA_ms_hcount.do
	
// Mergers? 


/*
--------------------------------------------

Example summary tables/figures

--------------------------------------------
*/

	use ${ddMS}/AHA_ms_hhis.dta, clear
	gcollapse (mean) hhi*, by(year) fast
	tw 	line hhi35 year || ///
		line hhi25 year || ///
		line hhi15 year, ///
		ylab(0.25(.15).70, format(%3.2f)) ytitle("HHI (Beds)") ///
		legend(order(1 "35m" 2 "25m" 3 "15m") ring(0) pos(4) row(1))
		
		
	
	






