
/*
**	knsocket = kn_createservsock(mmu, msgmmu, localsockname, maxmsgsize, timer, timeout, *portnr)
**
**	create server socket (replyport proxy scenario), 
**	associate it with given name, put it into listening state.
**	the timeout applies to no activity on incoming connections.
*/

TAPTR kn_createservsock(TAPTR mmu, TAPTR msgmmu, knsockobj *knsockname, TUINT maxmsgsize, TKNOB *timer, TTIME *timeout, TUINT *portnr)
{
	TBOOL success = TFALSE;

	struct knservsocket *s = TMMUAlloc(mmu, sizeof(struct knservsocket));
	if (s)
	{
		kn_sockenv_t *sockenv = &s->sockenv;
		if (kn_getsockenv(sockenv))
		{
			kn_locksock(sockenv);
		
			s->desc = socket(PF_INET, SOCK_STREAM, 0);
			if (s->desc >= 0)
			{
				int yes = 1;
				if (setsockopt(s->desc, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) == 0)
				{
					if (knsockname)
					{
						success = (bind(s->desc, (struct sockaddr *) knsockname, sizeof(struct sockaddr_in)) == 0);
					}
					else
					{
						success = TTRUE;
					}
				
					if (success)
					{
						if (listen(s->desc, KNSOCK_MAXLISTEN) == 0)
						{
							int i;
							struct knsrvnode *cnode;
						
							FD_ZERO(&s->readset);
							FD_ZERO(&s->writeset);
							FD_SET(s->desc, &s->readset);
				
							s->connID = 0;
							s->maxmsgsize = maxmsgsize > 0xffffffff - sizeof(knnethead) ? 0xffffffff - sizeof(knnethead) : maxmsgsize;
							s->mmu = mmu;
							s->msgmmu = msgmmu;
							/*s->localname = knsockname;*/
							s->timer = timer;
							s->readtimeout = TTIMETOF(timeout);
							
							TInitList(&s->freelist);
							TInitList(&s->readlist);
							TInitList(&s->writelist);
							TInitList(&s->deliverlist);
							TInitList(&s->userlandlist);
				
							cnode = s->nodebuf;
							for (i = 0; i < KNSOCK_MAXLISTEN; ++i)
							{
								TAddTail(&s->freelist, (TNODE *) cnode);
								cnode++;
							}
							
							success = TTRUE;
							
							if (!knsockname && portnr)
							{
								knsockobj mysockname;
								int namelen = sizeof(knsockobj);
								if (getsockname(s->desc, (struct sockaddr *) &mysockname, &namelen) == 0)
								{
									*portnr = (TUINT) kn_getsockport(&mysockname);
								}
								else
								{
									dbsprintf(20, "*** TEKLIB kn_createservsock: could not get own port nr\n");
									success = TFALSE;
								}
							}


						}
						else dbsprintf(10, "*** TEKLIB kn_createservsock: listen()\n");
					}
					else dbsprintf(10, "*** TEKLIB kn_createservsock: bind()\n");
				}
				else dbsprintf(20, "*** TEKLIB kn_createservsock: setsockopt()\n");

				if (!success)
				{	
					kn_closesocket(s->desc);
				}
			}
			else dbsprintf(10, "*** TEKLIB kn_createservsock: socket()\n");

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
