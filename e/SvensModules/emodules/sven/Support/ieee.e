/* useful E-procs (integer) but this time for ieee numbers
*/

OPT MODULE
OPT EXPORT

PROC ieeeBounds(what,min,max) IS IF !what<min THEN min ELSE IF !what>max THEN max ELSE what
PROC ieeeMax(x,y) IS (IF (!x>y) THEN x ELSE y)
PROC ieeeMin(x,y) IS (IF (!x<y) THEN x ELSE y)

