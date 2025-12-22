/*************************************************************************
 *
 * Umentiler
 *
 * Copyright ©1995 Lee Kindness cs2lk@scms.rgu.ac.uk
 *
 * Read Umentiler.guide (from the main archive) for distribution details.
 *
 * Umentiler.c
 */

/* Includes are kept in gst.c for gst compilation purposes */
#include "gst.c"

#ifdef _DCC
#define REG(x)	__ ## x
#define ASM
#define ARGS __regargs
#else
#ifdef __GNUC__
#define REG(x)
#define ASM
#else /* __SASC__ */
#define REG(x)	register __ ## x
#define ASM	__asm
#endif /* __GNUC__ */
#endif /* _DCC */

extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct LocaleBase *LocaleBase;

/* Revision information */
#include "Umentiler_rev.h"

/* Version String */
const char ver[] = VERSTAG;

/* Example for the documentation ;) */
const char tst[] = "$MOOD: Here is a short story:\n" \
                   "This is the start.\n" \
                   "This is the middle.\n" \
                   "And this is the end!";

/*
 * Keep all 'global' vars in a locally allocated and 
 * passed around structure => Gives pure, reentrant code
 * (We get this with SAS anway...)
 */
struct Vars
{
	ULONG              v_Tags_p;
	ULONG              v_Tags_e;
	ULONG              v_Tags_i;
	ULONG              v_BufSize;
	struct Locale     *v_Locale;
	struct LocaleBase *v_LocaleBase;
};

/* Prototypes */
STRPTR    strsistr      (STRPTR, STRPTR);
VOID      AddC2Cmd      (STRPTR, char);
VOID      MFPutC        (BPTR, char, BOOL);
VOID      RepMarkers    (struct Vars *, STRPTR, BPTR, BOOL);
VOID      HInsertion    (struct Vars *, BPTR, STRPTR, ULONG);
VOID      HInsertCmd    (struct Vars *, BPTR, STRPTR);
ULONG ASM LFFunc        (REG(a0) struct Hook *,
                         REG(a2) struct Locale *,
                         REG(a1) char);
VOID      HDateCmd      (struct Vars *, BPTR, STRPTR, STRPTR, 
                         LONG, BOOL, BOOL, BOOL);
VOID      HVersionCmd   (struct Vars *, BPTR, STRPTR, BOOL, BOOL, 
                         BOOL, BOOL, BOOL, BOOL);
VOID      HProgramCmd   (struct Vars *, BPTR, STRPTR, BOOL);
VOID      HVarCmd       (BPTR, STRPTR, BOOL, BOOL, BOOL);
VOID      HSetvarCmd    (STRPTR, STRPTR);
VOID      HTagCmd       (struct Vars *, BPTR, STRPTR, STRPTR, BOOL, BOOL);


/* Template for all temp file names */
#define TMP_TEMP "T:UXXXXXX.XXX"


/*************************************************************************
 * strsistr() - returns s if f occurs at the start of s. Case insensitive.
 */

STRPTR strsistr(STRPTR s, STRPTR f)
{
	if( s && f )
	{
		BOOL match = TRUE;
		for( ; *s && *f && match; ++s, ++f )
			if( toupper(*s) != toupper(*f) )
				match = FALSE;
		if( match )
			return( s );
		else
			return( NULL );
	} else
		return( NULL ); 
}


/*************************************************************************
 * AddC2Cmd() - Add a charcter to the command string
 */
 
VOID AddC2Cmd(STRPTR cmd, char ch)
{
	STRPTR s;
	/* Find the null */
	s = strchr(cmd, '\0');
	/* Add the char */
	*s = ch;
	/*
	 * ++s;
	 * *s = '\0'
	 *
	 * (no need, we MEMF_CLEARed it)
	 */
}


/*************************************************************************
 * MFPutC() - Will FPutC if certain conditions.
 */

VOID MFPutC(BPTR file, char ch, BOOL nolines)
{
	if( !(nolines && ch == '\n') )
		FPutC(file, ch);
}


