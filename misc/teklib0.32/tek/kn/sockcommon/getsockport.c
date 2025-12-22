
/*
**
**	TUINT16 kn_getsockport(knsockobj *name)
**
**	return port number from a kernel sockname object.
**
*/

TUINT16 kn_getsockport(knsockobj *name)
{
	return ntohs(((struct sockaddr_in *) name)->sin_port);
}
