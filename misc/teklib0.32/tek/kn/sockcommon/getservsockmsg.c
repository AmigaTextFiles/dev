
/*
**	msg = kn_getservsockmsg(sock)
**
**	return next pending message from server socket's delivery queue.
**
*/

TMSG *kn_getservsockmsg(TAPTR knsock)
{
	struct knservsocket *s = (struct knservsocket *) knsock;
	struct knsrvnode *cnode;

	cnode = (struct knsrvnode *) TRemHead(&s->deliverlist);
	if (cnode)
	{
		TAddTail(&s->userlandlist, (TNODE *) cnode);

			/*cnode->bufmsg->handle.mmu = s->mmu;
			cnode->bufmsg->handle.destroyfunc = (TDESTROYFUNC) TNULL;*/
		
		cnode->bufmsg->sender = &cnode->netmsg;
		cnode->bufmsg->size = cnode->netmsg.nethead.msgsize - sizeof(knnethead) + sizeof(TMSG);
		return cnode->bufmsg;		
	}
	
	return TNULL;
}