/*************************************************************************
 * HInsertion() - Insert text into the file
 */

/* Commands */
#define TXT_INSERT "INSERT"
#define CMD_INSERT 1
#define TXT_DATE "DATE"
#define CMD_DATE 2
#define TXT_VERSION "VERSION"
#define CMD_VERSION 3
#define TXT_PROGRAM "PROGRAM"
#define CMD_PROGRAM 4
#define TXT_VAR "VAR"
#define CMD_VAR 5
#define TXT_SETVAR "SETVAR"
#define CMD_SETVAR 6
#define TXT_TAG "TAG"
#define CMD_TAG 7

/* And ReadArg() templates for each */
#define TMP_INSERT "FILE/A"
#define OPT_INSERT_FILE 0
#define TMP_DATE "FROM/K,LF=LOCALEFORMAT/K,F=FORMAT/N/K,NY=NODAY/S,ND=NODATE/S,NT=NOTIME/S"
#define OPT_DATE_FROM 0
#define OPT_DATE_LOCALEFORMAT 1
#define OPT_DATE_FORMAT 2
#define OPT_DATE_NODAY 3
#define OPT_DATE_NODATE 4
#define OPT_DATE_NOTIME 5
#define TMP_VERSION "FROM/A,F=FULL/S,NN=NONAME/S,NV=NOVER/S,ND=NODATE/S,NPD=NOPARSEDATE/S,USETAG/S"
#define OPT_VERSION_FROM 0
#define OPT_VERSION_FULL 1
#define OPT_VERSION_NONAME 2
#define OPT_VERSION_NOVER 3
#define OPT_VERSION_NODATE 4
#define OPT_VERSION_NOPARSEDATE 5
#define OPT_VERSION_USETAG 6
#define TMP_PROGRAM "NL=NOLINES/S,CMDLINE/A/F"
#define OPT_PROGRAM_NOLINES 0
#define OPT_PROGRAM_CMDLINE 1
#define TMP_VAR "FROM/A,NL=NEWLINE/S,G=GLOBAL/S,L=LOCAL/S"
#define OPT_VAR_FROM 0
#define OPT_VAR_NEWLINE 1
#define OPT_VAR_GLOBAL 2
#define OPT_VAR_LOCAL 3
#define TMP_SETVAR "NAME/A,TEXT/A/F"
#define OPT_SETVAR_NAME 0
#define OPT_SETVAR_TEXT 1
#define TMP_TAG "TAG/A,FILE/A,NONLCUT/S,DOLLERCUT/S"
#define OPT_TAG_TAG 0
#define OPT_TAG_NAME 1
#define OPT_TAG_NONLCUT 2
#define OPT_TAG_DOLLERCUT 3

/* Maximum number of options */
#define OPT_ALL_MAX (OPT_VERSION_USETAG + 1)
#define NOARG "\n"

