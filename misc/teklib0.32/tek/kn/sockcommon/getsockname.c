
/*
**
**	TSTRPTR kn_getsockname(knsockobj *name)
**
**	return IP string from a kernel sockname object.
**
*/

TSTRPTR kn_getsockname(knsockobj *name)
{
	kn_sockenv_t se;
	kn_sockenv_t *sockenv = &se;

	if (kn_getsockenv(sockenv))
	{
		return kn_inet_ntoa(name);
	}

	return TNULL;
}
