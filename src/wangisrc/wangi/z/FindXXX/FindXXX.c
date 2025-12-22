/***************************************************************************
 * FindXXX.c
 *
 * FindSystem, FindSysop, FindPlace, FindPhone, Copyright ©1995 Lee Kindness.
 *
 */

/* All our includes are in this file */
#include "gst.c"

#include "FindXXX_rev.h"

#define PROGNAME "FindXXX"

/* Libraries used, don't auto open them SAS/C :) */
struct Library *NodelistBase = NULL;

enum STypes { ST_SYSTEM, ST_SYSOP, ST_PLACE, ST_PHONE };
#define STS_SYSTEM "system"
#define STS_SYSOP  "sysop"
#define STS_PLACE  "place"
#define STS_PHONE  "phone"

/* Structure we pass to NLEnumNode, holds useful data */
struct NLEnumData
{
	NodeList    ed_NodeList;
	STRPTR      ed_Pattern;
	Addr       *ed_Start;
	Addr       *ed_Stop;
	BOOL        ed_Full;
	ULONG       ed_Flags;
	BOOL        ed_Points;
	BOOL        ed_CutDash;
	enum STypes ed_SType;
	STRPTR      ed_LFormat;
	BOOL        ed_Return;
	ULONG       ed_Matches;
};

char *nl_keys[NL_ENTRY_MAX] =
	{ "Node", "Host", "Hold", "Hub", "Pvt", "Point", "Zone", "Region", "Down" };

const char *vtag = VERSTAG;

/***************************************************************************
 * LFormat() -- Print out node details, when LFORMAT is selected.
 */

#define SPEC       '%'
#define S_NL       'n'
#define S_TAB      't'
#define S_RETURN   'r'
#define S_VTAB     'v'
#define S_DQUOTE   'q'
#define S_ALERT    'a'
#define S_BSPACE   'b'
#define S_SYSTEM   'S'
#define S_ADDRESS  'A'
#define S_LOCATION 'l'
#define S_SYSOP    's'
#define S_TYPE     'T'
#define S_PHONE    'P'
#define S_BAUD     'B'
#define S_COST     'c'
#define S_FLAGS    'f'
#define S_PASSWORD 'w'
#define S_ZONE     'z'
#define S_NET      'e'
#define S_NODE     'N'
#define S_POINT    'p'
#define S_REGION   'R'
#define S_HUB      'h'

#define FT_SHORT "%A %S, %l, %s, %P"
#define FT_FULL  "Node %A, \"%S\" is in %l\n" \
                 "System is listed as %T\n" \
                 "Operated by %s\n" \
                 "Region %R, Hub %h\n" \
                 "Phone %P, Cost %c\n" \
                 "Flags %f\n" \
                 "Password %w\n"

#define STATE_NONE 0
#define STATE_SPEC 1

void LFormat(NodeDesc *nd, STRPTR format)
{
	STRPTR s;
	LONG state = STATE_NONE;
	BPTR fh = Output();
	
	for( s = format; *s != '\000'; ++s )
	{
		switch( state )
		{
			case STATE_NONE:
				if( *s == SPEC )
					state = STATE_SPEC;
				else
					FPutC(fh, *s);
				break;
			case STATE_SPEC:
				switch( *s )
				{
					case SPEC:
						FPutC(fh, SPEC);
						break;
					case S_NL:
						FPutC(fh, '\n');
						break;
					case S_TAB:
						FPutC(fh, '\t');
						break;
					case S_RETURN:
						FPutC(fh, '\r');
						break;
					case S_VTAB:
						FPutC(fh, '\v');
						break;
					case S_DQUOTE:
						FPutC(fh, '\"');
						break;
					case S_ALERT:
						FPutC(fh, '\a');
						break;
					case S_BSPACE:
						FPutC(fh, '\b');
						break;
					case S_SYSTEM:
						FPuts(fh, nd->System);
						break;
					case S_ADDRESS:
						FPrintf(fh, "%ld:%ld/%ld.%ld", nd->Node.Zone, nd->Node.Net,
						       nd->Node.Node, nd->Node.Point);
						break;
					case S_LOCATION:
						FPuts(fh, nd->City);
						break;
					case S_SYSOP:
						FPuts(fh, nd->Sysop);
						break;
					case S_TYPE:
						FPuts(fh, (nd->Type < NL_ENTRY_MAX) ? nl_keys[nd->Type] : "unknown");
						break;
					case S_PHONE:
						FPuts(fh, nd->Phone);
						break;
					case S_BAUD:
						FPrintf(fh, "%ld", nd->BaudRate);
						break;
					case S_COST:
						if(nd->Cost != -1)
							FPrintf(fh, "%01ld.%02ld", nd->Cost/100, nd->Cost%100);
						else
							FPrintf(fh, "undialable");
						break;
					case S_FLAGS:
						FPuts(fh, nd->Flags);
						break;
					case S_PASSWORD:
						FPuts(fh, (nd->Passwd && nd->Passwd[0]) ? nd->Passwd : "none");
						break;
					case S_ZONE:
						FPrintf(fh, "%ld", nd->Node.Zone);
						break;
					case S_NET:
						FPrintf(fh, "%ld", nd->Node.Net);
						break;
					case S_NODE:
						FPrintf(fh, "%ld", nd->Node.Node);
						break;
					case S_POINT:
						FPrintf(fh, "%ld", nd->Node.Point);
						break;
					case S_REGION:
						FPrintf(fh, "%ld", nd->Region);
						break;
					case S_HUB:
						FPrintf(fh, "%ld", nd->Hub);
						break;
				}
				state = STATE_NONE;
				break;
		}	
	}
	FPutC(fh, '\n');
}