VOID HInsertion(struct Vars *vars, BPTR destf, STRPTR cmd, ULONG cmdsize)
{
	STRPTR s, arg, temp;
	LONG cnum;
	
	/* Skip any initial white space */
	cmd = stpblk(cmd);
	
	/* skip to the arguments */
	if( arg = strpbrk(cmd, "\t ") )
		arg = stpblk(arg);
	else
		arg = NOARG;
	
	/* What command ? */
	if( s = strsistr(cmd, TXT_INSERT) )
	{
		cnum = CMD_INSERT;
		temp = TMP_INSERT;
	} else if( s = strsistr(cmd, TXT_DATE) )
	{
		cnum = CMD_DATE;
		temp = TMP_DATE;
	} else if( s = strsistr(cmd, TXT_VERSION) )
	{
		cnum = CMD_VERSION;
		temp = TMP_VERSION;
	} else if( s = strsistr(cmd, TXT_PROGRAM) )
	{
		cnum = CMD_PROGRAM;
		temp = TMP_PROGRAM;
	} else if( s = strsistr(cmd, TXT_VAR) )
	{
		cnum = CMD_VAR;
		temp = TMP_VAR;
	} else if( s = strsistr(cmd, TXT_SETVAR) )
	{
		cnum = CMD_SETVAR;
		temp = TMP_SETVAR;
	} else if( s = strsistr(cmd, TXT_TAG) )
	{
		cnum = CMD_TAG;
		temp = TMP_TAG;
	} else
	{
		PrintFault(ERROR_ACTION_NOT_KNOWN, cmd);
		cnum = 0;
		temp = NULL;
		++vars->v_Tags_i;
	}
	if( cnum && temp && arg )
	{
		struct RDArgs *rda;
		
		/* Add a newline to the end of cmd (for ReadArgs()) */
		if( *cmd != '\n' )
			AddC2Cmd(cmd, '\n');
		
		if( rda = AllocDosObject(DOS_RDARGS, NULL) )
		{
			STRPTR args[OPT_ALL_MAX];
			
			rda->RDA_DAList = NULL;
			rda->RDA_Flags |= RDAF_NOPROMPT;
			rda->RDA_Buffer = NULL;
			rda->RDA_Source.CS_Buffer = arg;
			rda->RDA_Source.CS_Length = strlen(arg);
			rda->RDA_Source.CS_CurChr = 0;
			
			memset(&args, 0, (sizeof(STRPTR) * OPT_ALL_MAX));
			
			/* Parse argumesnts for the option */
			if( ReadArgs(temp, (LONG *)&args, rda) ) 
			{
				switch( cnum )
				{
					case CMD_INSERT :
						HInsertCmd(vars, destf, args[OPT_INSERT_FILE]);
						break;
						
					case CMD_VERSION :
						HVersionCmd(vars, destf, args[OPT_VERSION_FROM],
						             (BOOL)args[OPT_VERSION_FULL],
						             (BOOL)args[OPT_VERSION_NONAME],
						             (BOOL)args[OPT_VERSION_NOVER],
						             (BOOL)args[OPT_VERSION_NODATE],
						             (BOOL)args[OPT_VERSION_NOPARSEDATE],
						             (BOOL)args[OPT_VERSION_USETAG]);
						break;
						
					case CMD_PROGRAM :
						HProgramCmd(vars, destf, args[OPT_PROGRAM_CMDLINE],
						                   (BOOL)args[OPT_PROGRAM_NOLINES]);
						break;
						
					case CMD_DATE :	
						HDateCmd(vars, destf, args[OPT_DATE_FROM],
						                      args[OPT_DATE_LOCALEFORMAT],
						                      args[OPT_DATE_FORMAT] ? *((LONG *)args[OPT_DATE_FORMAT]) : 0,
						                (BOOL)args[OPT_DATE_NODAY],
						                (BOOL)args[OPT_DATE_NODATE],
						                (BOOL)args[OPT_DATE_NOTIME]);
						break;
					
					case CMD_VAR :
						HVarCmd(destf, args[OPT_VAR_FROM],
						         (BOOL)args[OPT_VAR_NEWLINE],
						         (BOOL)args[OPT_VAR_GLOBAL],
						         (BOOL)args[OPT_VAR_LOCAL]);
						break;
					
					case CMD_SETVAR :
						HSetvarCmd(args[OPT_SETVAR_NAME],
						           args[OPT_SETVAR_TEXT]);
						break;
					
					case CMD_TAG :
						HTagCmd(vars, destf, args[OPT_TAG_TAG],
						        args[OPT_TAG_NAME],
						  (BOOL)args[OPT_TAG_NONLCUT],
						  (BOOL)args[OPT_TAG_DOLLERCUT]);
						break;
				}
				++vars->v_Tags_p;
				FreeArgs(rda);
			} else
				++vars->v_Tags_i;
			FreeDosObject(DOS_RDARGS, rda);
		}
	}
	/* Clear cmd */
	memset(cmd, 0, cmdsize);
}


/*************************************************************************
 * HInsertCmd() - Handle the INSERT command.
 */

VOID HInsertCmd(struct Vars *vars, BPTR destf, STRPTR from)
{
	/* paste a file
	 * We simply recurse, call RepMarkers()
	 */
	RepMarkers(vars, from, destf, FALSE);
}


