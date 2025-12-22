
static int clientprocwrite(struct knclientsocket *s, struct knclinode *cnode);
static int clientprocread(struct knclientsocket *s);

/*
**
**	newmsg = kn_waitclientsock(sock, event)
**
**	process messages from socket and wait for an event to occur.
**	returns the number of messages processed.
**
**	TODO: only abandon single messages on individual timeouts,
**	not the entire socket!
*/

TUINT kn_waitclientsock(TAPTR knsock, TKNOB *event)
{
	struct knclientsocket *s = (struct knclientsocket *) knsock;
	kn_sockenv_t *sockenv = &s->sockenv;

	int numready;
	TUINT numprocessed = 0;
	TBOOL signal_occured;

	if (s->status == SOCKSTATUS_BROKEN)
	{
		struct timeval waittimeout = {0, TIMEOUT_USEC};

		/*
		**	spool out pending replies
		*/
		
		struct knclinode *cnode;
		TUINT deliver = 0;
		
		while ((cnode = (struct knclinode *) TRemHead(&s->readlist)))
		{
			cnode->msg->status = TMSG_STATUS_FAILED;
			TAddTail(&s->deliverlist, (TNODE *) cnode);
			deliver++;
		}

		while ((cnode = (struct knclinode *) TRemHead(&s->writelist)))
		{
			cnode->msg->status = TMSG_STATUS_FAILED;
			TAddTail(&s->deliverlist, (TNODE *) cnode);
			deliver++;
		}
		
		if (deliver)
		{
			dbsprintf(2, "*** TEKLIB kn_waitclientsock: spooling out pending replies from broken socket\n");
			return deliver;
		}

		dbsprintf(2, "*** TEKLIB kn_waitclientsock: waiting for event on broken socket\n");
		kn_timedwaitevent(event, s->timer, (TTIME *) &waittimeout);
		return 0;
	}

	if (!TListEmpty(&s->deliverlist))
	{
		return 0;
	}

	do
	{
		int do_select = 0;
		if (TListEmpty(&s->readlist))
		{
			FD_CLR(s->desc, &s->readset);
		}
		else
		{
			FD_SET(s->desc, &s->readset);
			do_select = 1;
		}

		if (TListEmpty(&s->writelist))
		{
			FD_CLR(s->desc, &s->writeset);
		}
		else
		{
			FD_SET(s->desc, &s->writeset);
			do_select = 1;
		}

		if (do_select)
		{
			struct timeval waittimeout = {0, TIMEOUT_USEC};

			dbsprintf(2, "*** kn_waitclientsock: select\n");
			numready = kn_waitselect(sockenv, FD_SETSIZE, &s->readset, &s->writeset, NULL, &waittimeout, event, &signal_occured);
			if (numready > 0)
			{
				if (FD_ISSET(s->desc, &s->readset))
				{
					numprocessed += clientprocread(s);
				}
				else if (FD_ISSET(s->desc, &s->writeset))
				{
					struct knclinode *cnode;
					while ((cnode = (struct knclinode *) TFirstNode(&s->writelist)))
					{
						if (!clientprocwrite(s, cnode))
						{
							break;
						}
						numprocessed++;
					}
				}
				else dbsprintf(20, "*** kn_waitclientsock: unknown descriptor\n");
			}
			else if (numready < 0)
			{
				dbsprintf(10, "*** kn_waitclientsocket: select()\n");
			}
		}
		else
		{
			TTIME tektime = {0, TIMEOUT_USEC};
		
			signal_occured = kn_timedwaitevent(event, s->timer, &tektime);

			dbsprintf(2, "*** kn_waitclientsock: timedwaitevent\n");
		}

		/*if (!numprocessed)*/
		{
			/*	handle timeout */

			TNODE *nextnode, *node = s->readlist.head;
			struct knclinode *cnode;
			TTIME now;
			TFLOAT nowf;

			kn_querytimer(s->timer, &now);
			nowf = TTIMETOF(&now);

			dbsprintf(3, "*** TEKLIB kn_waitclientsock: checking timeouts on readlist\n");
			while ((nextnode = node->succ))
			{
				cnode = (struct knclinode *) node;
				if (nowf - cnode->timestamp > s->msgtimeout)
				{
					/*
					**	TODO: only abandon THIS message, not the entire socket!
					*/
				
					dbsprintf(5, "*** TEKLIB kn_waitclientsock: message timeout!\n");

					s->status = SOCKSTATUS_BROKEN;
					numprocessed = 1;
					break;
				}
				node = nextnode;
			}
		}

	} while (!numprocessed && !signal_occured);

	return numprocessed;
}



/*
**	processed = clientprocwrite(knclientsock, knclinode)
**
**	write pending data from a client connection node.
*/

