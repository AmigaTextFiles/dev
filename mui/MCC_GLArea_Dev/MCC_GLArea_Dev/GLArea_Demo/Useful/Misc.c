/*----------------------------------------------------
  Misc.cc
  Version 0.1
  Date: 13.12.1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: Miscellenous help function
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <proto/graphics.h>
#include <proto/asl.h>
#include <proto/dos.h>

#include <exec/exec.h>
#include <intuition/intuition.h>

#include "Misc.h"

extern struct ExecBase *SysBase;

//---------- Check CPU --------
int CheckCPU() {
    int flags=(int) SysBase->AttnFlags;
    // printf("AttnFlags:%d\n",flags);
    if (flags&AFF_68040) {
	// if (!strcmp(COMPILED_FOR_CPU_MODEL,"68040")) {
	//     puts("68040 detected");
	return MC68040;
    }
    else if (flags&AFF_68030) {
	return MC68030;
    }
    else if (flags&AFF_68020) {
	return MC68020;
    }
    else if (flags&AFF_68010) {
	return MC68010;
    }
    else {
	return MC68000;
    };
    // printf("AFF_68040:%d\n",AFF_68040);
}
BOOL CheckFPU() {
    int flags=(int) SysBase->AttnFlags;
    if (flags&AFF_68881) {
	return TRUE;
    }
    else if (flags&AFF_68882) {
	return TRUE;
    }
    else {
	return FALSE;
    };
}

//----------------- Return the display mode name -------------------------
void ConvertDisplayID (char *st,int id) {
   struct NameInfo ni;
   if (GetDisplayInfoData(NULL,
			  (UBYTE *) &ni,
			  sizeof(struct NameInfo),
			  DTAG_NAME,
			  (ULONG) id)) {
      strncpy(st,(char *) ni.Name,255);
      // puts("Not NULL");
      // return ni.Name;
   };
}

//---------- OpenASL -----------
BOOL OpenASL (char *title, char *sdir, char *sname , char *filename, char *dir, char *name) {
    BOOL rep=FALSE;
    struct FileRequester *fr=NULL;
    // puts("In OpenASL");

    struct TagItem FRTags[] = { {ASL_Hail, (ULONG) title},
				{ASL_Dir, (ULONG) sdir},
				{ASL_File, (ULONG) sname},
				{TAG_DONE} };
    fr=AllocFileRequest();
    rep=(BOOL) AslRequest(fr,FRTags);
    // printf("rep=%d\n",rep);
    // puts ("ok");
    if (rep) {
	strcpy(name,fr->rf_File);
	strcpy(dir,fr->rf_Dir);
	strcpy(filename,fr->rf_Dir);
	AddPart(filename,name,255);
    };
    // printf("Load File Found:%s\n",filename);
    FreeFileRequest(fr);
    return rep;
}
