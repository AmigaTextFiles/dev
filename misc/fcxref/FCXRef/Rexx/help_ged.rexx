/* $VER: 1.0, ©1996 Dietmar Eilert. Empty GoldED macro */

OPTIONS RESULTS                             /* enable return codes     */

if (LEFT(ADDRESS(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */
    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */
if (RC ~= 0) then
    exit

OPTIONS FAILAT 6                            /* ignore warnings         */
SIGNAL ON SYNTAX                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

GEDport = address()

QUERY WORD
func=result

if ~show(ports, FASTCREF) then
 do
  ADDRESS 'COMMAND' 'run >nil: Work:C/cref/FastCXRef XREFFILE=Work:C/cref/full3xref'
  ADDRESS 'COMMAND' 'SYS:REXXC/WaitForPort FASTCREF'
 end

ADDRESS FASTCREF

SEARCH stem a. WORD func

address value GEDport

if a.filename ~= "NONE" then do
	if a.filename ~= "OFF" then do

		OPEN FAST NEW NAME a.filename
		SET READONLY TRUE
		GOTO a.linenumber

	end
end
else do
	'REQUEST BODY "' func 'not found"'
end

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

