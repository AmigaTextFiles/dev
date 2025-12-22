/*****************************************************************************
;  :Module.	dumpfile.c
;  :Author.	Bert Jahn
;  :EMail.	jah@fh-zwickau.de
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: dumpfile.c 0.8 2004/06/14 19:12:08 wepl Exp wepl $
;  :History.	18.07.98 started
;		13.12.98 dumpfilename from whdload.prefs
;		02.03.00 expmem stuff added
;			 freedump() now resets all pointer
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC
*****************************************************************************/

#include <string.h>

#include <dos/exall.h>
#include <exec/memory.h>
#include <libraries/iffparse.h>
#include <libraries/mui.h>

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/muimaster_protos.h>

#include "whddump.h"
#include "WHDLoadGCI.h"

/****************************************************************************/

APTR	* dumpfile = NULL;

/****************************************************************************/

void freedump(void) {
	if (dumpfile) {
		FreeVec(dumpfile);
		dumpfile = NULL;
	}
	header = NULL;
	term = NULL;
	cpu = NULL;
	custom = NULL;
	ciaa = NULL;
	ciab = NULL;
	slave = NULL;
	mem = NULL;
	emem = NULL;
}

BOOL loaddump(STRPTR name) {
	BOOL ret = FALSE;
	BPTR fh;
	ULONG size;
	ULONG *tmp;
	char filename[256]="";
	char s[256];
	char *t;
	ULONG chk_id,chk_len;

	/*
	 * free any loaded dump
	 */
	freedump();

	/*
	 * if there is no filename for the dump overgiven try to load
	 * whdload config and get the path from there
	 */
	if (name) {
		strcpy(filename,name);
	} else {
		fh = Open("S:whdload.prefs",MODE_OLDFILE);
		if (fh) {
			while (FGets(fh,s,256)) {
				if (strnicmp("coredumppath=",s,13) == 0) {
					t = strpbrk(&s[13]," \t\n\r");
					if (t) strncpy(filename,&s[13],t-s-13);
					else strcpy(filename,&s[13]);
					break;
				}
			}
			Close(fh);
		}
		strcat(filename,".whdl_dump");
	}
		
	/*
	 * load dump
	 */
	if (NULL == (fh = Open(filename,MODE_OLDFILE))) {
			MUI_Request(app,win,0,NULL,"Ok","Could not open dumpfile \"%s\".",filename);
		} else {
		Seek(fh,0,OFFSET_END);
		size = Seek(fh,0,OFFSET_BEGINNING);
		if ((dumpfile = AllocVec(size,0))) {
			if (size == Read(fh,dumpfile,size)) {
				tmp = (ULONG*)dumpfile;
				if (*tmp++ == ID_FORM && *tmp++ == size-8 && *tmp++ == ID_WHDD) {
					size -= 12;
					do {
						chk_id = *tmp++;
						chk_len = *tmp++;
						switch (chk_id) {
						case ID_HEAD:
							header = (struct whddump_header*)tmp;
							break;
						case ID_TERM:
							term = (char*)tmp;
							break;
						case ID_CPU:
							cpu = (struct whddump_cpu*)tmp;
							break;
						case ID_CUST:
							custom = (struct whddump_custom*)tmp;
							break;
						case ID_CIAA:
							ciaa = (struct whddump_cia*)tmp;
							break;
						case ID_CIAB:
							ciab = (struct whddump_cia*)tmp;
							break;
						case ID_SLAV:
							slave = (APTR)tmp;
							break;
						case ID_MEM:
							mem = (APTR)tmp;
							break;
						case ID_EMEM:
							emem = (APTR)tmp;
							break;
						}
						size -= 8 + chk_len;
						tmp += chk_len>>2;
						if (!size) ret = TRUE;
					} while (size>8 && !ret);
				}
			}
			if (!ret) {
				FreeVec(dumpfile);
				dumpfile = NULL;
				MUI_Request(app,win,0,NULL,"Ok","Dumpfile \"%s\" is corrupt.",filename);
			}
		}
		Close(fh);
	}
	return ret;
}

/****************************************************************************/

