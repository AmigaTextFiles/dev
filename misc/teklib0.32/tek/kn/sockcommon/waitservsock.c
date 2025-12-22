
static int servprocwrite(struct knservsocket *s, struct knsrvnode *cnode);
static int servprocread(struct knservsocket *s, struct knsrvnode *cnode);

/*
**	newmsg = kn_waitservsock(sock, event)
**
**	process messages from socket and wait for an event to occur.
**	returns the number of new messages that are ready for delivery.
**
*/

TUINT kn_waitservsock(TAPTR knsock, TKNOB *event)
{
	struct knservsocket *s = (struct knservsocket *) knsock;
	kn_sockenv_t *sockenv = &s->sockenv;

	int i;
	struct knsrvnode *cnode;
	TNODE *nextnode, *node;
	int numready;
	TUINT numdeliver = 0;
	TBOOL signal_occured;
	TTIME now;
	TFLOAT nowf;

	do
	{
		struct timeval waittimeout = {0, TIMEOUT_USEC};

		fd_set tempreadset, tempwriteset;
		
		if (TListEmpty(&s->freelist))
		{
			FD_CLR(s->desc, &s->readset);

			node = s->writelist.head;
			while ((nextnode = node->succ))
			{
				cnode = (struct knsrvnode *) node;
				servprocwrite(s, cnode);
				node = nextnode;
			}

			node = s->readlist.head;
			while ((nextnode = node->succ))
			{
				cnode = (struct knsrvnode *) node;
				numdeliver += servprocread(s, cnode);
				node = nextnode;
			}

			if (numdeliver) return numdeliver;

		}
		else
		{
			FD_SET(s->desc, &s->readset);
		}

		tempreadset = s->readset;
		tempwriteset = s->writeset;

		kn_locksock(sockenv);
		
		numready = kn_waitselect(sockenv, FD_SETSIZE, &tempreadset, &tempwriteset, NULL, &waittimeout, event, &signal_occured);

		kn_unlocksock(sockenv);

		if (numready > 0)
		{
			for (i = 0; i < FD_SETSIZE; ++i)
			{
				if (FD_ISSET(i, &tempreadset))
				{
					if (i == s->desc)	/* connection on server socket */
					{
						cnode = (struct knsrvnode *) TRemHead(&s->freelist);
						if (cnode)
						{
							int namesize = sizeof(struct sockaddr_in);
							
							kn_locksock(sockenv);
							
							cnode->desc = accept(s->desc, (struct sockaddr *) &cnode->sendername, &namesize);
							if (cnode->desc >= 0)
							{
								char *t, *d;

								kn_socknonblocking(cnode->desc);
								
								FD_SET(cnode->desc, &s->readset);
								cnode->bytesdone = 0;
								cnode->bufmsg = TNULL;
								cnode->connID = s->connID++;
								cnode->netmsg.backptr = cnode;
								cnode->netmsg.sendername = &cnode->sendername;

								/* generate sender name string */
								
								t = kn_getsockname(&cnode->sendername);
								d = cnode->netmsg.symbolicname;
								while ((*d++ = *t++));
								*(d - 1) = ':';
								kn_itoa((int) kn_getsockport(&cnode->sendername), d);


								/* insert timestamp */
								
								kn_querytimer(s->timer, &now);
								cnode->timestamp = TTIMETOF(&now);
								
								TAddTail(&s->readlist, (TNODE *) cnode);
								dbsprintf(5, "*** TEKLIB kn_waitsock: added new connection to readlist\n");
							}
							else
							{
								dbsprintf(10, "*** TEKLIB kn_waitsock: accept()\n");
								TAddHead(&s->freelist, (TNODE *) cnode);
							}

							kn_unlocksock(sockenv);
						}
						else 
						{
							dbsprintf(10, "*** TEKLIB kn_waitsock: no free clientnode for accepting a connection\n");
						}
					}
					else	/* data pending on a read connection */
					{
						node = s->readlist.head;
						while ((nextnode = node->succ))
						{
							cnode = (struct knsrvnode *) node;
							if (i == cnode->desc)
							{
								kn_querytimer(s->timer, &now);
								cnode->timestamp = TTIMETOF(&now);

								numdeliver += servprocread(s, cnode);
								break;
							}
							node = nextnode;
						}
					}
				}
				else if (FD_ISSET(i, &tempwriteset))	/* data can be written */
				{
					node = s->writelist.head;
					while ((nextnode = node->succ))
					{
						cnode = (struct knsrvnode *) node;
						if (i == cnode->desc)
						{
							servprocwrite(s, cnode);
							break;
						}
						node = nextnode;
					}
				}
			}
		}
		else if (numready < 0)
		{
			dbsprintf(10, "*** TEKLIB kn_waitsock: select()\n");
		}


	
		/*	handle timeout on readlist */

		node = s->readlist.head;

		kn_querytimer(s->timer, &now);
		nowf = TTIMETOF(&now);

		dbsprintf(1, "*** TEKLIB kn_waitservsock: checking timeouts on readlist\n");

		while ((nextnode = node->succ))
		{
			cnode = (struct knsrvnode *) node;
			if (nowf - cnode->timestamp > s->readtimeout)
			{
				dbsprintf(10, "*** TEKLIB kn_waitservsock: lazy client timeout\n");

				TRemove(node);
				FD_CLR(cnode->desc, &s->readset);

				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);
			}
			node = nextnode;
		}

	
	} while (!numdeliver && !signal_occured);
	
	return numdeliver;
}



