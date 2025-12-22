/*
 * YourFault, 1995 Lee Kindness.
 *
 * Patches the error strings returned by dos.library to your own.
 * WARNING: It patches a private dos function!! (dosPrivate5())
 *
 * This source is in the public domain, do with it as you wish...
 *
 * version 1.5
 *
 ***************************************************************************/

#include "gst.c"

/* download dev/c/SFPatch.lha for documentation */
#include "SFPatch.h"

/* DONT auto open... */
extern struct IntuitionBase *IntuitionBase = NULL;
extern struct Library *CxBase = NULL;
extern struct Library *IconBase = NULL;

/* Save a bit of typing */
#define REG(x) register __ ## x

/* The function offset of dosPrivate5() */
#define DP5OFFSET -978

/* Default file from which the strings are to read from */
#define ERRSFILENAME "S:FaultStrings"

/* types */
typedef STRPTR __asm (*dP5Caller)( REG(d1) LONG, REG(a6) struct Library *);

/* ErrorStringNode */
typedef struct ESNode {
	struct ESNode *es_Succ;
	struct ESNode *es_Pred;
	UBYTE          es_Type;
	BYTE           es_Pri;
	STRPTR         es_String;
	LONG           es_Number;
} ESNode;


/* Prototypes */
STRPTR __asm new_dosPrivate5(REG(d1) LONG,REG(a6) struct Library *);
struct List *LoadErrStrings(STRPTR);
BOOL OpenLibs(void);
void CloseLibs(void);
BOOL ShowWindow(void);

/* Global vars */
SetFunc *dP5sf;
struct List *codes;
struct Remember *grk;
BOOL Active;
char vertag[] = "$VER: YourFault 1.6 "__AMIGADATE__;

/***************************************************************************/

