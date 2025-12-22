/***************************************************************************
 * GMulti.c
 *
 * GMulti, Copyright ©1996 Lee Kindness.
 *
 * Patches:
 *  gotcha.library GL_FindNode()
 *
 * This source is for example purposes...
 *
 */

/* This is version... */
#define VERSION "1.1"

/* All our includes are in this file */
#include "gst.c"

/* download dev/c/SFPatch.lha for documentation */ 
#include "SFPatch.h"

/* Libraries used, don't auto open them SAS/C :) */
extern struct IntuitionBase *IntuitionBase = NULL;
extern struct Library *CxBase = NULL;
struct Library *GotchaLibBase = NULL;

/* Save a bit of typing */
#define REG(x) register __ ## x

/* Library Vector Offsets */
#define FN_OFFSET -54

/* GL_FindNode(address,context,info,pat)(A0/A1/A2/A3) */
typedef LONG __asm (*FN_Caller)( REG(a0) struct gl_address *,
                                 REG(a1) struct gl_context *,
                                 REG(a2) struct gl_nodeinfo *,
                                 REG(a3) struct gl_pattern *,
                                 REG(a6) struct Library *);

/* We alloc one of these per MULTILINE entry in the cfg file */
struct MLNode 
{
	struct MLNode    *ml_Succ;        /* Next MLNode */
	struct MLNode    *ml_Pred;        /* Previous MLNode */
	UBYTE             ml_reserved1;   /* unused nl_Type */
	BYTE              ml_Flags;       /* Option flags  */
	STRPTR            ml_ReplaceWith; /* text array of subsitutes */
	struct gl_address ml_BaseNode;    /* The node this MLNode deals with */
	STRPTR            ml_Last;        /* Last number/node used */
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
LONG __asm FN_New( REG(a0) struct gl_address *,
                   REG(a1) struct gl_context *,
                   REG(a2) struct gl_nodeinfo *,
                   REG(a3) struct gl_pattern *,
                   REG(a6) struct Library *);

BOOL OpenLibs(void);
void CloseLibs(void);
BOOL ShowWindow(void);
LONG OpenCfg(STRPTR filename);

/* Global vars */
SetFunc *FN_SetFunc = NULL;
struct Remember *grk;
BOOL Active;
struct MLList *mlines;
char vertag[] = "$VER: GMulti "VERSION" "__AMIGADATE__;

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
			"GMulti",
			&vertag[6],
			"gotcha.library - Better multinode handling",
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
				if( FN_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR) )
				{
					/* init. sfs */
					FN_SetFunc->sf_Func = FN_New;
					FN_SetFunc->sf_Library = GotchaLibBase;
					FN_SetFunc->sf_Offset = FN_OFFSET;
					FN_SetFunc->sf_QuitMethod = SFQ_COUNT;

					/* Replace the functions */
					if ( SFReplace(FN_SetFunc) ) 
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
						SFRestore(FN_SetFunc);
					}
					FreeVec(FN_SetFunc);	
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
									if( GL_XtractInfos(&mln->ml_BaseNode, args[OPT_NODE]) )
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
		"GMulti",
		"%s ©Lee Kindness.\n\n"
		"Internet: wangi@frost3.demon.co.uk\n"
		"Fidonet: 2:259/15.46\n\n"
		"Impoved multiline support for gotcha.library\n\n"
		"Read \"GMulti.guide\" for more information\n\n"
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
	GotchaLibBase = OpenLibrary("gotcha.library", 0);
	ret = ((IntuitionBase) && 
	       (CxBase) && 
	       (GotchaLibBase));
	return(ret);
}


/***************************************************************************
 * CloseLibs() -- Close all libraries
 */
void CloseLibs(void)
{
	if (GotchaLibBase)
		CloseLibrary(GotchaLibBase);
	if (CxBase)
		CloseLibrary(CxBase);
	if (IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}


/***************************************************************************
 * BumpPhone() -- Select the next pnone number
 */
struct gl_nodeinfo *BumpPhone(struct gl_context *nl, struct gl_nodeinfo *nd,
                    struct MLNode *mln, SetFunc *setfunc,
                    struct gl_pattern *pat, struct Library *lib)
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
		
		/* If its a phone number then copy it */
		if( pnum )
		{
			strncpy(nd->phone, s, 63);
			strncpy(nd->tphone, s, 63);
		} else
		{
			STRPTR fqfa;
			/* it is a FQFA */
			if( fqfa = AllocVec(count+1, 0) )
			{
				struct gl_address *addr;
				strncpy(fqfa, s, count);
				if( addr = AllocVec(sizeof(struct gl_address), MEMF_CLEAR) )
				{
					if( GL_XtractInfos(addr, fqfa) )
					{
						FN_Caller Caller;
						struct gl_nodeinfo noded;
						struct gl_nodeinfo *nodedesc = &noded;
						
						/* Call original function to resolve the phone number */
						Caller = (APTR)setfunc->sf_OriginalFunc;
						if( Caller(addr, nl, nodedesc, pat, lib) )
						{
							USHORT tmp;
							
							swmem(nodedesc, nd, sizeof(struct gl_nodeinfo));

							tmp = nodedesc->zone;
							nodedesc->zone = nd->zone;
							nd->zone = tmp;
							tmp = nodedesc->net;
							nodedesc->net = nd->net;
							nd->net = tmp;
							tmp = nodedesc->node;
							nodedesc->node = nd->node;
							nd->node = tmp;
							tmp = nodedesc->point;
							nodedesc->point = nd->point;
							nd->point = tmp;
							tmp = nodedesc->region;
							nodedesc->region = nd->region;
							nd->region = tmp;
							tmp = nodedesc->hub;
							nodedesc->hub = nd->hub;
							nd->hub = tmp;							
							swmem(nodedesc->domain, nd->domain, 32);

							if( (mln->ml_Flags & MLFF_COPYPASS) )
								swmem(nodedesc->password, nd->password, 32);
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
 * FN_New() -- The GL_FindNode() replacement
 */

LONG __saveds __asm FN_New( REG(a0) struct gl_address *find_me,
                            REG(a1) struct gl_context *nl,
                            REG(a2) struct gl_nodeinfo *ni,
                            REG(a3) struct gl_pattern *pat,
                            REG(a6) struct Library *lib)
{
	FN_Caller Caller;
	LONG ret;
	
	/* increment count */
	Forbid();
	FN_SetFunc->sf_Count += 1;
	Permit();
	
	Caller = (APTR)FN_SetFunc->sf_OriginalFunc;
	
	/* Pass the buck */
	/* only do our stuff if we are an active cx */
	if( (ret = Caller(find_me, nl, ni, pat, lib)) &&
	    (Active) )
	{
		struct MLNode *mln, *foundnode = NULL;
		
		/* Go thru our list of mlines, looking for a match */
		mln = mlines->mllh_Head;
		while( mln->ml_Succ ) 
		{
			if( !GL_AdrCmpPat(&mln->ml_BaseNode, find_me) )
			{
				foundnode = mln;
			}
			mln = mln->ml_Succ;
		}
		if (foundnode) 
		{
			if( foundnode->ml_Last == MLLAST_NONE )
			{
				/* Use ni->Phone as it is, and update ml_Last */
				foundnode->ml_Last = MLLAST_BASENODE;
			}
			else
			{
				/* Get the next phone number */
				BumpPhone(nl, ni, foundnode, FN_SetFunc, pat, lib);
			}
		}
	}
	
	/* decrement count */
	Forbid();
	FN_SetFunc->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);
}
