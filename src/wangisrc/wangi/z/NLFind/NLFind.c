/***************************************************************************
 * NLFind.c
 *
 * NLFind, Copyright ©1995 Lee Kindness.
 *
 * Patches:
 *  traplist.library NLFind()
 *  traplist.library NLIndexFind()
 *
 * This source is for example purposes...
 *
 */

/* This is version... */
#define VERSION "1.4"

/* All our includes are in this file */
#include "gst.c"

/* download dev/c/SFPatch.lha for documentation */ 
#include "SFPatch.h"

/* Libraries used, don't auto open them SAS/C :) */
extern struct IntuitionBase *IntuitionBase = NULL;
extern struct Library *CxBase = NULL;
struct Library *NodelistBase = NULL;

/* Save a bit of typing */
#define REG(x) register __ ## x

/* Library Vector Offsets */
#define NLF_OFFSET -48
#define NLIF_OFFSET -66

typedef NodeDesc * __asm (*NLF_Caller)( REG(a0) NodeList,
                                        REG(a1) Addr *,
                                        REG(d0) ULONG, 
                                        REG(a6) struct Library *);

typedef NodeDesc * __asm (*NLIF_Caller)( REG(a0) NodeList,
                                         REG(a1) Addr *,
                                         REG(d0) ULONG, 
                                         REG(a6) struct Library *);

/* We alloc one of these per MULTILINE entry in the cfg file */
struct MLNode 
{
	struct MLNode *ml_Succ;        /* Next MLNode */
	struct MLNode *ml_Pred;        /* Previous MLNode */
	UBYTE          ml_reserved1;   /* unused nl_Type */
	BYTE           ml_Flags;       /* Option flags  */
	STRPTR         ml_ReplaceWith; /* text array of subsitutes */
	Addr           ml_BaseNode;    /* The node this MLNode deals with */
	STRPTR         ml_Last;        /* Last number/node used */
};

/* Flags for ml_Flags */
#define MLFB_COPYPASS 0
#define MLFF_COPYPASS 1

/* Constants for ml_Last */
#define MLLAST_NONE (STRPTR)~0
#define MLLAST_BASENODE NULL

/* To hold all the MLNodes */
struct MLList 
{
	struct MLNode *mllh_Head;
	struct MLNode *mllh_Tail;
	struct MLNode *mllh_TailPred;
};

/* Prototypes */
NodeDesc * __asm NLF_New( REG(a0) NodeList,
                          REG(a1) Addr *,
                          REG(d0) ULONG, 
                          REG(a6) struct Library *);

NodeDesc * __asm NLIF_New( REG(a0) NodeList,
                           REG(a1) Addr *,
                           REG(d0) ULONG, 
                           REG(a6) struct Library *);
BOOL OpenLibs(void);
void CloseLibs(void);
BOOL ShowWindow(void);
LONG OpenCfg(STRPTR filename);
LONG ParseAddr(Addr *, STRPTR);

/* Global vars */
SetFunc *NLF_SetFunc, *NLIF_SetFunc;
struct Remember *grk;
BOOL Active;
struct MLList *mlines;
char vertag[] = "$VER: NLFind "VERSION" "__AMIGADATE__;

#define DEF_CFGFILE "MAIL:MultiLine.cfg"


/***************************************************************************
 * main() --
 */
