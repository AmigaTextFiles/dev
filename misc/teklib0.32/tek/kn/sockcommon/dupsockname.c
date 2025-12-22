
/*
**
**	success = kn_dupsockname(oldnameobj, newnameobj)
**
**	duplicate kernel sockname object.
**
*/

TBOOL kn_dupsockname(knsockobj *oldname, knsockobj *newname)
{
	kn_memcopy(oldname, newname, sizeof(struct sockaddr_in));
	return TTRUE;
}
