
/*
**	msg = kn_returnservsockmsg(sock, msg)
**
**	return message to server socket.
**
*/

TVOID kn_returnservsockmsg(TAPTR knsock, TMSG *msg)
{
	struct knservsocket *s = (struct knservsocket *) knsock;
	knnetmsg *netmsg = (knnetmsg *) msg->sender;
	struct knsrvnode *cnode = (struct knsrvnode *) netmsg->backptr;
	kn_sockenv_t *sockenv = &s->sockenv;

	TRemove((TNODE *) cnode);		/* remove from userlandlist */

	if (netmsg->nethead.protocol == KNSOCK_PROTO_PUTREPLY)
	{
		switch (msg->status)
		{
			case TMSG_STATUS_REPLIED:

				cnode->bytestowrite = netmsg->nethead.msgsize;
				netmsg->nethead.msgsize = htonl(netmsg->nethead.msgsize);
				netmsg->nethead.protocol = KNSOCK_PROTO_REPLY;			/* reply message */
	
				dbsprintf(3, "*** TEKLIB kn_returnservsockmsg: replymsg put to writelist\n");
				break;

			case TMSG_STATUS_ACKD:

				cnode->bytestowrite = sizeof(knnethead);				/* send back header only */
				netmsg->nethead.msgsize = htonl(sizeof(knnethead));		
				netmsg->nethead.protocol = KNSOCK_PROTO_ACK;			/* ack message */

				TFreeMsg(cnode->bufmsg + 1);							/* free msg body */

				cnode->bufmsg = TNULL;
	
				dbsprintf(3, "*** TEKLIB kn_returnservsockmsg: ackmsg put to writelist\n");
				break;

			case TMSG_STATUS_FAILED:

				/*FD_CLR(cnode->desc, &s->readset);*/

				TFreeMsg(cnode->bufmsg + 1);

				cnode->bufmsg = TNULL;
				
				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);

				dbsprintf(5, "*** TEKLIB kn_returnservsockmsg: returned failed message\n");

				return;
			
			default:

				dbsprintf(20, "*** TEKLIB returnservsocket: unknown message status\n");
	
				TFreeMsg(cnode->bufmsg + 1);
					
				TAddTail(&s->freelist, (TNODE *) cnode);
				return;
		}

		netmsg->nethead.version = KNSOCK_VERSION;

		cnode->bytesdone = 0;
		FD_SET(cnode->desc, &s->writeset);
		TAddTail(&s->writelist, (TNODE *) cnode);
	}
	else
	{
		TFreeMsg(cnode->bufmsg + 1);

		cnode->bufmsg = TNULL;
		cnode->bytesdone = 0;
		FD_SET(cnode->desc, &s->readset);
		TAddTail(&s->readlist, (TNODE *) cnode);

		dbsprintf(3, "*** TEKLIB: kn_returnservsockmsg: returned one-way msg\n");
	}
}
