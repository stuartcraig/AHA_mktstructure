/*--------------------------------------------------------------- AHA_ms_main.do

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
	adopath + ${scMS}/ado
	if "`nodata'"=="nodata" exit


/*
--------------------------------------------

Data generation

--------------------------------------------
*/

// Setting up the distance matrix


// Caclulating HHIs
	qui do ${scMS}/AHA_ms_hhi.do
	

// Calculating counts of hospitals