int main(int argc, char **argv)
{
	int ret = RETURN_FAIL;
	Active = TRUE;
	grk = NULL;
	
	/* check version */
	if (OpenLibs()) 
	{
		struct NewBroker nb = 
		{
			NB_VERSION,
			"NLFind",
			&vertag[6],
			"Gives traplist.library multiline support",
			NBU_UNIQUE | NBU_NOTIFY,
			COF_SHOW_HIDE,
			-1,
			NULL,
			0
		};
		CxObj *broker;
		nb.nb_Pri = 0;
				
		if ((nb.nb_Port = CreateMsgPort()) && (broker = CxBroker(&nb, NULL))) 
		{
			STRPTR filename;
		
			if( argc == 2 )
				filename = argv[1];
			else
				filename = DEF_CFGFILE;
			
			if( OpenCfg(filename) )
			{
				/* Alloc our SetFunc's */
				if( (NLF_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR)) &&
				    (NLIF_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR)) ) 
				{
					/* init. sfs */
					NLF_SetFunc->sf_Func = NLF_New;
					NLF_SetFunc->sf_Library = NodelistBase;
					NLF_SetFunc->sf_Offset = NLF_OFFSET;
					NLF_SetFunc->sf_QuitMethod = SFQ_COUNT;
					NLIF_SetFunc->sf_Func = NLIF_New;
					NLIF_SetFunc->sf_Library = NodelistBase;
					NLIF_SetFunc->sf_Offset = NLIF_OFFSET;
					NLIF_SetFunc->sf_QuitMethod = SFQ_COUNT;

					/* Replace the functions */
					if ( (SFReplace(NLF_SetFunc)) &&
					     (SFReplace(NLIF_SetFunc)) ) 
					{
						ULONG sig, sret;
						BOOL finished;
					
						ActivateCxObj(broker, 1L);

						ret = RETURN_OK;
						
						finished = FALSE;
						sig = 1 << nb.nb_Port->mp_SigBit;
					
						do 
						{
							sret = Wait(SIGBREAKF_CTRL_C | sig);
							if (sret & sig) 
							{
								CxMsg *msg;
								while(msg = (CxMsg *)GetMsg(nb.nb_Port)) 
								{
									switch(CxMsgType(msg)) 
									{
										case CXM_COMMAND:
											switch(CxMsgID(msg)) 
											{
												case CXCMD_DISABLE:
													ActivateCxObj(broker, 0L);
													Active = FALSE;
													break;
												case CXCMD_ENABLE:
													ActivateCxObj(broker, 1L);
													Active = TRUE;
													break;
												case CXCMD_KILL:
													finished = TRUE;
													break;
												case CXCMD_UNIQUE:
													finished = ShowWindow();
													break;
												case CXCMD_APPEAR:
													finished = ShowWindow();
													break;
											}
											break;
									}
									ReplyMsg((struct Message *)msg);
								}
							}
							if (sret & SIGBREAKF_CTRL_C)
								finished = TRUE;
						} while (!finished);
						ActivateCxObj(broker, 0L);
		
						/* Restore functions */
						SFRestore(NLIF_SetFunc);
						SFRestore(NLF_SetFunc);
					}
					FreeVec(NLF_SetFunc);	
				}
			}
			DeleteCxObj(broker);
			DeletePort(nb.nb_Port);
		}
		FreeRemember(&grk, TRUE);
	}
	CloseLibs();
	return(ret);
}


/***************************************************************************
 * OpenCfg() -- Read in the preferences file.
 */
#define MULTILINE_TEMP "MULTILINE/A/K,COPYPASS=COPYPASSWD/S,AKA/F/A"
#define OPT_NODE 0
#define OPT_COPYPASS 1
#define OPT_AKA 2
#define OPT_MAX 3
#define BUF_SIZE 1000

LONG OpenCfg(STRPTR filename)
{
	LONG nodesadded = 0;
	if( mlines = AllocRemember(&grk, sizeof(struct MLList), MEMF_CLEAR) )
	{
		STRPTR buf;
		NewList((struct List *)mlines);
	
		if( buf = AllocVec(BUF_SIZE, 0) )
		{
			BPTR file;
			if( file = Open(filename, MODE_OLDFILE) )
			{
				struct RDArgs *rda;
				if( rda = AllocDosObject(DOS_RDARGS, NULL) )
				{
					STRPTR nbuf;
					STRPTR args[OPT_MAX];
					rda->RDA_DAList = NULL;
					rda->RDA_Flags |= RDAF_NOPROMPT;
					for( nbuf = FGets(file, buf, BUF_SIZE-1); nbuf; nbuf = FGets(file, buf, BUF_SIZE-1) )
					{
						if( (nbuf[0] == 'm') || (nbuf[0] == 'M') )
						{
							rda->RDA_Buffer = NULL;
							rda->RDA_Source.CS_Buffer = nbuf;
							rda->RDA_Source.CS_Length = strlen(nbuf);
							rda->RDA_Source.CS_CurChr = 0;
							args[0] = NULL;
							args[1] = NULL;
							args[2] = NULL;
						
							if( ReadArgs(MULTILINE_TEMP, (LONG *)&args, rda)) 
							{
								struct MLNode *mln;
								/* Allocate a node */
								if( mln = AllocRemember(&grk, sizeof(struct MLNode), MEMF_CLEAR) )
								{
									/* Parse the Addr */
									if( !ParseAddr(&mln->ml_BaseNode, args[OPT_NODE]) )
									{
										/* Alloc memory for mln->ml_ReplaceWith */
										if( mln->ml_ReplaceWith = AllocRemember(&grk, strlen(args[OPT_AKA])+1, 0) )
										{
											/* Copy replacements */
											strcpy(mln->ml_ReplaceWith, args[OPT_AKA]);
										
											/* Should we copy the password? */
											if( args[OPT_COPYPASS] )
												mln->ml_Flags |= MLFF_COPYPASS;
										
											/* This node has never been selected... */
											mln->ml_Last = MLLAST_NONE;
										
											/* Add node to list */
											AddTail((struct List *)mlines, (struct Node *)mln);
											nodesadded++;
										}
									}
								}
								FreeArgs(rda);
							}
						}
					} 
					FreeDosObject(DOS_RDARGS, rda);
				}
				Close(file);
			}
			FreeVec(buf);
		}
	}
	return nodesadded;
}