/*************************************************************************
 * HVersionCmd() - Handle the VERSION command.
 */

#define VERSION_CMD_1ST_PART "Version "
#define VERSION_CMD_2ND_PART " FULL"
#define VERBUF_SIZE 256
#define STATE_NAME 0
#define STATE_VERSION 1
#define STATE_DATE 2

VOID HVersionCmd(struct Vars *vars, BPTR destf, STRPTR from, 
                 BOOL full, BOOL noname, BOOL nover, 
                 BOOL nodate, BOOL noparsedate, BOOL usetag)
{
	STRPTR tmpname;
	
	/* Alloc tmpname */
	if( tmpname = AllocVec(14, 0) )
	{
		strcpy(tmpname, TMP_TEMP);
		mktemp(tmpname);
		if( *tmpname != 0 )
		{
			BPTR tf;
			
			/* Open temp file */
			if( tf = Open(tmpname, MODE_NEWFILE) )
			{
				/* Change buffer */
				SetVBuf(tf, NULL, vars->v_BufSize, BUF_FULL);
				
				/* Temp file is opened ok, do we use the version command or use
				 * use our internal TAG command?
				 */
				
				if( usetag )
				{
					HTagCmd(vars, tf, "VER", from, FALSE, FALSE);
				} else
				{
					STRPTR cmd;
	
					/* Alloc cmd */
					if( cmd = AllocVec(strlen(VERSION_CMD_1ST_PART) +
					                   strlen(VERSION_CMD_2ND_PART) +
					                   strlen(from) + 1, 0) )
					{
						BPTR inf;
						
						/* build the command line */
						strcpy(cmd, VERSION_CMD_1ST_PART);
						strcat(cmd, from);
						strcat(cmd, VERSION_CMD_2ND_PART);
					
						/* Open input file */
						if( inf = Open("NIL:", MODE_OLDFILE) )
						{
							if( SystemTags(cmd, SYS_Input,  inf,
							                    SYS_Output, tf,
							                    TAG_DONE) != 0 )
							{
								PrintFault(IoErr(), from);
								Close(tf);
								tf = 0;
							}
							Close(inf);
						}
						FreeVec(cmd);
					}
				}
				
				if( tf )
				{
					STRPTR verbuf;
							
					/* Version command successful, alloc verbuf */
					if( verbuf = AllocVec(VERBUF_SIZE, 0) )
					{
						/* Seek to start */
						Seek(tf, 0, OFFSET_BEGINNING);
								
						/* Read first line */
						if( FGets(tf, verbuf, VERBUF_SIZE-1) )
						{
							STRPTR s;
							LONG state = STATE_NAME;
									
							/* Remove trailing EOL */
							if( s = strchr(verbuf, '\n') )
								*s = '\0';
									
							if( !full )
							{
								for( s = verbuf; *s ; ++s )
								{
									switch( state )
									{
										case STATE_NAME :
											if( isspace(*s) )
											{
												state++;
												if( (!noname && !nover) ||
														  (!noname && nover && !nodate) )
													FPutC(destf, ' ');
												s = stpblk(s);
												--s;
											} else
											{
												if( !noname )
													FPutC(destf, *s);
											}
											break;
												
										case STATE_VERSION :
											if( isspace(*s) )
											{
												state++;
												if( !nover && !nodate )
													FPutC(destf, ' ');
												s = stpblk(s);
												--s;
											} else
											{
												if( !nover )
													FPutC(destf, *s);
											}
											break;
										
										case STATE_DATE :
											if( !nodate )
											{
												if( noparsedate )
													FPutC(destf, *s);
												else
													if( (*s != '(') && (*s != ')') )
														FPutC(destf, *s);
											}
											break;
									}
								}
							} else
								FPuts(destf, verbuf);
						}
						FreeVec(verbuf);
					}
				}
				Close(tf);
				DeleteFile(tmpname);
			}
		}
		FreeVec(tmpname);
	}
}


/*************************************************************************
 * HProgramCmd() - Handle the PROGRAM command.
 */


