/*
**
**	processed = kn_putclientsockmsg(sock, msg)
**
**	put message to socket.
**
**	returns TFALSE when the message must be resent later, i.e. when
**	local storage for KNSOCK_MAXPENDING messages is exhausted.
**
**	when the socket is not in SOCKSTATUS_CONNECTED state, messages
**	will be delivered with TMSG_STATUS_FAILED, and this functions
**	returns TTRUE.
**
*/

TBOOL kn_putclientsockmsg(TAPTR knsock, TMSG *msg)
{
	struct knclientsocket *s = (struct knclientsocket *) knsock;

	if (s->status == SOCKSTATUS_CONNECTED)
	{
		struct knclinode *cnode = (struct knclinode *) TRemHead(&s->freelist);
		if (cnode)
		{
			TTIME now;

			cnode->msg = msg;
			cnode->bytestowrite = msg->size - sizeof(TMSG) + sizeof(knnethead);
			cnode->bytesdone = 0;
			cnode->nethead.msgsize = htonl(cnode->bytestowrite);
			cnode->msgID = s->msgID++;
			cnode->nethead.msgID = htonl(cnode->msgID);
			cnode->nethead.protocol = msg->replyport ? KNSOCK_PROTO_PUTREPLY : KNSOCK_PROTO_PUT;

			kn_querytimer(s->timer, &now);
			cnode->timestamp = TTIMETOF(&now);
			
			cnode->nethead.version = KNSOCK_VERSION;

			TAddTail(&s->writelist, (TNODE *) cnode);
			return TTRUE;
		
		}
		else
		{
			dbsprintf(1, "*** kn_putclientsockmsg: socket message pool exhausted\n");
		}
	}
	else
	{
		dbsprintf(2, "*** kn_putclientsockmsg: socket not in connected state\n");

		if (msg->replyport)
		{
			struct knclinode *cnode = (struct knclinode *) TRemHead(&s->freelist);
			if (cnode)
			{
				/* two-way message failed */

				cnode->msg = msg;
				msg->status = TMSG_STATUS_FAILED;
				TAddTail(&s->deliverlist, (TNODE *) cnode);
				return TTRUE;
			}
		}
		else
		{
			/* one-way message failed */

			TFreeMsg(msg + 1);

			return TTRUE;
		}
	}

	return TFALSE;
}