/***************************************************************************
 * ShowWindow() -- Show our window... currently only a requester 
 */
BOOL ShowWindow(void)
{
	struct EasyStruct ez = {
		sizeof(struct EasyStruct),
		0,
		"NLFind",
		"%s ©Lee Kindness.\n\n"
		"Internet: wangi@fido.zetnet.co.uk\n"
		"Fidonet: 2:259/26.20\n\n"
		"MultiLine node support for traplist.library\n\n"
		"Read \"NLFind.guide\" for more information\n\n"
		"(Program may take a couple of seconds to quit)",
		"Quit|Hide"
	};
	return((BOOL)EasyRequest(NULL, &ez, NULL, &vertag[6]));
}


/***************************************************************************
 * OpenLibs() -- Open all used libraries
 */
BOOL OpenLibs(void)
{
	BOOL ret;
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 37);
	CxBase = OpenLibrary("commodities.library", 37);
	NodelistBase = OpenLibrary("traplist.library", 0);
	ret = ((IntuitionBase) && 
	       (CxBase) && 
	       (NodelistBase));
	return(ret);
}


/***************************************************************************
 * CloseLibs() -- Close all libraries
 */
void CloseLibs(void)
{
	if (NodelistBase)
		CloseLibrary(NodelistBase);
	if (CxBase)
		CloseLibrary(CxBase);
	if (IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}


/***************************************************************************
 * BumpPhone() -- Select the next pnone number
 */
NodeDesc *BumpPhone(NodeList nl, NodeDesc *nd, struct MLNode *mln, SetFunc *setfunc)
{
	#define BREAKCHARS "\t "
	STRPTR s;
	if( mln->ml_Last )
		/* Skip to the next value in the string */
		s = strpbrk(mln->ml_Last, BREAKCHARS);
	else
		/* Start at the begining */
		s = mln->ml_ReplaceWith;
	if( s )
	{
		STRPTR s2, s3;
		BOOL pnum, fail;
		LONG count;
		fail = FALSE;
		/* Skip white space */
		s = stpblk(s);
		
		/* Find end of this item */
		if( s2 = strpbrk(s, BREAKCHARS) )
		{
			/* Wow long is this item? and is it a phone number? */
			pnum = TRUE;
			count = 0;
			s3 = s;
			while( s3 != s2 )
			{
				if( *s3 == ':' )
					/* its not a phone number */
					pnum = FALSE;
				count++;
				s3++;
			}
		} else
		{
			count = strlen(s);
			if( strchr(s, ':') )
				pnum = FALSE;
			else
				pnum = TRUE;
		}
		
		/* If its a phone number then copy it into nd->Phone if the same size! */
		if( pnum )
		{
			if( count <= strlen(nd->Phone) )
				strncpy(nd->Phone, s, count);
			else
				fail = TRUE;
		} else
		{
			STRPTR fqfa;
			/* it is a FQFA */
			if( fqfa = AllocVec(count+1, 0) )
			{
				Addr *addr;
				strncpy(fqfa, s, count);
				if( addr = AllocVec(sizeof(Addr), MEMF_CLEAR) )
				{
					if( !ParseAddr(addr, fqfa) )
					{
						NLF_Caller Caller;
						NodeDesc *nodedesc;
						/* Call NLFind#?() to resolve the phone number */
						Caller = (APTR)setfunc->sf_OriginalFunc;
						if( nodedesc = Caller(nl, addr, 0, NodelistBase) )
						{
							NodeDesc *temp;
							Addr tempaddr;
							
							temp = nodedesc;
							nodedesc = nd;
							nd = temp;
							
							tempaddr = nodedesc->Node;
							nodedesc->Node = nd->Node;
							nd->Node = tempaddr;
							
							if( (mln->ml_Flags & MLFF_COPYPASS) &&
							    (nodedesc->Passwd) &&
							    (nd->Passwd) )
							{
								STRPTR temps;
								temps = nodedesc->Passwd;
								nodedesc->Passwd = nd->Passwd;
								nd->Passwd = temps;
							}
							
							NLFreeNode(nodedesc);
						} else
							fail = TRUE;
					} else
						fail = TRUE;
					FreeVec(addr);
				} else
					fail = TRUE;
				FreeVec(fqfa);
			} else
				fail = TRUE;
		}
		if( fail )
			/* We are leaving ret->Phone as it is */
			mln->ml_Last = MLLAST_BASENODE;
		else
			/* Update ml_Last */
			mln->ml_Last = s;
	} else
		/* We are leaving ret->Phone as it is */
		mln->ml_Last = MLLAST_BASENODE;
	return nd;
}


/***************************************************************************
 * ParseAddr() -- Wrapper around NLParseAddr(), removing domains
 */

LONG ParseAddr(Addr *addr, STRPTR str)
{
	LONG ret = 1;
	STRPTR s;
	
	if( s = AllocVec(strlen(str)+1, MEMF_CLEAR) )
	{
		STRPTR sp = s;
		
		for( ; (*str != '\0') && (*str != '@'); ++str, ++s )
			*s = *str;
		
		ret = NLParseAddr(addr, sp, NULL);
	}
	return( ret );
}


/***************************************************************************
 * NLF_New() -- The NLFind() replacement
 */
NodeDesc * __saveds __asm NLF_New( REG(a0) NodeList nl,
                                   REG(a1) Addr *find_me,
                                   REG(d0) ULONG flags,
                                   REG(a6) struct Library *lib)
{
	NLF_Caller Caller;
	NodeDesc *ret;
	
	/* increment count */
	Forbid();
	NLF_SetFunc->sf_Count += 1;
	Permit();
	
	Caller = (APTR)NLF_SetFunc->sf_OriginalFunc;
	
	/* Pass the buck */
	/* only do our stuff if we are an active cx and if NL_VERBATIM is not set */
	if( (ret = Caller(nl, find_me, flags, lib)) &&
	    (Active) &&
	    !(flags & NL_VERBATIM) )
	{
		struct MLNode *mln, *foundnode = NULL;
		
		/* Go thru our list of mlines, looking for a match */
		mln = mlines->mllh_Head;
		while( mln->ml_Succ ) 
		{
			if( !NLAddrComp(&ret->Node, &mln->ml_BaseNode) )
			{
				foundnode = mln;
			}
			mln = mln->ml_Succ;
		}
		if (foundnode) 
		{
			if( foundnode->ml_Last == MLLAST_NONE )
			{
				/* Use ret->Phone as it is, and update ml_Last */
				foundnode->ml_Last = MLLAST_BASENODE;
			}
			else
			{
				/* Get the next phone number */
				ret = BumpPhone(nl, ret, foundnode, NLF_SetFunc);
			}
		}
	}
	
	/* decrement count */
	Forbid();
	NLF_SetFunc->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);
}


