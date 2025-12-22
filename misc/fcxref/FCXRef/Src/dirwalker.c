/*:ts=4			dirwalker.c
 */
#include <proto/exec.h>
#include <proto/dos.h>
#include <exec/execbase.h>
#include <exec/memory.h>

#include <string.h>

#include "dirwalker.h"

#define EXEC_MINIMUM 39
#define DOS_MINIMUM  39

struct ExecBase   *SysBase;
struct DosLibrary *DOSBase;

#define MAX_PATH_LENGTH 1024


int dirwalker(char *basedir,char *dpatt,char *fpatt,fpnt dirin, fpnt dirout, fpnt file) {
static struct AnchorPath *AnchorPath;
static char allpatt[]="#?";
static char defbasedir[]="PROGDIR:";
  int done=0,ret=-1,dlen,flen;
  BPTR OldDir,CurDir;
  char *ftoken,*dtoken;

  if(basedir==NULL) basedir=defbasedir;
  if(dpatt==NULL) dpatt=allpatt;
  if(fpatt==NULL) fpatt=allpatt;
  SysBase=*(struct ExecBase **)4;
  if(SysBase->LibNode.lib_Version>=EXEC_MINIMUM) {
  	flen=(strlen(fpatt)*2)+2;
	if(NULL!=(ftoken=AllocVec(flen,MEMF_ANY))) {
	if(-1!=(ParsePatternNoCase(fpatt,ftoken,flen))) {
  	dlen=(strlen(dpatt)*2)+2;
	if(NULL!=(dtoken=AllocVec(dlen,MEMF_ANY))) {
	if(-1!=(ParsePatternNoCase(dpatt,dtoken,dlen))) {
    if((DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",DOS_MINIMUM))) {
	  if(0!=(CurDir=Lock(basedir,ACCESS_READ))) {
		  OldDir=CurrentDir(CurDir);
	      if((AnchorPath=AllocVec(sizeof(struct AnchorPath)+MAX_PATH_LENGTH,MEMF_CLEAR))) {
    	    AnchorPath->ap_BreakBits=SIGBREAKF_CTRL_C;
	        AnchorPath->ap_Strlen=MAX_PATH_LENGTH;
        	if(!MatchFirst("#?",AnchorPath)) {
    	      do {
	            if(AnchorPath->ap_Info.fib_DirEntryType>0) {
            	  if(AnchorPath->ap_Flags&APF_DIDDIR) {
        	        AnchorPath->ap_Flags&=~APF_DIDDIR;
    	            if(dirout!=NULL&&(MatchPatternNoCase(dtoken,AnchorPath->ap_Info.fib_FileName))) {
						done=dirout(AnchorPath->ap_Buf);
						ret=0;
					}
	              } else {
            	    AnchorPath->ap_Flags|=APF_DODIR;
        	        if(dirin!=NULL&&(MatchPatternNoCase(dtoken,AnchorPath->ap_Info.fib_FileName))) {
						done=dirin(AnchorPath->ap_Buf);
						ret=0;
					}
    	          }
	            } else {
            	  if(file!=NULL&&(MatchPatternNoCase(ftoken,AnchorPath->ap_Info.fib_FileName))) {
					done=file(AnchorPath->ap_Buf);
					ret=0;
				  }
        	    }
    	      } while(!MatchNext(AnchorPath)&&done==0);
	          MatchEnd(AnchorPath);
        	}
    	    FreeVec(AnchorPath);
	      }
		  UnLock(CurDir);
		  CurrentDir(OldDir);
	  }
      CloseLibrary((struct Library *)DOSBase);
    }
    }
    FreeVec(dtoken);
    }
    }
    FreeVec(ftoken);
    }
  }
  return(ret);
}


