
/*
**
**	cmpresult = kn_cmpsockname(nameobj1, nameobj2)
**
**	compare two kernel socket name objects.
**
*/

TUINT kn_cmpsockname(knsockobj *name1, knsockobj *name2)
{
	if (((struct sockaddr_in *) name1)->sin_addr.s_addr == ((struct sockaddr_in *) name2)->sin_addr.s_addr)
	{
		if (((struct sockaddr_in *) name1)->sin_port == ((struct sockaddr_in *) name2)->sin_port)
		{
			return KNSOCK_NAME_EQUAL;
		}
		return KNSOCK_NAME_SAMEHOST;
	}
	return KNSOCK_NAME_DIFFER;
}
