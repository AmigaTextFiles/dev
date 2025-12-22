/***************************************************************************/
/*                CatIFF.rexx - join several IFF's together                */
/*                       Written by Michael Letowski                       */
/*                    $VER: CatIFF.rexx 37.1 (26.3.94)                     */
/***************************************************************************/

PARSE ARG commonID destFile srcFiles 

IF commonID='' | destFile='' | srcFiles='' THEN
DO
	SAY 'Usage: CatIFF <commonID> <destFile> <srcFiles>'
	EXIT 20
END

IF ~OPEN(DestFH,destFile,'W') THEN
DO
	SAY 'Unable to open output file!'
	EXIT 20
END

Size=0
ThisFile=''
DO I=1 UNTIL ThisFile=''
	ThisFile=WORD(srcFiles,I)
	IF ThisFile~=='' THEN
		IF ~OPEN(SrcFH,ThisFile,'R') THEN
		DO
			SAY 'Unable to open input file' "'"ThisFile"'"
			EXIT 20
		END
		ELSE
		DO
			SrcFiles.I=READCH(SrcFH,65536)
			Size=Size+LENGTH(SrcFiles.I)
			CALL CLOSE(SrcFH)
		END
END
Max=I-1

CALL WRITECH(DestFH,'CAT ')
CALL WRITECH(DestFH,Long(Size+4))
CALL WRITECH(DestFH,PadR(commonID))
DO I=1 TO Max
	CALL WRITECH(DestFH,SrcFiles.I)
END

EXIT

Long:	PROCEDURE
	PARSE ARG num .
RETURN RIGHT(D2C(num),4,'0'X)

PadR:	PROCEDURE
	PARSE ARG string
RETURN LEFT(string,4,'0'X)