/***************************************************************************
 * PrintNode() -- Print out node details.
 */

void PrintNode(NodeDesc *nd, BOOL full, STRPTR lformat)
{
	if( lformat )
		LFormat(nd, lformat);
	else if( full )
		LFormat(nd, FT_FULL);
	else
		LFormat(nd, FT_SHORT);
}


/***************************************************************************
 * EnumFunc() -- Called for each node in the nodelist. Print node if it
 * matches 'pattern'
 */
BOOL __saveds __stdargs EnumFunc(Addr *addr, ULONG region, struct NLEnumData *ud)
{
	BOOL ret;
	NodeDesc *nd;
	ret = FALSE;
	
	if( ud->ed_Stop && (NLAddrComp(addr, ud->ed_Stop) > 0) )
	{
		ud->ed_Return = TRUE;
		return FALSE;
	}
	
	/* Check if a point, and what to do... */
	if( !ud->ed_Points && addr->Point )
		/* Skip this entry... */
		return( TRUE );
	
	/* Check for ctrl-c, and node type */
	if( !CheckSignal(SIGBREAKF_CTRL_C) )
	{
		ret = TRUE;
	
		/* Find that node in nodelist */
		if( nd = NLFind(ud->ed_NodeList, addr, ud->ed_Flags) )
		{
			STRPTR s;
			
			switch( ud->ed_SType )
			{
				case ST_SYSTEM:
					s = nd->System;
					break;
				
				case ST_PLACE:
					s = nd->City;
					break;
				
				case ST_PHONE:
					if( ud->ed_CutDash )
					{
						/* Strip out dashes */
						if( s = AllocVec(strlen(nd->Phone)+1, MEMF_CLEAR) )
						{
							STRPTR s2, s3;
							s3 = s;
							for( s2 = nd->Phone ; *s2 != '\0'; s2++ )
							{
								if( *s2 != '-' )
								{
									*s3 = *s2;
									s3++;
								}
							}	
						}
					} else
						s = nd->Phone;
					break;
				
				case ST_SYSOP:
					s = nd->Sysop;
					break;
			}
			
			if( (s) &&
			    (MatchPatternNoCase(ud->ed_Pattern, s)) )
			{
			  /* Match! Print the node details */
			  ud->ed_Matches++;
			  PrintNode(nd, ud->ed_Full, ud->ed_LFormat);
			}
			if( ud->ed_SType )
				if( (ud->ed_CutDash) && (s) )
					FreeVec(s);
			NLFreeNode(nd);
		}
	} else
		SetIoErr(ERROR_BREAK);
	if( ret )
		ud->ed_Return = TRUE;
	else
		ud->ed_Return = FALSE;
	return ret;
}


