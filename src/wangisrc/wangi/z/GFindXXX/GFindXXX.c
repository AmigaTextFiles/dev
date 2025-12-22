/***************************************************************************
 * GFindXXX.c
 *
 * GFindXXX, Copyright ©1995 Lee Kindness.
 *
 */

/* All our includes are in this file */
#include "gst.c"

#include "GFindXXX_rev.h"

#define PROGNAME "GFindXXX"

/* Libraries used, don't auto open them SAS/C :) */
struct Library *GotchaLibBase = NULL;

/* The differnet types of search fields */
enum STypes { ST_NONE   = 0,
              ST_SYSTEM = 1,
              ST_SYSOP  = 2,
              ST_PLACE  = 3,
              ST_PHONE  = 4,
              ST_ADR3D  = 5,
              ST_ADR4D  = 6,
              ST_ADR5D  = 7,
              ST_FLAGS  = 8 };

struct stypes 
{
	STRPTR      text;
	enum STypes type;
};

/* Matches between the arguments supplied for STYPE and the enumeration */
struct stypes texttype[] =
{
	{"system",    ST_SYSTEM},
	{"sys",       ST_SYSTEM},
	{"node",      ST_SYSTEM},
	{"bbs",       ST_SYSTEM},
	{"sysop",     ST_SYSOP},
	{"owner",     ST_SYSOP},
	{"place",     ST_PLACE},
	{"city",      ST_PLACE},
	{"location",  ST_PLACE},
	{"loc",       ST_PLACE},
	{"phone",     ST_PHONE},
	{"telephone", ST_PHONE},
	{"3d",        ST_ADR3D},
	{"3",         ST_ADR3D},
	{"4d",        ST_ADR4D},
	{"4",         ST_ADR4D},
	{"address",   ST_ADR4D},
	{"addr",      ST_ADR4D},
	{"adr",       ST_ADR4D},
	{"5d",        ST_ADR5D},
	{"5",         ST_ADR5D},
	{"domain",    ST_ADR5D},
	{"flags",     ST_FLAGS},
	{"flag",      ST_FLAGS},
	{NULL,        ST_NONE}
};

LONG NLSearch(struct gl_context *nl, STRPTR pat, STRPTR npat, enum STypes stype,
              BOOL full, BOOL points, BOOL cutdash, BOOL verbatim, STRPTR lformat);

const char *vtag = VERSTAG;


/***************************************************************************
 * SPrintf() -- Equiv. to sprintf().
 */

void SPrintf(char *buffer, char *format, ...)
{
	RawDoFmt(format, (APTR)(&format+1), (void (*))"\x16\xC0\x4E\x75", buffer);
}


/***************************************************************************
 * LFormat() -- Print out node details, when LFORMAT is selected.
 */

/* Character format indicators for the LFORMAT option */
#define SPEC        '%'
#define S_ADDRESS3D '3'
#define S_ADDRESS4D '4'
#define S_ADDRESS5D '5'
#define S_ADDRESS   'A'
#define S_ALERT     'a'
#define S_BAUD      'B'
#define S_BSPACE    'b'
#define S_STAR      'C'
#define S_COST      'c'
#define S_NODE4     'D'
#define S_DOMAIN    'd'
/* #define S_       'E' */
#define S_NET       'e'
#define S_FIRSTNAME 'F'
#define S_FLAGS     'f'
/* #define S_       'G' */
#define S_GATE      'g'
/* #define S_       'H' */
#define S_HUB       'h'
/* #define S_       'I' */
#define S_TIME      'i'
/* #define S_       'J' */
/* #define S_       'j' */
/* #define S_       'K' */
/* #define S_       'k' */
#define S_NLLINE    'L'
#define S_LOCATION  'l'
#define S_MAILONLY  'M'
#define S_BBSNUM    'm'
#define S_NODE      'N'
#define S_NL        'n'
#define S_BVPHONE   'O'
#define S_VPHONE    'o'
#define S_PHONE     'P'
#define S_POINT     'p'
/* #define S_       'Q' */
#define S_DQUOTE    'q'
#define S_REGION    'R'
#define S_RETURN    'r'
#define S_SYSTEM    'S'
#define S_SYSOP     's'
#define S_TYPE      'T'
#define S_TAB       't'
/* #define S_       'U' */
#define S_ADDRESSA  'u'
/* #define S_       'V' */
#define S_VTAB      'v'
/* #define S_       'W' */
#define S_PASSWORD  'w'
/* #define S_       'X' */
#define S_SYSOPE    'x'
/* #define S_       'Y' */
/* #define S_       'y' */
/* #define S_       'Z' */
#define S_ZONE      'z'

