/* pAmigaUtility.e 12-06-2015
	An easy way to share an automatically opened library base for the Utility library.		->NOT YET: A collection of useful procedures/wrappers for the Utility library.
	Copyright (c) 2016 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

PUBLIC MODULE 'utility'
MODULE 'exec'

PROC new()
	utilitybase := OpenLibrary('utility.library', 0)
ENDPROC

PROC end()
	CloseLibrary(utilitybase)
ENDPROC

/*****************************/
