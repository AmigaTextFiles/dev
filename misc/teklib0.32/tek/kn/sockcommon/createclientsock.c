/*
**
**	knsocket = kn_createclientsock(mmu, remotename, timer, timeout)
**
**	create client socket (msgport proxy scenario), 
**	connected to a remote name.
**
**	messages with a reply expected that do not return within the
**	timeout period will be abandoned, and replied locally with
**	TMSG_STATUS_FAILED. a timeout of 0 means "no timeout".
**
*/

TAPTR kn_createclientsock(TAPTR mmu, knsockobj *remotename, TKNOB *timer, TTIME *timeout)
{
	TBOOL success = TFALSE;

	struct knclientsocket *s = TMMUAlloc(mmu, sizeof(struct knclientsocket));
	if (s)
	{
		kn_sockenv_t *sockenv = &s->sockenv;
		if (kn_getsockenv(sockenv))
		{
			kn_locksock(sockenv);
		
			s->desc = socket(PF_INET, SOCK_STREAM, 0);
			if (s->desc >= 0)
			{
				if (connect(s->desc, (struct sockaddr *) remotename, sizeof(struct sockaddr_in)) == 0)
				{
					char *d, *t;
					int i;
					struct knclinode *cnode;

					kn_socknonblocking(s->desc);
	
					s->remotename = remotename;
					s->mmu = mmu;
					s->msgID = 0;
					s->status = SOCKSTATUS_CONNECTED;
					s->clientnode = TNULL;
					s->bytesdone = 0;
					s->timer = timer;
					s->msgtimeout = TTIMETOF(timeout);
		
					FD_ZERO(&s->readset);
					FD_ZERO(&s->writeset);
					
					TInitList(&s->freelist);
					TInitList(&s->readlist);
					TInitList(&s->writelist);
					TInitList(&s->deliverlist);
			
					cnode = s->nodebuf;
					for (i = 0; i < KNSOCK_MAXPENDING; ++i)
					{
						TAddTail(&s->freelist, (TNODE *) cnode);
						cnode++;
					}

					/*	generate dummy netmsg node with sender name string 
						(will be common to all client nodes) */
					
					s->netmsg.backptr = TNULL;
					s->netmsg.sendername = s->remotename;

					t = kn_getsockname(remotename);
					d = s->netmsg.symbolicname;
					while ((*d++ = *t++));
					*(d - 1) = ':';
					kn_itoa((int) kn_getsockport(remotename), d);

					success = TTRUE;

				}
				else
				{
					dbsprintf(10, "*** TEKLIB kn_createclientsock: connect()\n");
				}

				if (!success)
				{
					kn_closesocket(s->desc);
				}
			}
			else
			{
				dbsprintf(20, "*** TEKLIB kn_createclientsock: socket()\n");
			}

			kn_unlocksock(sockenv);
		}

		if (!success)
		{
			TMMUFree(mmu, s);
			s = TNULL;
		}
	}

	return (TAPTR) s;
}
