/*--------------------------------------------------------------- AHA_ms_main.do

Stuart Craig
*/
args nodata

global rootdir 	"~/Dropbox/aha_comp/AHA_mktstructure"
global scMS	 	"${rootdir}/statacode"
global ddMS		"${rootdir}/deriveddata"
global rdMS		"${rootdir}/rawdata"
global  tMS		"${rootdir}/temp"
global  oMS		"${rootdir}/output"
adopath + ${scMS}/ado

if "`nodata'"=="nodata" exit