static int clientprocwrite(struct knclientsocket *s, struct knclinode *cnode)
{
	kn_sockenv_t *sockenv = &s->sockenv;
	int numwritten;

	if (cnode->bytesdone < sizeof(knnethead))
	{
		kn_locksock(sockenv);
	
		numwritten = send(s->desc,
			((char *) &cnode->nethead) + cnode->bytesdone,
			sizeof(knnethead) - cnode->bytesdone, KNSOCK_SENDFLAGS);
		
		kn_unlocksock(sockenv);
		
		if (numwritten == -1)
		{
			if (kn_getsockerrno(sockenv, s->desc) != EWOULDBLOCK)
			{
				dbsprintf(10, "*** TEKLIB: clientprocwrite: dropping connection due to unexpected error\n");
				s->status = SOCKSTATUS_BROKEN;
				TRemove((TNODE *) cnode);
				if (cnode->msg->replyport)
				{
					cnode->msg->status = TMSG_STATUS_FAILED;
					TAddTail(&s->deliverlist, (TNODE *) cnode);
				}
				else
				{
					TFreeMsg(cnode->msg + 1);
					TAddTail(&s->freelist, (TNODE *) cnode);
				}
				return 1;
			}
			dbsprintf(5, "*** TEKLIB clientprocwrite: send(1) would block\n");
			return 0;			/* msg header not yet complete, but no more data pending */
		}

		cnode->bytesdone += numwritten;
		
		if (cnode->bytesdone == sizeof(knnethead))
		{
			if (cnode->bytesdone == cnode->bytestowrite)
			{
				/* msg complete */

				TRemove((TNODE *) cnode);
				if (cnode->msg->replyport)
				{
					dbsprintf(3, "*** TEKLIB clientprocwrite: two-way message delivered\n");
					cnode->msg->status = TMSG_STATUS_SENT;
					TAddTail(&s->readlist, (TNODE *) cnode);
				}
				else
				{
					dbsprintf(3, "*** TEKLIB clientprocwrite: one-way messages processed\n");

					TFreeMsg(cnode->msg + 1);
					TAddTail(&s->freelist, (TNODE *) cnode);
				}
				return 1;
			}
		}
		else
		{
			return 0;			/* msg header not yet complete, but no more data pending */
		}
	}
	

	/*	write msg body */

	kn_locksock(sockenv);
	
	numwritten = send(s->desc,
		((char *) cnode->msg) + cnode->bytesdone - sizeof(knnethead) + sizeof(TMSG),
		cnode->bytestowrite - cnode->bytesdone, KNSOCK_SENDFLAGS);

	kn_unlocksock(sockenv);
	
	if (numwritten == -1)
	{
		if (kn_getsockerrno(sockenv, s->desc) != EWOULDBLOCK)
		{
			dbsprintf(10, "*** TEKLIB: clientprocwrite: dropping connection due to unexpected error\n");

			s->status = SOCKSTATUS_BROKEN;
			TRemove((TNODE *) cnode);
			if (cnode->msg->replyport)
			{
				cnode->msg->status = TMSG_STATUS_FAILED;
				TAddTail(&s->deliverlist, (TNODE *) cnode);
			}
			else
			{
				TFreeMsg(cnode->msg + 1);
				TAddTail(&s->freelist, (TNODE *) cnode);
			}
			return 1;
		}
		dbsprintf(5, "*** TEKLIB clientprocwrite: send(2) would block\n");
		return 0;
	}
	
	cnode->bytesdone += numwritten;

	if (cnode->bytesdone == cnode->bytestowrite)
	{
		/* msg complete */

		TRemove((TNODE *) cnode);
		if (cnode->msg->replyport)
		{
			dbsprintf(3, "*** TEKLIB clientprocwrite: two-way message delivered(2)\n");
			cnode->msg->status = TMSG_STATUS_SENT;
			TAddTail(&s->readlist, (TNODE *) cnode);
		}
		else
		{
			dbsprintf(3, "*** TEKLIB clientprocwrite: one-way message processed(2)\n");

			TFreeMsg(cnode->msg + 1);
			cnode->msg = TNULL;
			TAddTail(&s->freelist, (TNODE *) cnode);
		}
		return 1;
	}

	return 0;
}



/*
**	processed = clientprocread(knclientsock)
**
**	read pending data, and insert it to a client connection node.
*/

