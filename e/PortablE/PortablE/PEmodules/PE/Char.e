/* PE/Char.e 06-06-08
*/
OPT INLINE
MODULE 'target/PE/base'

PROC CharToUnsigned(char:CHAR) IS (IF char AND $FF00 THEN 256 + char ELSE char) !!VALUE		->was IF char < 0 THEN

PROC UnsignedToChar(pos) IS (IF pos > 127 AND ("\xF0" < 0) THEN pos - 256 ELSE pos) !!CHAR
