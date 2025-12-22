
/*
 * Pendant zu dieser Interface-Funktion ist die Routine
 *
 *     char *ExpandRXCommand( struct RexxHost *host, char *command );
 *
 * welche vom Parser bei unbekannten Kommandos aufgerufen wird.
 *
 * Dieses Kommando sollte auch zwischen lokalen und globalen
 * Aliases unterscheiden können. Vorschlag: Zusätzlicher Switch
 * "GLOBAL/S" (Default wäre damit LOKAL).
 *
 */

/* Implementation von Aliases kommt im nächsten Release */


#ifndef RX_ALIAS_C
#define RX_ALIAS_C

char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	return( NULL );
}

#endif


void rx_alias( struct RexxHost *host, struct rxd_alias **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_alias *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			free( rd );
			break;
	}
	return;
}

