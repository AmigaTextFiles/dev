
void rx_fault( struct RexxHost *host, struct rxd_fault **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_fault *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			if( rd->res.description = malloc(256) )
			{
				if( !Fault( *rd->arg.number, "DESC",
					rd->res.description, 256 ) )
				{
					rd->rc = -10;
					rd->rc2 = (long) "FAULT failed";
				}
			}
			else
			{
				rd->rc = 10;
				rd->rc2 = ERROR_NO_FREE_STORE;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			if( rd->res.description )
				free( rd->res.description );
			free( rd );
			break;
	}
	return;
}

