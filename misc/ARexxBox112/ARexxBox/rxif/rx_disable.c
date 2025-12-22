
/*
 * Dieses Kommando sollte besser auch Kommandos lokal zu einem
 * Host beeinflussen können. Vorschlag: Zusätzlicher Switch
 * "GLOBAL/S" (Default wäre damit LOKAL).
 *
 */

void rx_disable( struct RexxHost *host, struct rxd_disable **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_disable *rd = *rxd;
	char **s;
	struct rxs_command *rxc;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
			if( rd = *rxd )
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			
			if( s = rd->arg.names )
			{
				for( ; *s; s++ )
				{
					if( rd->arg.global )
					{
						if( rxc = FindRXCommand( *s ) )
							rxc->flags &= ~ARB_CF_ENABLED;
					}
				}
			}
			
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			free( rd );
			break;
	}
	return;
}