#define FT_SHORT "%u %S, %l, %s, %P"
#define FT_FULL  "Node %A, \"%S\" is in %l\n"	\
                 "System is listed as %T\n"		\
                 "Operated by %s\n"						\
                 "Region %R, Hub %h\n"				\
                 "Phone %P, Cost %c\n"				\
                 "Flags %f\n"									\
                 "Password %w\n"

#define STATE_NONE 0
#define STATE_SPEC 1

void LFormat(struct gl_nodeinfo *nd, STRPTR format, BOOL verbatim)
{
	STRPTR s, s2;
	LONG state = STATE_NONE, num;
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
					case S_STAR:
						FPutC(fh, '*');
						break;
					case S_SYSTEM:
						FPuts(fh, nd->name);
						break;
					case S_ADDRESS3D:
						FPrintf(fh, "%ld:%ld/%ld", nd->zone, nd->net,
						       nd->node);
						break;
					case S_ADDRESS4D:
						FPrintf(fh, "%ld:%ld/%ld.%ld", nd->zone, nd->net,
						       nd->node, nd->point);
						break;
					case S_ADDRESS5D:
					case S_ADDRESS:
						FPrintf(fh, "%ld:%ld/%ld.%ld@%s", nd->zone, nd->net,
						       nd->node, nd->point, nd->domain);
						break;
					case S_ADDRESSA:
						if( nd->point )
							FPrintf(fh, "%ld:%ld/%ld.%ld", nd->zone, nd->net,
						       nd->node, nd->point);
						else
							FPrintf(fh, "%ld:%ld/%ld", nd->zone, nd->net,
						       nd->node);
						break;
					case S_LOCATION:
						FPuts(fh, nd->location);
						break;
					case S_SYSOP:
						FPuts(fh, nd->sysop);
						break;
					case S_FIRSTNAME:
						for( s2 = nd->sysop;
						     (*s2) && (*s2 != ' ');
						     ++s2 )
							FPutC(fh, *s2);
						break;
					case S_SYSOPE:
					case S_GATE:
						for( s2 = nd->sysop; *s2 != '\0'; ++s2 )
							if( *s2 == ' ' )
								FPutC(fh, '.');
							else
								FPutC(fh, tolower(*s2));
						if( *s == S_SYSOPE )
							break;
						if( nd->point )
							FPrintf(fh, "@p%ld.f%ld.n%ld.z%ld", nd->point, nd->node,
						       nd->net, nd->zone);
						else
							FPrintf(fh, "@f%ld.n%ld.z%ld", nd->node,
						       nd->net, nd->zone);
						break;
					case S_TYPE:
						/* Gotchlib does not support this... implement by hand */
						if( !stricmp(nd->phone, "-Unpublished-") )
							FPuts(fh, "Pvt");
						else if( nd->point )
							FPuts(fh, "Point");
						else if( (nd->zone == nd->net) && (nd->node == 0) )
							FPuts(fh, "Zone");
						else if( (nd->region == nd->net) && (nd->node == 0) )
							FPuts(fh, "Region");
						else if( nd->node == 0 )
							FPuts(fh, "Host");
						else if( nd->hub == nd->node )
							FPuts(fh, "Hub");
						else
							FPuts(fh, "Node");
						break;
					case S_NLLINE:
						s2 = "";
						num = nd->node;
						if( !stricmp(nd->phone, "-Unpublished-") )
							s2 = "Pvt";
						else if( nd->point )
						{
							s2 = "Point";
							num = nd->point;
						}
						else if( (nd->zone == nd->net) && (nd->node == 0) )
						{
							s2 = "Zone";
							num = nd->zone;
						}
						else if( (nd->region == nd->net) && (nd->node == 0) )
						{
							s2 = "Region";
							num = nd->region;
						}
						else if( nd->node == 0 )
						{
							s2 = "Host";
							num = nd->net;
						}
						else if( nd->hub == nd->node )
							s2 = "Hub";
						FPrintf(fh, "%s,%ld,", s2, num);
						for( s2 = nd->name; *s2 != '\0'; ++s2 )
							if( *s2 == ' ' )
								FPutC(fh, '_');
							else
								FPutC(fh, *s2);
						FPutC(fh, ',');
						for( s2 = nd->location; *s2 != '\0'; ++s2 )
							if( *s2 == ' ' )
								FPutC(fh, '_');
							else
								FPutC(fh, *s2);
						FPutC(fh, ',');
						for( s2 = nd->sysop; *s2 != '\0'; ++s2 )
							if( *s2 == ' ' )
								FPutC(fh, '_');
							else
								FPutC(fh, *s2);
						FPrintf(fh, ",%s,%s,%s", nd->phone, nd->baud, nd->flags);
						break;
					case S_BBSNUM:
						if( strstr(nd->flags, "MO") )
						{
							FPuts(fh, "MAIL ONLY");
							break;
						}
						/* FALLTHRU!!! */
					case S_PHONE:
						if( verbatim )
							FPuts(fh, nd->phone);
						else
							FPuts(fh, nd->tphone);
						break;
					case S_MAILONLY:
						if( strstr(nd->flags, "MO") )
							FPuts(fh, "MAIL ONLY");
						break;
					case S_BVPHONE:
						if( strstr(nd->flags, "MO") )
						{
							FPuts(fh, "MAIL ONLY");
							break;
						}
						/* FALLTHRU!!! */
					case S_VPHONE:
						FPuts(fh, nd->phone);
						break;
					case S_BAUD:
						FPuts(fh, nd->baud);
						break;
					case S_COST:
						if(nd->cost != -1)
							FPrintf(fh, "%01ld.%02ld", nd->cost/100, nd->cost%100);
						else
							FPrintf(fh, "undialable");
						break;
					case S_FLAGS:
						FPuts(fh, nd->flags);
						break;
					case S_TIME:
						if( strstr(nd->flags, "CM") )
							FPuts(fh, "24hr");
						else
							if( s2 = strstr(nd->flags, "U,") )
								if( s2 = strstr(s2, ",T") )
								{
									LONG on_min   = 0;
									LONG off_min  = 0;
									LONG on_hour  = (LONG)(s2[2] - 'A');
									LONG off_hour = (LONG)(s2[3] - 'A');
									if( on_hour > 23 )
									{
										on_hour -= (LONG)('a' - 'A');
										on_min = 30;
									}
									if( off_hour > 23 )
									{
										off_hour -= (LONG)('a' - 'A');
										off_min = 30;
									}
									FPrintf(fh,"%02ld:%02ld->%02ld:%02ld (UTC)", on_hour, on_min, off_hour, off_min);
								} else
									FPuts(fh, "ZMH only");
							else
								FPuts(fh, "ZMH only");
						break;
					case S_PASSWORD:
						FPuts(fh, (STRPTR)nd->password[0] ? (STRPTR)nd->password : (STRPTR)"none");
						break;
					case S_ZONE:
						FPrintf(fh, "%ld", nd->zone);
						break;
					case S_NET:
						FPrintf(fh, "%ld", nd->net);
						break;
					case S_NODE:
						FPrintf(fh, "%ld", nd->node);
						break;
					case S_NODE4:
						FPrintf(fh, "%04ld", nd->node);
						break;
					case S_POINT:
						FPrintf(fh, "%ld", nd->point);
						break;
					case S_DOMAIN: /*DING*/
						FPuts(fh, nd->domain);
						break;
					case S_REGION:
						FPrintf(fh, "%ld", nd->region);
						break;
					case S_HUB:
						FPrintf(fh, "%ld", nd->hub);
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

void PrintNode(struct gl_nodeinfo *nd, BOOL full, BOOL verbatim, STRPTR lformat)
{
	if( lformat )
		LFormat(nd, lformat, verbatim);
	else if( full )
		LFormat(nd, FT_FULL, verbatim);
	else
		LFormat(nd, FT_SHORT, verbatim);
}


/***************************************************************************
 * NLSearch() -- Called for each search...
 */

LONG NLSearch(struct gl_context *nl, STRPTR pat, STRPTR npat, enum STypes stype,
              BOOL full, BOOL points, BOOL cutdash, BOOL verbatim, STRPTR lformat)
{
	LONG ret = 0;
	struct gl_address *ad;
	struct gl_nodeinfo *nd = NULL;
	struct gl_pattern *pt = NULL;
	
	if( (ad = AllocVec(sizeof(struct gl_address), MEMF_CLEAR)) &&
	    (nd = AllocVec(sizeof(struct gl_nodeinfo), MEMF_CLEAR)) &&
	    (pt = AllocVec(sizeof(struct gl_pattern), MEMF_CLEAR)) )
	{
		STRPTR s = NULL;
		ULONG sig = 0;
		#define ADRBUFF_LEN 100
		char adrbuff[ADRBUFF_LEN];
		
		/* convert */
		GL_XtractInfos(ad, npat);
		
		switch( stype )
		{
			case ST_SYSTEM:
				s = nd->name;
				break;
			
			case ST_SYSOP:
				s = nd->sysop;
				break;
			
			case ST_PLACE:
				s = nd->location;
				break;
			
			case ST_PHONE:
				if( !cutdash )
				{
					if( verbatim )
						s = nd->phone;
					else
						s = nd->tphone;
				} else
					s = (STRPTR)-1;
				break;
			
			case ST_ADR3D:
			case ST_ADR4D:
			case ST_ADR5D:
				s = (STRPTR)-2;
				break;				
			
			case ST_FLAGS:
				s = nd->flags;
				break;
		}
	
		if( s && GL_FindNodeFirst(ad, nl, nd, pt) )
			do
			{
				if( !nd->point || (points && nd->point) )
				{
					STRPTR ss;
					
					if( s == (STRPTR)-1 )
					{
						STRPTR src;
						
						if( verbatim )
							src = nd->phone;
						else
							src = nd->tphone;
						
						/* Strip out dashes */
						if( ss = AllocVec(strlen(src)+1, MEMF_CLEAR) )
						{
							STRPTR s2, s3;
							s3 = ss;
							for( s2 = src ; *s2 != '\0'; s2++ )
							{
								if( *s2 != '-' )
								{
									*s3 = *s2;
									s3++;
								}
							}	
						}
					} else if( s == (STRPTR)-2 )
					{
						ss = adrbuff;
						switch( stype )
						{
							case ST_ADR3D:
								SPrintf(ss, "%ld:%ld/%ld", nd->zone, nd->net, nd->node);
								break;
							case ST_ADR4D:
								SPrintf(ss, "%ld:%ld/%ld.%ld", nd->zone, nd->net, nd->node, nd->point);
								break;
							case ST_ADR5D:
								SPrintf(ss, "%ld:%ld/%ld.%ld@%s", nd->zone, nd->net, nd->node, nd->point, nd->domain);
								break;
							default:
								ss = NULL;
						}
					} else
						ss = s;
					
					if( ss )
					{
						if( MatchPatternNoCase(pat, ss) )
						{
							++ret;
							PrintNode(nd, full, verbatim, lformat);
						}
					}
					
					if( s == (STRPTR)-1 )
						FreeVec(ss);
				}
			} while( (GL_FindNodeNext(ad, nl, nd, pt)) && (!(sig = CheckSignal(SIGBREAKF_CTRL_C))) );
			if( sig )
				PrintFault(ERROR_BREAK, "# " PROGNAME);
	}
	if( pt )
		FreeVec(pt);
	if( nd )
		FreeVec(nd);
	if( ad )
		FreeVec(ad);
	
	return ret;
}


/***************************************************************************
 * main() --
 */
int main(int argc, char **argv)
{
	int ret = RETURN_FAIL;
	
	/* Open libraries */
	if( (GotchaLibBase = OpenLibrary("gotcha.library", 1)) &&
	    (DOSBase->dl_lib.lib_Version >= 36) ) 
	{
		/* Parse arguments */
		struct RDArgs *rda;
		#define DEF_NODELIST "Nodelist:"
		#define DEF_NPAT "*"
		#define DEF_STYPE "system"
		#define TEMPLATE "PATTERN/M/A,N=NPAT/K,S=STYPE/K,FULL/S,POINTS/S,VERBATIM/S,STRIPDASHES/S,QUIET=NOINFO/S,LFORMAT/K,NODELIST/K"
		#define OPT_PATTERN 0
		#define OPT_NPAT 1
		#define OPT_STYPE 2
		#define OPT_FULL 3
		#define OPT_POINTS 4
		#define OPT_VERBATIM 5
		#define OPT_STRIPDASHES 6
		#define OPT_NOINFO 7
		#define OPT_LFORMAT 8
		#define OPT_NODELIST 9
		#define OPT_MAX 10
		STRPTR args[OPT_MAX] = {0, DEF_NPAT, DEF_STYPE, 0, 0, 0, 0, 0, 0, DEF_NODELIST};

		if( rda = ReadArgs(TEMPLATE, (LONG *)&args, NULL) ) 
		{
			STRPTR s;
			
			struct gl_context *nl;

			/* Open nodelist */
			if( nl = GL_OpenNL(args[OPT_NODELIST]) )
			{
				STRPTR *pata;
				LONG n = 0;
				LONG matches = 0;
				enum STypes st = ST_NONE;
				struct stypes *mat;
				
				for( mat = texttype;
				     (mat->text) && (st == ST_NONE);
				     mat++ )
				{
					if( stricmp(args[OPT_STYPE], mat->text) == 0 )
						st = mat->type;
				}
				if( st == ST_NONE )
					st = ST_SYSTEM;
				
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
						
							LONG num;
							
							/* CallFunc! */
							
							if( (num = NLSearch(nl,
							                    pattern,
							                    args[OPT_NPAT],
							                    st,
                                  (BOOL)args[OPT_FULL],
                                  (BOOL)args[OPT_POINTS],
                                  (BOOL)args[OPT_STRIPDASHES],
                                  (BOOL)args[OPT_VERBATIM],
                                  args[OPT_LFORMAT])) == -1 )
							{
								if( !args[OPT_NOINFO] )
									PrintFault(IoErr(), "# " PROGNAME);
								ret = RETURN_FAIL;
							} else if( num == 0 )
							{
								if( !args[OPT_NOINFO] )
									Printf("# No matches for \"%s\"\n", s);
							}
							else
								matches += num;

						}
						FreeVec(pattern);
					}
					n++;
				}
				
				if( matches )
				{
					if( !args[OPT_NOINFO] )
						Printf("# %ld %s found.\n",
						       matches,
						       ((matches == 1) ? "match" : "matches"));
				}
				else
				{
					if( !args[OPT_NOINFO] )
						Printf("# No matches\n");
				}
				
				if( !args[OPT_NOINFO] )
					Printf("# " VERS " (" DATE ")\n"
					       "# Copyright (c)Lee Kindness, 2:259/15.46\n");
				GL_CloseNL(nl);
			}
			FreeArgs(rda);
		} else
			PrintFault(IoErr(), "# " PROGNAME);
		CloseLibrary(GotchaLibBase);
	}
	return ret;
}
