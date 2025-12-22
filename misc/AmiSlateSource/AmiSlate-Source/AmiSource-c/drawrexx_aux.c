/* Code I added to drawrexx.c. */
#ifndef DRAWREXX_AUX_C
#define DRAWREXX_AUX_C

#include <stdio.h>
#include <string.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <rexx/storage.h>
#include <rexx/rxslib.h>

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/rexxsyslib_protos.h>

#include "drawrexx.h"
#include "drawrexx_aux.h"

struct RexxState RexxState;

/* This code was under drc_cleanup.  Moved to its own function so that
   I can call it when *I* want! */
void ReplyAndFreeRexxMsg(BOOL BProcessResults)
{
	/* Generate all return values */
	if (BProcessResults == TRUE) ProcessResults();
	
	/* Release reply; this causes client script to resume execution */
	ReplyRexxCommand(RexxState.rexxmsg, RexxState.rc,  RexxState.rc2,  RexxState.result );
	
	/* benutzten Speicher freigeben */
	if(  RexxState.result ) FreeVec(  RexxState.result );
	FreeArgs(  RexxState.host->rdargs );
	if( RexxState.cargstr ) FreeVec( RexxState.cargstr );
	if( RexxState.array ) 
		(RexxState.rxc->function) (RexxState.host, 
			(void **) &RexxState.array, 
			RXIF_FREE,  RexxState.rexxmsg );
	if( RexxState.argb ) FreeVec( RexxState.argb );
	
	return;
}



void ProcessResults(void)
{	
	/* Resultat(e) auswerten */
	if( RexxState.rxc->results && RexxState.rc==0 &&
		(RexxState.rexxmsg->rm_Action & RXFF_RESULT) )
	{
		struct rxs_stemnode *stem, *s;
		
		stem = CreateSTEM( RexxState.rxc, RexxState.resarray, (char *)RexxState.argarray[1] );
		RexxState.result = CreateVAR( stem );
		
		if( RexxState.result )
		{
			if( RexxState.argarray[0] )
			{
				/* VAR */
				if( (long) RexxState.result == -1 )
				{
					RexxState.rc = 20;
					RexxState.rc2 = ERROR_NO_FREE_STORE;
				}
				else
				{
					char *rb;
					
					for( rb = (char *) RexxState.argarray[0]; *rb; ++rb )
						*rb = toupper( *rb );
					
					if( SetRexxVar( (struct Message *) RexxState.rexxmsg,
						*((char *)RexxState.argarray[0]) ? (char *)RexxState.argarray[0] : "RESULT",
						RexxState.result, strlen(RexxState.result) ) )
					{
						RexxState.rc = -10;
						RexxState.rc2 = (long) "Unable to set Rexx variable";
					}
					
					FreeVec( RexxState.result );
				}
				
				RexxState.result = NULL;
			}
			
			if( !RexxState.rc && RexxState.argarray[1] )
			{
				/* STEM */
				if( (long) stem == -1 )
				{
					RexxState.rc = 20;
					RexxState.rc2 = ERROR_NO_FREE_STORE;
				}
				else
				{
					for( s = stem; s; s = s->succ )
						RexxState.rc |= SetRexxVar( (struct Message *) RexxState.rexxmsg, s->name, s->value, strlen(s->value) );
					
					if( RexxState.rc )
					{
						RexxState.rc = -10;
						RexxState.rc2 = (long) "Unable to set Rexx variable";
					}
					
					if( RexxState.result && (long) RexxState.result != -1 )
						FreeVec( RexxState.result );
				}
				
				RexxState.result = NULL;
			}
			
			/* Normales Resultat: Möglich? */
			
			if( (long) RexxState.result == -1 )
			{
				/* Nein */
				RexxState.rc = 20;
				RexxState.rc2 = ERROR_NO_FREE_STORE;
				RexxState.result = NULL;
			}
		}		
		free_stemlist( stem );
	}
	return;
}

#endif
