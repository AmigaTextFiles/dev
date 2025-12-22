/* cCharset.e 17-01-2015
	Windows-specific implementation.
*/

PROC infoSystemCharset() RETURNS charset:ARRAY OF CHAR
	charset := 'Windows-1252'
ENDPROC