VOID HProgramCmd(struct Vars *vars, BPTR destf, STRPTR cmdline, BOOL noline)
{
	STRPTR tmpname;
	
	/* Alloc tmpname */
	if( tmpname = AllocVec(14, 0) )
	{
		strcpy(tmpname, TMP_TEMP);
		mktemp(tmpname);
		if( *tmpname != 0 )
		{
			BPTR tf;
				
			/* Open temp file */
			if( tf = Open(tmpname, MODE_NEWFILE) )
			{
				
				if( SystemTags(cmdline, SYS_Output, tf, TAG_END) == 0 )
				{
					Close(tf);
					tf = 0;
					/* Recurse */
					RepMarkers(vars, tmpname, destf, noline);
				} else
					PrintFault(IoErr(), cmdline);

				if( tf )
					Close(tf);
				DeleteFile(tmpname);
			}
		}
		FreeVec(tmpname);
	}
}


/*************************************************************************
 * LFFunc() - Hook function for use in HDateCmd() by FormatDate().
 */

/* 
 * NOTE: no __saveds keyword, we dont need it and it would make us unpure
 */
ULONG ASM LFFunc(REG(a0) struct Hook *hook,
                 REG(a2) struct Locale *locale,
                 REG(a1) char ch)
{
	/* hook->h_Data contains a BPTR of the file to output to */
	if( ch )
		FPutC((BPTR)hook->h_Data, ch);
	return( TRUE );
}


/*************************************************************************
 * HDateCmd() - Handle the DATE command.
 */

VOID HDateCmd(struct Vars *vars, BPTR destf, STRPTR from, STRPTR localeformat, LONG format, 
              BOOL noday, BOOL nodate, BOOL notime)
{
	struct DateStamp *ds = NULL;
	
	/* Get the datestamp */
	if( from )
	{
		BPTR l;
		
		/* Read it from a file */
		if( l = Lock(from, ACCESS_READ) )
		{
			struct FileInfoBlock *fib;
			
			/* Alloc fib */
			if( fib = AllocDosObject(DOS_FIB, NULL) )
			{
				if( Examine(l, fib) )
				{
					if( ds = AllocVec(sizeof(struct DateStamp), 0) )
					{
						/* Copy ds from the fib */
						memcpy(ds, &fib->fib_Date, sizeof(struct DateStamp));
					}
				}
				FreeDosObject(DOS_FIB, fib);
			}
			UnLock(l);
		} else
			PrintFault(IoErr(), from);
	} else
	{
		if( ds = AllocVec(sizeof(struct DateStamp), 0) )
			ds = DateStamp(ds);
	}
	if( ds )
	{
		/* Are we going to be locale or dos function based? */
		if( localeformat && vars->v_Locale )
		{
			struct Hook *LFHook;
			
			if( LFHook = AllocVec(sizeof(struct Hook), MEMF_CLEAR) )
			{
				LFHook->h_Entry	= (HOOKFUNC)LFFunc;
				
				/* Pass the file handle */
				LFHook->h_Data = (APTR)destf;
				
				FormatDate(vars->v_Locale, localeformat, ds, LFHook);
				FreeVec(LFHook);
			}
		} else
		{
			unsigned char daystr[LEN_DATSTRING], datestr[LEN_DATSTRING], timestr[LEN_DATSTRING];
			struct DateTime *dt;
			
			if( dt = AllocVec(sizeof(struct DateTime), MEMF_CLEAR) )
			{
				memcpy(&dt->dat_Stamp, ds, sizeof(struct DateStamp));
				dt->dat_Format = format;
				dt->dat_StrDay = (STRPTR)&daystr;
				dt->dat_StrDate = (STRPTR)&datestr;
				dt->dat_StrTime = (STRPTR)&timestr;
				if( DateToStr(dt) )
				{
					if( !noday )
					{
						FPuts(destf, dt->dat_StrDay);
						if( !nodate || (nodate && !notime) )
							FPutC(destf, ' ');
					}
					
					if( !nodate )
					{
						FPuts(destf, dt->dat_StrDate);
						if( !notime )
							FPutC(destf, ' ');
					}
					
					if( !notime )
						FPuts(destf, dt->dat_StrTime);	
				}
				FreeVec(dt);
			}
		}
		FreeVec(ds);
	}
}