static int clientprocread(struct knclientsocket *s)
{
	kn_sockenv_t *sockenv = &s->sockenv;

	int numread;
	TUINT size, proto, msgID, version;
	TNODE *node, *nextnode;

	if (s->bytesdone < sizeof(knnethead))
	{
		/*	read msg header */

		kn_locksock(sockenv);

		numread = recv(s->desc, ((char *) &s->nethead) + s->bytesdone, sizeof(knnethead) - s->bytesdone, KNSOCK_RECVFLAGS);

		kn_unlocksock(sockenv);

		if (numread <= 0)
		{
			int sockerr = kn_getsockerrno(sockenv, s->desc);
			
			if (numread == 0 || sockerr != EWOULDBLOCK)
			{
				if (numread == 0)
				{
					dbsprintf(5, "*** TEKLIB clientprocread: end-of-file on descriptor - dropping connection\n");
				}
				else if (sockerr != EWOULDBLOCK)
				{
					dbsprintf(20, "*** TEKLIB clientprocread: unexpected error on descriptor - dropping connection\n");
				}
				
				s->status = SOCKSTATUS_BROKEN;
				s->bytesdone = 0;
				return 1;
			}
			else dbsprintf(3, "*** clientprocread: recv(1) would block\n");
			return 0;
		}
		
		s->bytesdone += numread;
		
		if (s->bytesdone != sizeof(knnethead))
		{
			return 0;
		}
		
		proto = s->nethead.protocol;
		version = s->nethead.version;

		if (version == KNSOCK_VERSION && (proto == KNSOCK_PROTO_REPLY || proto == KNSOCK_PROTO_ACK))
		{
			msgID = s->nethead.msgID = ntohl(s->nethead.msgID);
			
			/*	find matching message to this reply from network */
			
			node = s->readlist.head;
			while ((nextnode = node->succ))
			{
				if (((struct knclinode *) node)->msgID == msgID)
				{
					struct knclinode *cnode = (struct knclinode *) node;
				
					size = s->nethead.msgsize = ntohl(s->nethead.msgsize);
					
					if (size == sizeof(knnethead) && proto == KNSOCK_PROTO_ACK)
					{
						/* ackmsg complete - link to deliver list */
				
						dbsprintf(3, "*** TEKLIB clientprocread: delivering complete ack\n");
						TRemove(node);
						cnode->msg->status = TMSG_STATUS_ACKD;
						TAddTail(&s->deliverlist, node);
						s->clientnode = TNULL;
						s->bytesdone = 0;
						return 1;
					}

					if (proto == KNSOCK_PROTO_REPLY && size == cnode->msg->size - sizeof(TMSG) + sizeof(knnethead))
					{
						dbsprintf(3, "*** TEKLIB clientprocread: identified proper reply\n");
						s->clientnode = cnode;
						break;
					}

					dbsprintf(20, "*** TEKLIB clientprocread: illegal message size for correct msgID - dropping\n");

					s->status = SOCKSTATUS_BROKEN;
					TRemove(node);
					cnode->msg->status = TMSG_STATUS_FAILED;
					TAddTail(&s->deliverlist, node);
					s->bytesdone = 0;
					return 1;
				}
				node = nextnode;
			}
		}
		
		if (!s->clientnode)
		{
			dbsprintf(20, "*** TEKLIB clientprocread: illegal message - dropping connection\n");

			s->status = SOCKSTATUS_BROKEN;
			s->bytesdone = 0;
			return 1;
		}
	}

	if (s->bytesdone < s->clientnode->msg->size - sizeof(TMSG) + sizeof(knnethead))
	{
		/*	read msg body */

		kn_locksock(sockenv);
	
		numread = recv(s->desc,
			((char *) s->clientnode->msg) + s->bytesdone - sizeof(knnethead) + sizeof(TMSG),
			s->clientnode->msg->size - sizeof(TMSG) + sizeof(knnethead) - s->bytesdone, KNSOCK_RECVFLAGS);

		kn_unlocksock(sockenv);

		if (numread <= 0)
		{
			int sockerr = kn_getsockerrno(sockenv, s->desc);
			if (numread == 0 || sockerr != EWOULDBLOCK)
			{
				if (numread == 0)
				{
					dbsprintf(5, "*** TEKLIB clientprocread(2): end-of-file on descriptor - dropping connection\n");
				}
				else if (sockerr != EWOULDBLOCK)
				{
					dbsprintf(20, "*** TEKLIB clientprocread(2): unexpected error on descriptor - dropping connection\n");
				}

				s->status = SOCKSTATUS_BROKEN;
				TRemove((TNODE *) s->clientnode);
				s->clientnode->msg->status = TMSG_STATUS_FAILED;
				TAddTail(&s->deliverlist, (TNODE *) s->clientnode);
				s->clientnode = TNULL;
				s->bytesdone = 0;
				return 1;
			}
			else dbsprintf(3, "*** clientprocread: recv(2) would block\n");

			return 0;	/* msg header not yet complete, but no more data pending */
		}
		
		s->bytesdone += numread;
	}

	if (s->bytesdone == s->clientnode->msg->size - sizeof(TMSG) + sizeof(knnethead))
	{
		/* replymsg complete - link to deliver list */

		dbsprintf(3, "*** TEKLIB clientprocread: delivering complete reply\n");
		TRemove((TNODE *) s->clientnode);

		s->clientnode->msg->status = TMSG_STATUS_REPLIED;
			/*s->clientnode->msg->status = s->nethead.protocol == TMSG_STATUS_REPLIED;		 ???? */
		
		TAddTail(&s->deliverlist, (TNODE *) s->clientnode);
		s->clientnode = TNULL;
		s->bytesdone = 0;
		return 1;
	}

	return 0;
}
