/* ShowModule v1.0 (06.02.98) by Grio for GOLDED. */
/*   This script uses ShowModule  .  */


OPTIONS RESULTS

IF (LEFT(ADDRESS(),6)~="GOLDED") THEN ADDRESS 'GOLDED.1'
'REQUEST TITLE="ShowModule" FILE PATH="EModules:" VAR MODULE'
IF (rc==0) THEN ADDRESS COMMAND 'E:Bin/ShowModule' module

EXIT





