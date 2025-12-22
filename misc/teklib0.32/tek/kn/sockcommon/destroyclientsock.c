
/*
**
**	kn_destroyclientsock(sock)
**
*/

TVOID kn_destroyclientsock(TAPTR knsock)
{
	struct knclientsocket *s = (struct knclientsocket *) knsock;
	kn_sockenv_t *sockenv = &s->sockenv;

	kn_locksock(sockenv);

	if (shutdown(s->desc, 2))
	{
		dbsprintf(10, "*** TEKLIB kn_destroyclientsock: shutdown()\n");
	}
	
	if (kn_closesocket(s->desc))
	{
		dbsprintf(10, "*** TEKLIB kn_destroyclientsock: close()\n");
	}

	kn_unlocksock(sockenv);
	
	TMMUFree(s->mmu, s);
}