/*************************************************************************
 * HVarCmd() - Handle the VAR command.
 */

#define VAR_BUFFER_SIZE 512

VOID HVarCmd(BPTR destf, STRPTR from, BOOL newline, BOOL global, BOOL local)
{
	STRPTR buffer;
	
	/* Alloc buffer */
	if( buffer = AllocVec(VAR_BUFFER_SIZE, 0) )
	{
		ULONG flags = LV_VAR;
		
		if( global )
			flags |= GVF_GLOBAL_ONLY;
		else if( local )
			flags |= GVF_LOCAL_ONLY;
		
		if( GetVar(from, buffer, VAR_BUFFER_SIZE, flags) != -1 )
		{
			FPuts(destf, buffer);
			if( newline )
				FPutC(destf, '\n');
		} else
			PrintFault(IoErr(), from);
		FreeVec(buffer);
	}
}


/*************************************************************************
 * HSetvarCmd() - Handle the SETVAR command.
 */

VOID HSetvarCmd(STRPTR name, STRPTR text)
{
	SetVar(name, text, -1, LV_VAR | GVF_LOCAL_ONLY);
}

/*************************************************************************
 * HTagCmd() - Handle the TAG command.
 */

#define TAGBUF_SIZE 4096

VOID HTagCmd(struct Vars *vars, BPTR destf, STRPTR tag, STRPTR from,
             BOOL nonlcut, BOOL dollercut)
{
	STRPTR stag;
	
	if( (tag) &&
	    (stag = AllocVec(strlen(tag)+4, MEMF_CLEAR)) )
	{
		BPTR f;
		
		strcpy(stag, "$: ");
		strins(++stag, tag);
		--stag;
		
		/* Open the source file */
		if( f = Open(from, MODE_OLDFILE) )
		{
			LONG i, ch;
			BOOL found = FALSE;
			
			/* Change buffer */
			SetVBuf(f, NULL, vars->v_BufSize, BUF_FULL);
			
			for( ch = FGetC(f), i = 0; (ch != -1) && (!found); ch = FGetC(f) )
				if( ch == stag[i] )
					if( stag[i+1] == 0 )
						found = TRUE;
					else
						++i;
				else
					i = 0;
					
			if( found )
				for( ;
				     (ch != -1) &&
				     (ch != '\0') &&
				     ((ch != '$') || !dollercut) &&
				     (((ch != '\r') && (ch != '\n')) || nonlcut);
				     ch = FGetC(f)
				   )
					if( ch != '\r' )
						FPutC(destf, ch);
			
			Close(f);
		}
		FreeVec(stag);
	}
}


/*************************************************************************
 * RepMarkers() - Parse a file and replace 'stuff'
 */

/* Command introducors and terminators */
#define INTRODUCER_1 '/'
#define INTRODUCER_2 '>'  /* INTRODUCER = "/>" */
#define TERMINATOR_1 '<'
#define TERMINATOR_2 '\\' /* TERMINATOR = "<\" */
#define ESCAPE_CHAR  '!'

/* When read thru a line char by char we can by in any of these states */
#define LEV_ESCAPED_2 -2
#define LEV_ESCAPED_1 -1
#define LEV_NONE 0
#define LEV_1 1
#define LEV_2 2
#define LEV_3 3

#define BUFFER_SIZE 256

#define CMD_BUF_SIZE strlen(buffer)+2