/*
**	completed = servprocwrite(knservsock, knsrvnode)
**
**	write pending data from a server socket's connection node.
**
*/

static int servprocwrite(struct knservsocket *s, struct knsrvnode *cnode)
{
	kn_sockenv_t *sockenv = &s->sockenv;

	int numwritten;

	if (cnode->bytesdone < sizeof(knnethead))
	{
		/* write msg header */

		kn_locksock(sockenv);
		
		numwritten = send(cnode->desc,
			((char *) &cnode->netmsg.nethead) + cnode->bytesdone,
			sizeof(knnethead) - cnode->bytesdone, KNSOCK_SENDFLAGS);

		kn_unlocksock(sockenv);
		
		if (numwritten < 0)
		{
			if (kn_getsockerrno(sockenv, cnode->desc) != EWOULDBLOCK)
			{
				dbsprintf(10, "*** TEKLIB servprocwrite send(1): dropping connection due to unexpected error\n");
			
				TRemove((TNODE *) cnode);

				TFreeMsg(cnode->bufmsg + 1);

				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);
				FD_CLR(cnode->desc, &s->writeset);
			}
			else dbsprintf(2, "*** TEKLIB servprocwrite send(1): would block\n");

			return 0;			/* msg header not yet complete, but no more data pending */
		}

		cnode->bytesdone += numwritten;
		
		if (cnode->bytesdone == sizeof(knnethead))
		{
			if (cnode->bytesdone == cnode->bytestowrite)
			{
				/* header-only msg complete */

				TRemove((TNODE *) cnode);
				cnode->bytesdone = 0;
				TAddTail(&s->readlist, (TNODE *) cnode);
				FD_CLR(cnode->desc, &s->writeset);
				FD_SET(cnode->desc, &s->readset);
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
	
	numwritten = send(cnode->desc,
		((char *) cnode->bufmsg) + cnode->bytesdone + sizeof(TMSG) - sizeof(knnethead),
		cnode->bytestowrite - cnode->bytesdone, KNSOCK_SENDFLAGS);

	kn_unlocksock(sockenv);
	
	if (numwritten < 0)
	{
		if (kn_getsockerrno(sockenv, cnode->desc) != EWOULDBLOCK)
		{
			dbsprintf(10, "*** TEKLIB: servprocwrite: dropping connection due to unexpected error\n");
			TRemove((TNODE *) cnode);

			TFreeMsg(cnode->bufmsg + 1);
			
			kn_locksock(sockenv);
			shutdown(cnode->desc, 2);
			kn_closesocket(cnode->desc);
			kn_unlocksock(sockenv);

			TAddTail(&s->freelist, (TNODE *) cnode);
			FD_CLR(cnode->desc, &s->writeset);
		}
		else dbsprintf(2, "*** TEKLIB servprocwrite: send(2) would block\n");

		return 0;
	}
	
	cnode->bytesdone += numwritten;

	if (cnode->bytesdone == cnode->bytestowrite)
	{
		/* msg complete */

		dbsprintf(3, "*** servprocwrite: msg written back\n");
		TRemove((TNODE *) cnode);

		TFreeMsg(cnode->bufmsg + 1);

		cnode->bufmsg = TNULL;
		cnode->bytesdone = 0;
		TAddTail(&s->readlist, (TNODE *) cnode);
		FD_CLR(cnode->desc, &s->writeset);
		FD_SET(cnode->desc, &s->readset);

		return 1;
	}

	return 0;
}



/*
**	more_data_to_expect = servprocread(knservsock, knsrvnode)
**
**	read pending data from a server socket's connection node.
**	finished messages will be linked to the server socket's deliver list.
*/

static int servprocread(struct knservsocket *s, struct knsrvnode *cnode)
{
	kn_sockenv_t *sockenv = &s->sockenv;

	int numread;
	TUINT size, proto, version;

	if (cnode->bytesdone < sizeof(knnethead))
	{
		/*	read msg header */

		kn_locksock(sockenv);

		numread = recv(cnode->desc,
			((char *) &cnode->netmsg.nethead) + cnode->bytesdone, 
			sizeof(knnethead) - cnode->bytesdone, KNSOCK_RECVFLAGS);

		kn_unlocksock(sockenv);
	
		if (numread <= 0)
		{
			int sockerr = kn_getsockerrno(sockenv, cnode->desc);
		
			if (numread == 0 || sockerr != EWOULDBLOCK)
			{
				if (numread == 0)
				{
					dbsprintf(5, "*** TEKLIB servprocread(1): end-of-file on descriptor - dropping connection\n");
				}
				else if (sockerr != EWOULDBLOCK)
				{
					dbsprintf(20, "*** TEKLIB servprocread(1): unexpected error on descriptor - dropping connection\n");
				}

				TRemove((TNODE *) cnode);
				FD_CLR(cnode->desc, &s->readset);

				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);
			}
			else dbsprintf(2, "*** TEKLIB servprocread: recv(1) would block\n");

			return 0;	/* msg header not yet complete, but no more data pending */
		}
		
		cnode->bytesdone += numread;
		
		if (cnode->bytesdone == sizeof(knnethead))
		{
			size = cnode->netmsg.nethead.msgsize = ntohl(cnode->netmsg.nethead.msgsize);
			proto = (TUINT) cnode->netmsg.nethead.protocol;
			version = (TUINT) cnode->netmsg.nethead.version;
			
			if (version == KNSOCK_VERSION && (proto == KNSOCK_PROTO_PUT || proto == KNSOCK_PROTO_PUTREPLY))
			{
				if (size >= sizeof(knnethead) && size <= s->maxmsgsize + sizeof(knnethead))
				{
					/*if ((cnode->bufmsg = TMMUAlloc(s->mmu, size - sizeof(knnethead) + sizeof(TMSG))))*/
					if ((cnode->bufmsg = TMMUAlloc(s->msgmmu, size - sizeof(knnethead))))
					{
						cnode->bufmsg--;
						dbsprintf(2, "*** TEKLIB servprocread: allocated message\n");
					}
					else
					{
						dbsprintf(10, "*** TEKLIB servprocread: cannot allocate memory for message\n");
					}
				} else dbsprintf(20, "*** TEKLIB servprocread: message has illegal size\n");
			} else dbsprintf(20, "*** TEKLIB servprocread: unknown/invalid message protocol\n");
			
			if (!cnode->bufmsg)
			{
				/* 
				**	illegal protocol, out of memory or msg has illegal size.
				**	drop this connection, and put the connection node back to freelist
				*/
		
				dbsprintf(20, "*** TEKLIB: servprocread: illegal protocol / msg size - dropping connection\n");
		
				TRemove((TNODE *) cnode);
				FD_CLR(cnode->desc, &s->readset);

				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);
				return 0;
			}
			
			dbsprintf(2, "*** TEKLIB servprocread: header complete, continue with msg body\n");
		}
		else
		{
			dbsprintf(3, "*** TEKLIB servprocread: header not read in a single operation\n");
			return 0;			/* msg header not yet complete, but no more data pending */
		}
	}


	if (cnode->bytesdone < cnode->netmsg.nethead.msgsize)
	{
		/*	read msg body */

		kn_locksock(sockenv);
	
		numread = recv(cnode->desc,
			((char *) cnode->bufmsg) + cnode->bytesdone - sizeof(knnethead) + sizeof(TMSG),
			cnode->netmsg.nethead.msgsize - cnode->bytesdone, KNSOCK_RECVFLAGS);

		kn_unlocksock(sockenv);

		if (numread <= 0)
		{
			int sockerr = kn_getsockerrno(sockenv, cnode->desc);
		
			if (numread == 0 || sockerr != EWOULDBLOCK)
			{
				if (numread == 0)
				{
					dbsprintf(5, "*** TEKLIB servprocread(2): end-of-file on descriptor - dropping connection\n");
				}
				else if (sockerr != EWOULDBLOCK)
				{
					dbsprintf(20, "*** TEKLIB servprocread(2): unexpected error on descriptor - dropping connection\n");
				}

				TRemove((TNODE *) cnode);
				FD_CLR(cnode->desc, &s->readset);

				TFreeMsg(cnode->bufmsg + 1);
				
				kn_locksock(sockenv);
				shutdown(cnode->desc, 2);
				kn_closesocket(cnode->desc);
				kn_unlocksock(sockenv);

				TAddTail(&s->freelist, (TNODE *) cnode);
			}
			else dbsprintf(2, "*** TEKLIB servprocread: recv(2) would block\n");

			return 0;	/* msg header not yet complete, but no more data pending */
		}
		
		cnode->bytesdone += numread;
	}

	if (cnode->bytesdone == cnode->netmsg.nethead.msgsize)
	{
		/* msg complete - link to deliver list */

		FD_CLR(cnode->desc, &s->readset);
		TRemove((TNODE *) cnode);
		TAddTail(&s->deliverlist, (TNODE *) cnode);
		return 1;
	}

	return 0;
}
