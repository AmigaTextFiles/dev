
/*
**
**	success = kn_initsockname(nameobj, ipname, port)
**
**	initialize a kernel socket name object
**	with given IP name string and port number
**
*/

TBOOL kn_initsockname(knsockobj *sockname, TSTRPTR ipname, TUINT16 port)
{
	kn_sockenv_t se;
	kn_sockenv_t *sockenv = &se;

	if (kn_getsockenv(sockenv))
	{
		struct sockaddr_in *inetadr = (struct sockaddr_in *) sockname;

		inetadr->sin_family = AF_INET;

		if (port)
		{
			inetadr->sin_port = htons(port);
		}
	
		if (ipname)
		{
			inetadr->sin_addr.s_addr = inet_addr(ipname);
		}
		
		return TTRUE;
	}

	return TFALSE;
}
