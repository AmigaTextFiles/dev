/* CSH/pAmiga_realNewProcess.e 15-12-2010
	An easy-to-use wrapper for CreateNewProc().
	Copyright (c) 2009, 2010 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

MODULE 'dos', 'exec'
MODULE 'utility/tagitem'

/*****************************/

->NOTE: Use NP_STACKSIZE to change stack size.
PROC createChildProcess(procedure:PTR, parameter=0, name=NILA:ARRAY OF CHAR, tagList=NILA:ARRAY OF tagitem) RETURNS child:PTR TO process
	DEF paramValue[9]:STRING
	
	StringF(paramValue, '$\h\n', parameter)
	
	child := CreateNewProc([
		IF name THEN NP_NAME ELSE TAG_IGNORE, name,
		NP_ENTRY, procedure,
		NP_ARGUMENTS, paramValue,
		IF tagList THEN TAG_MORE ELSE TAG_END, tagList
	]:tagitem)
ENDPROC

PROC infoParameterOfChildProcess() RETURNS parameter
	DEF process:PTR TO process
	
	process := FindTask(NILA) !!PTR
	parameter := Val(process.arguments)
ENDPROC
