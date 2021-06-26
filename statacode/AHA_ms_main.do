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
	if "`nodata'"=="nodata" exit


/*
--------------------------------------------

Data generation

--------------------------------------------
*/

// Setting up the distance matrix
	qui do ${scMS}/AHA_ms_dmatrix.do

// Caclulating HHIs
	qui do ${scMS}/AHA_ms_hhi.do

// Calculating counts of hospitals
	qui do ${scMS}/AHA_ms_hcount.do
	
// Mergers? TBD



/*
--------------------------------------------

Example summary tables/figures

--------------------------------------------
*/