VOID RepMarkers(struct Vars *vars, STRPTR source, BPTR destf, BOOL nolines)
{
	BPTR sourcef;
	
	/* Open source file */
	if( sourcef = Open(source, MODE_OLDFILE) )
	{
		APTR buf;
		
		/* Change buffer */
		SetVBuf(sourcef, NULL, vars->v_BufSize, BUF_FULL); 

			
		/* Alloc buf */
		if( buf = AllocVec(BUFFER_SIZE, 0) )
		{
			APTR buffer;
			
			/* Go thru the source file, line by line */
			while( buffer = FGets(sourcef, buf, BUFFER_SIZE-1) )
			{
				STRPTR cmd;
				
				/* Alloc cmd buffer.
				 * strlen(buffer)+2, 1 extra for the null and 1 more cause we add
				 * on a '\n' in HInsertion()
				 */
				if( cmd = AllocVec(CMD_BUF_SIZE, MEMF_CLEAR) )
				{
					register STRPTR s;
					register LONG level = LEV_NONE;
					/*
					 * For each line we parse each character in a
					 * state machine manner.
					 */
					for( s = buffer; *s ; ++s )
					{
						switch( level )
						{
							case LEV_ESCAPED_1 :
								switch( *s )
								{
									case INTRODUCER_1 :
										level = LEV_ESCAPED_2;
										break;
									
									case ESCAPE_CHAR :
										level = LEV_ESCAPED_1;
										FPutC(destf, (LONG)ESCAPE_CHAR);
										break;
									
									default:
										level = LEV_NONE;
										FPutC(destf, (LONG)ESCAPE_CHAR);
										MFPutC(destf, (LONG)*s, nolines);
										break;
								}
								break;
															
							case LEV_ESCAPED_2 :
								if( *s == INTRODUCER_2 )
								{
									FPutC(destf, (LONG)INTRODUCER_1);
									FPutC(destf, (LONG)INTRODUCER_2);
									++vars->v_Tags_e;
								} else
								{
									FPutC(destf, (LONG)ESCAPE_CHAR);
									FPutC(destf, (LONG)INTRODUCER_1);
									MFPutC(destf, (LONG)*s, nolines);
								}
								level = LEV_NONE;
								break;
								
							case LEV_NONE :
								switch( *s )
								{
									case INTRODUCER_1 :
										level = LEV_1;
										break;
									case ESCAPE_CHAR :
										level = LEV_ESCAPED_1;
										break;
									default :
										level = LEV_NONE;
										MFPutC(destf, (LONG)*s, nolines);
										break;
								}
								break;
								
							case LEV_1 :
								if( *s == INTRODUCER_2 )
									level = LEV_2;
								else
								{
									level = LEV_NONE;
									FPutC(destf, (LONG)INTRODUCER_1);
									MFPutC(destf, (LONG)*s, nolines);
								}
								break;
						
							case LEV_2 :
								if( *s == TERMINATOR_1 )
									level = LEV_3;
								else
									AddC2Cmd(cmd, *s);
								break;
							
							case LEV_3 :
								if( *s == TERMINATOR_2 )
								{
									level = LEV_NONE;
									HInsertion(vars, destf, cmd, CMD_BUF_SIZE);
								} else
								{
									level = LEV_2;
									AddC2Cmd(cmd, TERMINATOR_1);
									AddC2Cmd(cmd, *s);
								}
								break;
						}
					}
					/* Do insertion if cmd has something in it (ie non terminated cmd) */
					if( *cmd != '\0' )
					{
						HInsertion(vars, destf, cmd, CMD_BUF_SIZE);
						MFPutC(destf, '\n', nolines);
					}
					FreeVec(cmd);
				}
			}				
			FreeVec(buffer);
		}
		Close(sourcef);
	} else
		PrintFault(IoErr(), source);
}


/*************************************************************************
 * main() - Ehhh... It's kinda ehhh...
 */