/***************************************************************************
 * main() --
 */
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
		#define DEF_STYPE STS_SYSTEM
		#define TEMPLATE "PATTERN/M/A,S=STYPE/K,START/K,STOP/K,FULL/S,POINTS/S,VERBATIM/S,STRIPDASHES/S,BUFSIZE/K/N,LFORMAT/K,NODELIST/K"
		#define OPT_PATTERN 0
		#define OPT_STYPE 1
		#define OPT_START 2
		#define OPT_STOP 3
		#define OPT_FULL 4
		#define OPT_POINTS 5
		#define OPT_VERBATIM 6
		#define OPT_STRIPDASHES 7
		#define OPT_BUFSIZE 8
		#define OPT_LFORMAT 9
		#define OPT_NODELIST 10
		#define OPT_MAX 11
		STRPTR args[OPT_MAX] = {0, DEF_STYPE, 0, 0, 0, 0, 0, 0, 0, 0, DEF_NODELIST};

		if( rda = ReadArgs(TEMPLATE, (LONG *)&args, NULL) ) 
		{
			STRPTR s;
			
			NodeList nl;
			ULONG bufsize;
			ULONG flags;

			if( args[OPT_BUFSIZE] )
				bufsize = *((ULONG *)args[OPT_BUFSIZE]);
			else
				bufsize = 0;
			
			if( args[OPT_VERBATIM] )
				flags = NL_VERBATIM;
			else
				flags = 0;

			
			/* Open nodelist */
			if( nl = NLOpen(args[OPT_NODELIST], 0) )
			{
				STRPTR *pata;
				LONG n = 0;
				LONG matches = 0;
				
				pata = (void *) args[OPT_PATTERN];
				
				ret = RETURN_OK;
				
				while( (s = pata[n]) && !ret ) 
				{
					STRPTR pattern;
					/* Act on the pattern */
				
					/* Alloc buffer for tokenized widcard */
					if( pattern = AllocVec(strlen(s)*3, MEMF_CLEAR) )
					{
						/* Parse wildcard */
						if( ParsePatternNoCase(s, pattern, strlen(s)*3) != -1 )
						{
							Addr *start, *stop;
							struct NLEnumData *ud;
							
							/* Parse start address */
							if( args[OPT_START] )
							{
								if( start = AllocVec(sizeof(Addr), MEMF_CLEAR) )
								{
									if( NLParseAddr(start, args[OPT_START], NULL) )
									{
										FreeVec(start);
										start = NULL;
									}
								}
							} else
								start = NULL;
							
							if( args[OPT_STOP] )
							{
								if( stop = AllocVec(sizeof(Addr), MEMF_CLEAR) )
								{
									if( NLParseAddr(stop, args[OPT_STOP], NULL) )
									{
										FreeVec(stop);
										stop = NULL;
									}
								}
							} else
								stop = NULL;
								
							/* Alloc user data structure */
							if( ud = AllocVec(sizeof(struct NLEnumData), MEMF_CLEAR) )
							{	
								ud->ed_NodeList = nl;
								ud->ed_Pattern = pattern;
								ud->ed_Start = start;
								ud->ed_Stop = stop;
								ud->ed_Full = (BOOL)args[OPT_FULL];
								ud->ed_CutDash = (BOOL)args[OPT_STRIPDASHES];
								ud->ed_Points = (BOOL)args[OPT_POINTS];
								
								if( stricmp(args[OPT_STYPE], STS_SYSOP) == 0 )
									ud->ed_SType = ST_SYSOP;
								else if( stricmp(args[OPT_STYPE], STS_PLACE) == 0 )
									ud->ed_SType = ST_PLACE;
								else if( stricmp(args[OPT_STYPE], STS_PHONE) == 0 )
									ud->ed_SType = ST_PHONE;
								else
									ud->ed_SType = ST_SYSTEM;

								ud->ed_Flags = flags;
								ud->ed_LFormat = args[OPT_LFORMAT];
								ud->ed_Matches = 0;
							
								NLEnumNode(nl, bufsize, start, EnumFunc, ud);
								if( !ud->ed_Return )
								{
									PrintFault(IoErr(), "# " PROGNAME);
									ret = RETURN_FAIL;
								}
								
								if( !ud->ed_Matches )
									Printf("# No matches for \"%s\"\n", s);
								else
									matches += ud->ed_Matches;
									if( ud->ed_Matches )
								FreeVec(ud);
							}
							
							if( start )
								FreeVec(start);
							if( stop )
								FreeVec(stop);
						}
						FreeVec(pattern);
					}
					n++;
				}
				
				if( matches )
					Printf("# %ld %s found.\n",
					       matches,
					       ((matches == 1) ? "match" : "matches"));
				else
					Printf("# No matches\n");
				Printf("# " VERS " (" DATE ")\n"
				       "# Copyright (c)Lee Kindness, 2:250/366.34\n");
				NLClose(nl);
			}
			FreeArgs(rda);
		} else
			PrintFault(IoErr(), "# " PROGNAME);
		CloseLibrary(NodelistBase);
	}
	return ret;
}