/* main */
int main(int argc, char **argv)
{
	int ret;		
	ret = RETURN_OK;
	Active = TRUE;
	grk = NULL;
	
	/* check version */
	if (OpenLibs()) {
		char StringsFName[80] = ERRSFILENAME;
		struct NewBroker nb = {
			NB_VERSION,
			"YourFault",
			&vertag[6],
			"Patches the system error strings.",
			NBU_UNIQUE | NBU_NOTIFY,
			COF_SHOW_HIDE,
			-1,
			NULL,
			0
		};
		CxObj *broker;
	
		/* Get tooltypes */
		if (argc ? FALSE : TRUE) {
			BPTR oldcd;
			struct DiskObject *dobj;
			struct WBStartup *wbs;
			#define PROGNAME wbs->sm_ArgList->wa_Name
			#define PDIRLOCK wbs->sm_ArgList->wa_Lock
			wbs = (struct WBStartup *)argv;
			/* Run from WB */
			oldcd = CurrentDir(PDIRLOCK);
			if (dobj = GetDiskObject(PROGNAME)) {
				STRPTR s;
				if (s = FindToolType(dobj->do_ToolTypes, "FROM")) {
					strncpy((STRPTR)&StringsFName, s, 79);
					StringsFName[79] = NULL;
				}
				FreeDiskObject(dobj);
			}
			CurrentDir(oldcd);
		} else {
			struct RDArgs *rdargs;
			#define OPT_FROM 0
			LONG args[2] = {0};
			#define TEMPLATE "FROM"
			/* Run from Shell */
			if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL)) {
				if (args[OPT_FROM]) {
					strncpy((STRPTR)&StringsFName, (STRPTR) args[OPT_FROM], 79);
					StringsFName[79] = NULL;
				}
				FreeArgs(rdargs);	
			}
		}
		
		if ((nb.nb_Port = CreateMsgPort()) && (broker = CxBroker(&nb, NULL))) {
			
			ActivateCxObj(broker, 1L);
			if (codes = LoadErrStrings((STRPTR)&StringsFName)) {
				/* Alloc our SetFunc */
				if (dP5sf = AllocVec(sizeof(SetFunc), MEMF_CLEAR)) {

					/* init. sfs */
					dP5sf->sf_Func = new_dosPrivate5;
					dP5sf->sf_Library = (struct Library *)DOSBase;
					dP5sf->sf_Offset = DP5OFFSET;
					dP5sf->sf_QuitMethod = SFQ_COUNT;
					
					/* Replace the function */
					if (SFReplace(dP5sf)) {

						ULONG sig, sret;
						BOOL finished;
								
						finished = FALSE;
						sig = 1 << nb.nb_Port->mp_SigBit;
					
						do {
							sret = Wait(SIGBREAKF_CTRL_C | sig);
							if (sret & sig) {
								CxMsg *msg;
								while(msg = (CxMsg *)GetMsg(nb.nb_Port)) {
									switch(CxMsgType(msg)) {
										case CXM_COMMAND:
											switch(CxMsgID(msg)) {
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
	
						/* Restore function */
						SFRestore(dP5sf);
					}
					FreeVec(dP5sf);
				}
			} else {
				DisplayBeep(NULL);
				ret = RETURN_FAIL;
			}
	
			DeleteCxObj(broker);
			DeletePort(nb.nb_Port);
		}
	}
	CloseLibs();
	return(ret);
}

/***************************************************************************/
/* Show our window... currently only a requester */
BOOL ShowWindow(void)
{
	struct EasyStruct ez = {
		sizeof(struct EasyStruct),
		0,
		"YourFault",
		"%s ©Lee Kindness.\n\n"
		"cs2lk@scms.rgu.ac.uk\n\n"
		"Replaces the system error strings\n"
		"with your own...\n\n"
		"Read \"YourFault.guide\" for more information\n\n"
		"(Program may take a couple of seconds to quit)",
		"Quit|Hide"
	};
	return((BOOL)EasyRequest(NULL, &ez, NULL, &vertag[6]));
}

/***************************************************************************/
/* Open all used libraries */
BOOL OpenLibs(void)
{
	BOOL ret;
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
	CxBase = OpenLibrary("commodities.library", 36);
	IconBase = OpenLibrary("icon.library", 0);
	ret = ((DOSBase->dl_lib.lib_Version > 36) && 
	       (IntuitionBase) && 
	       (CxBase) && 
	       (IconBase));
	return(ret);
}

/***************************************************************************/
/* Close all libraries */
void CloseLibs(void)
{
	if (IconBase)
		CloseLibrary(IconBase);
	if (CxBase)
		CloseLibrary(CxBase);
	if (IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}

/***************************************************************************/
/* load the strings from the file fname into our list 
 *
 * The following tokens are special within the file:
 *   ':', '|' and '#' on the first column of a line denote a comment.
 *   '^' is replaced by '\n'
 */
struct List *LoadErrStrings(STRPTR fname)
{
	BPTR f;
	char *sptr, *s, *buf;
	struct List *l;
	ESNode *esn;
	
	l = NULL;
	/* alloc buffer */
	buf = AllocVec(180, MEMF_CLEAR);
	if (buf) {
		/* open the file */
		f = Open(fname, MODE_OLDFILE);
		if (f) {
			/* alloc the list */
			l = AllocRemember(&grk, sizeof(struct List), MEMF_CLEAR);
			if (l) {
				/* initilise the list */
				NewList(l);
				/* Parse the file... */
				s = FGets(f, buf, 180);
				while (s) {
					/* is it a comment? */
					if ((s[0] != ';') && (s[0] != '#') && (s[0] != '|')) {
						/* no, alloc node */
						esn = AllocRemember(&grk, sizeof(ESNode), MEMF_CLEAR);
						if (esn) {
							/* convert integer at start of string */
							esn->es_Number = atol(buf);
							sptr = strchr(buf, ':');
							if (sptr) {
								sptr++;
								/* remove 0x0A */
								sptr[strlen(sptr)-1] = 0;
								/* strip blanks */
								sptr = stpblk(sptr);
								/* alloc mem */
								esn->es_String = AllocRemember(&grk, (strlen(sptr)+1), MEMF_CLEAR);
								if (esn->es_String) {
									STRPTR s;
									#define FINDCHAR '^'
									#define REPLACECHAR '\n'
									
									/* copy string */
									strcpy(esn->es_String, sptr);
									
									/* replace all FINDCHAR with REPALCECHAR */
									s = esn->es_String;
									while(*s != '\0')
									{
										if(*s == FINDCHAR)
											*s = REPLACECHAR;
										s++;
									}
									
									/* add to list */
									AddTail(l, (struct Node *)esn);
								}
							}
						}
					}
					s = FGets(f, buf, 180);
				}
			}
			Close(f);
		}
		FreeVec(buf);
	}
	return(l);
}

/***************************************************************************/
/* The new dosPrivate5() */
STRPTR __saveds __asm new_dosPrivate5(REG(d1) LONG code,
                                      REG(a6) struct Library *lib)
{
	ESNode *esn, *foundnode;
	STRPTR ret;

	/* increment count */
	Forbid();
	dP5sf->sf_Count += 1;
	Permit();
	
	ret = NULL;
	if (Active) 
	{
		foundnode = NULL;
		/* search for a matching code in the list */
		esn = (ESNode *)codes->lh_Head;
		while (esn->es_Succ) {
			if (esn->es_Number == code)
				foundnode = esn;
			esn = esn->es_Succ;
		}
		if (foundnode) 
		{
			/* return the string */
			ret = foundnode->es_String;
		}
	}
	
	if (ret == NULL)
		/* pass the buck... */
		ret = ((dP5Caller)(dP5sf->sf_OriginalFunc))(code, lib);
	
	/* decrement count */
	Forbid();
	dP5sf->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);
}
/***************************************************************************/