int main( VOID )
{
	LONG rc = 10;
	if( (((struct Library *)DOSBase)->lib_Version > 35) &&
	    (((struct Library *)SysBase)->lib_Version > 35) )
	{
		struct Vars *vars;
		
		/* Allocate var structure */
		if( vars = AllocVec(sizeof(struct Vars), MEMF_CLEAR) )
		{
			struct RDArgs *rdargs;
			#define TEMPLATE "SOURCE/A,DESTINATION,BUFFER/K/N,QUIET/S"
			#define OPT_SOURCE 0
			#define OPT_DEST 1
			#define OPT_BUFFER 2
			#define OPT_QUIET 3
			#define OPT_MAX 4
			#define DEF_BUFFER 4096
			STRPTR args[OPT_MAX] = {0, 0, 0, 0};
			#define ARG_SOURCE args[OPT_SOURCE]
			STRPTR  ARG_DEST;
			#define ARG_QUIET (BOOL)args[OPT_QUIET]
		
			/* Open Locale */
			if( vars->v_LocaleBase = (struct LocaleBase *)OpenLibrary("locale.library", 38) )
				vars->v_Locale = OpenLocale(NULL);
			else
				vars->v_Locale = NULL;
			LocaleBase = vars->v_LocaleBase;
		
			/* Parse arguments */
			if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL))
			{
				BPTR srcl;
				
				ARG_DEST = args[OPT_DEST];
				
				if( args[OPT_BUFFER] )
					vars->v_BufSize = ((*((LONG *)args[OPT_BUFFER]) >= 208) ?
					                     *((LONG *)args[OPT_BUFFER]) :
					                     DEF_BUFFER);
				else
					vars->v_BufSize = DEF_BUFFER;
				
				/* Lock source */
				if( srcl = Lock(ARG_SOURCE, ACCESS_READ) )
				{
					BOOL makefilename = FALSE;
					BOOL destok = TRUE;
					
					if( ARG_DEST )
					{
						BPTR destl;
					
						/* Try to lock dest */
						if( destl = Lock(ARG_DEST, ACCESS_READ) )
						{
							/* Same file? */
							if( SameLock(srcl, destl) == LOCK_SAME )
							{
								destok = FALSE;
								SetIoErr(ERROR_OBJECT_EXISTS);
							}
							UnLock(destl);
						}
					} else
						makefilename = TRUE;
					
					if( makefilename )
					{
						/* Use a temp file */
						
						if( ARG_DEST = AllocVec(14, 0) )
						{
							strcpy(ARG_DEST, TMP_TEMP);
							mktemp(ARG_DEST);
							if( *ARG_DEST != 0 )
								destok = TRUE;
						}
					}
					
					if( destok )
					{
						BPTR destf;
						if( destf = Open(ARG_DEST, MODE_NEWFILE) )
						{
							/* Change buffer */
							SetVBuf(destf, NULL, vars->v_BufSize, BUF_FULL);
							
							RepMarkers(vars, ARG_SOURCE, destf, FALSE);
							Close(destf);
							if( !ARG_QUIET )
							{
								if( vars->v_Tags_p )
									Printf("%ld tags processed\n", vars->v_Tags_p);
								if( vars->v_Tags_e )
									Printf("%ld tags escaped\n", vars->v_Tags_e);
								if( vars->v_Tags_i )
									Printf("%ld invalid tags\n", vars->v_Tags_i);
							}
							rc = 0;
						}
					}
					
					UnLock(srcl);
					
					if( makefilename )
					{
						if( rc == 0)
						{
							BPTR src;
							
							/* Copy ARG_DEST to ARG_SOURCE */
							
							if( src	= Open(ARG_DEST, MODE_OLDFILE) )
							{
								BPTR dest;
								
								if( dest = Open(ARG_SOURCE, MODE_NEWFILE) )
								{
									LONG ch;
									
									for( ch = FGetC(src); ch != -1; ch = FGetC(src) )
										FPutC(dest, ch);
									
									Close(dest);
								}
								Close(src);
							}
						}
						
						/* Delete the temp file */
						DeleteFile(ARG_DEST);
						
						/* Free name buffer */
						FreeVec(ARG_DEST);
					}

				}
				FreeArgs(rdargs);
			}
		
			if( vars->v_Locale )
				CloseLocale(vars->v_Locale);
				
			if( vars->v_LocaleBase )
				CloseLibrary((struct Library *)vars->v_LocaleBase);
			
			FreeVec(vars);
		}
	}
	if( rc )
		PrintFault(IoErr(), "Umentiler");
	return( rc );
}
