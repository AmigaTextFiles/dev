
static void destroyservsocklist(kn_sockenv_t *sockenv, struct knservsocket *s, TLIST *list, TBOOL check);

/*
**
**	kn_destroyservsock(knsocket)
**
**	destroy server socket
**
*/

TVOID kn_destroyservsock(TAPTR knsock)
{
	struct knservsocket *s = (struct knservsocket *) knsock;
	kn_sockenv_t *sockenv = &s->sockenv;

	destroyservsocklist(sockenv, s, &s->userlandlist, TTRUE);
	destroyservsocklist(sockenv, s, &s->readlist, TFALSE);
	destroyservsocklist(sockenv, s, &s->writelist, TFALSE);
	destroyservsocklist(sockenv, s, &s->deliverlist, TFALSE);

	kn_locksock(sockenv);
	kn_closesocket(s->desc);
	kn_unlocksock(sockenv);

	TMMUFree(s->mmu, s);
}


static void destroyservsocklist(kn_sockenv_t *sockenv, struct knservsocket *s, TLIST *list, TBOOL check)
{
	struct knsrvnode *cnode;
	TNODE *nextnode, *node = list->head;
	while ((nextnode = node->succ))
	{
		cnode = (struct knsrvnode *) node;

		if (check)
		{
			if (cnode->bufmsg)
			{
				if (cnode->bufmsg->status & TMSG_STATUS_PENDING)
				{
					dbsprintf(10, "*** TEKLIB kn_destroyservsock: unlinking message from messageport\n");
					TRemove(&cnode->bufmsg->handle.node);
				}
				else dbsprintf(20, "*** TEKLIB kn_destroyservsock WARNING: message lost in userland\n");
	
			} else dbsprintf(30, "*** TEKLIB kn_destroyservsock ALERT: SEVERE MSGLIST CORRUPTION\n");
		}

		if (cnode->bufmsg)
		{
			TFreeMsg(cnode->bufmsg + 1);
		}

		kn_locksock(sockenv);
		shutdown(cnode->desc, 2);
		kn_closesocket(cnode->desc);
		kn_unlocksock(sockenv);
		
		node = nextnode;
	}
}