/***************************************************************************
 * NLIF_New() -- The NLIndexFind() replacement
 */
NodeDesc * __saveds __asm NLIF_New( REG(a0) NodeList nl,
                                    REG(a1) Addr *find_me,
                                    REG(d0) ULONG flags,
                                    REG(a6) struct Library *lib)
{
	NLIF_Caller Caller;
	NodeDesc *ret;
	
	/* increment count */
	Forbid();
	NLIF_SetFunc->sf_Count += 1;
	Permit();
	
	Caller = (APTR)NLIF_SetFunc->sf_OriginalFunc;
	
	/* Pass the buck */
	/* only do our stuff if we are an active cx and if NL_VERBATIM is not set */
	if( (ret = Caller(nl, find_me, flags, lib)) &&
	    (Active) &&
	    !(flags & NL_VERBATIM) )
	{
		struct MLNode *mln, *foundnode = NULL;
		
		/* Go thru our list of mlines, looking for a match */
		mln = mlines->mllh_Head;
		while( mln->ml_Succ ) 
		{
			if( !NLAddrComp(&ret->Node, &mln->ml_BaseNode) )
			{
				foundnode = mln;
			}
			mln = mln->ml_Succ;
		}
		if (foundnode) 
		{
			if( foundnode->ml_Last == MLLAST_NONE )
			{
				/* Use ret->Phone as it is, and update ml_Last */
				foundnode->ml_Last = MLLAST_BASENODE;
			}
			else
			{
				/* Get the next phone number */
				ret = BumpPhone(nl, ret, foundnode, NLIF_SetFunc);
			}
		}
	}
	
	/* decrement count */
	Forbid();
	NLIF_SetFunc->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);
}

