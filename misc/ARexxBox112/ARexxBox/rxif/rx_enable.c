
/*
 * Dieses Kommando sollte besser auch Kommandos lokal zu einem
 * Host beeinflussen können. Vorschlag: Zusätzlicher Switch
 * "GLOBAL/S" (Default wäre damit LOKAL).
 *
 */

void rx_enable( struct RexxHost *host, struct rxd_enable **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_enable *rd = *rxd;
	char **s;
	struct rxs_command *rxc;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
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
							rxc->flags |= ARB_CF_ENABLED;
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

