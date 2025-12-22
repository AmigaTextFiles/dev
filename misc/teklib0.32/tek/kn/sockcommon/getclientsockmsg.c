
/*
**
**	msg = kn_getclientsockmsg(sock)
**
**	get next pending message from client socket's delivery queue.
*/

TMSG *kn_getclientsockmsg(TAPTR knsock)
{
	struct knclientsocket *s = (struct knclientsocket *) knsock;
	struct knclinode *cnode = (struct knclinode *) TRemHead(&s->deliverlist);
	if (cnode)
	{
		cnode->msg->sender = &s->netmsg;
		TAddTail(&s->freelist, (TNODE *) cnode);
		return cnode->msg;
	}
	return TNULL;
}
