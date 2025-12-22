#include "gst.c"

/* Libraries used, don't auto open them SAS/C :) */
struct Library *NodelistBase = NULL;

#define pchar(X) FPutC(Output(), X)

void pstr(STRPTR spacerep, STRPTR s)
{
	for( ; *s != '\0'; ++s )
		if( *s != ' ' )
		{
			if( isalnum(*s) )
				FPutC(Output(), tolower(*s));
		}
		else
			FPuts(Output(), spacerep);
}


int main(int argc, char **argv)
{
	int ret = RETURN_FAIL;
	
	/* Open libraries */
	if( (NodelistBase = OpenLibrary(TRAPLIST_NAME, TRAPLIST_VER)) &&
	    (DOSBase->dl_lib.lib_Version >= 36) ) 
	{
		/* Parse arguments */
		struct RDArgs *rda;
		#define DEF_NODELIST "Nodelist:"
		#define TEMPLATE "FQFA/A,INS=INTERNETSTYLE/S,USER/K,DOMAIN/K,NODELIST/K"
		#define OPT_FQFA 0
		#define OPT_INS 1
		#define OPT_USER 2
		#define OPT_DOMAIN 3
		#define OPT_NODELIST 4
		#define OPT_MAX 5
		STRPTR args[OPT_MAX] = {0, 0, 0, 0, DEF_NODELIST};

		if( rda = ReadArgs(TEMPLATE, (LONG *)&args, NULL) ) 
		{
			NodeList nl;
			
			/* Open nodelist */
			if( nl = NLOpen(args[OPT_NODELIST], 0) )
			{
				Addr *addr, *work;

				if( (addr = AllocVec(sizeof(Addr), MEMF_CLEAR)) &&
				    (work = AllocVec(sizeof(Addr), MEMF_CLEAR)) )
				{

					if( !(NLParseAddr(addr, args[OPT_FQFA], NULL)) )
					{
						NodeDesc *nd;
						
						work->Zone = addr->Zone;
						
						if( args[OPT_INS] )
						{
							if( args[OPT_USER] )
							{
								pstr(".", args[OPT_USER]);
								pchar('@');
							}
								
							work->Net = addr->Net;
							work->Node = addr->Node;
							work->Point = addr->Point;
							
							if( addr->Point )
							{
								work->Point = addr->Point;
								
								if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
								{
									pstr("", nd->System);
									NLFreeNode(nd);
								} else
									Printf("%ld", addr->Point);
								pchar('.');
							}
							
							work->Point = 0;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
								Printf("%ld", addr->Node);
							pchar('.');
							
							work->Node = 0;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
								Printf("%ld", addr->Net);
							pchar('.');
							
							work->Net = work->Zone;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
								Printf("%ld", addr->Net);
							
							if( args[OPT_DOMAIN] )
							{
								pchar('.');
								FPuts(Output(), args[OPT_DOMAIN]);
							}
							
						} else
						{
							work->Net = addr->Zone;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
								Printf("%ld", addr->Zone);
						
							pchar(':');
							work->Net = addr->Net;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
							Printf("%ld", addr->Net);

						
							pchar('/');
							work->Node = addr->Node;
							if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
							{
								pstr("", nd->System);
								NLFreeNode(nd);
							} else
								Printf("%ld", addr->Node);

							if( addr->Point )
							{
								work->Point = addr->Point;
								pchar('.');
								
								if( nd = NLIndexFind(nl, work, NL_VERBATIM) )
								{
									pstr("", nd->System);
									NLFreeNode(nd);
								} else
									Printf("%ld", addr->Point);
							}
						}
						
						pchar('\n');
						
						ret = 0;
					}
					FreeVec(addr);
				}
				NLClose(nl);
			}
			FreeArgs(rda);
		} else
			PrintFault(IoErr(), "CNode");
		CloseLibrary(NodelistBase);
	}
	return ret;
}
