/* Timer.e 28-07-16 by Christopher Steven Handley.
*/
/*
	This program times how long it takes to run the supplied Shell command.
*/

MODULE 'std/pShellParameters', 'std/pShell', 'std/pTime'

/* Shell arguments definition */
STATIC shellArgs = 'Command/F/A'
->index:            0

PROC main() RETURNS ret
	DEF command:ARRAY OF CHAR
	DEF before:BIGVALUE, after:BIGVALUE
	DEF loopsPerSec, loops, subSec
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	command := GetParam(0)
	
	->wait for start of next second
	before := CurrentTime(/*zone0local1utc2quick*/ 2)
	WHILE CurrentTime(2) = before DO EMPTY
	before++
	
	->perform request
	->before := CurrentTime(2)
	IF ExecuteCommand(command) = FALSE THEN Throw("EXE", command)
	after := CurrentTime(2)
	
	->measure how long until next second
	loops := 0
	WHILE CurrentTime(2) = after DO loops++
	
	->calibrate sub-second measurement
	after++
	loopsPerSec := 0
	WHILE CurrentTime(2) = after DO loopsPerSec++	->count number of loops in one second
	after--
	
	subSec := Bounds(loopsPerSec - loops * 100 / loopsPerSec, 0, 100-1)
	Print('The command took \d.\d[2] seconds to complete.\n', after - before !!VALUE, subSec)
FINALLY
	SELECT exception
	CASE 0
		ret := SHELL_RET_OK
	CASE "ERR"
		->(error already reported) so finish gracefully
		ret := SHELL_RET_ERROR
	CASE "ARGS"
		->(error already reported) so finish gracefully
		IF exceptionInfo THEN Print('ERROR:  \s\n', exceptionInfo)
		ret := SHELL_RET_ERROR
	CASE "EXE"
		Print('ERROR: Failed to execute \s\n', exceptionInfo)
		ret := SHELL_RET_ERROR
	CASE "MEM"
		Print('Ran out of memory\n')
		ret := SHELL_RET_FAIL
	DEFAULT
		PrintException()
		ret := SHELL_RET_FAIL
	ENDSELECT
ENDPROC
