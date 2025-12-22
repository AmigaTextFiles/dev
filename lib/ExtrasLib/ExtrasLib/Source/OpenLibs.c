//#define __USE_SYSBASE
#include <proto/exec.h>

#include <clib/extras/exec_protos.h>
#include <extras/libs.h>


#include <proto/intuition.h>

#include <string.h>
#include <exec/memory.h>
#include <stdio.h>
#include "libcode.h" // defines LIBCODE

void NeedLibs_WB(STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              STRPTR ButtonText, 
              struct Libs *Libs);
              
void NeedLibs_CLI(STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              struct Libs *Libs);


/****** extras.lib/ex_OpenLibs ******************************************
*
*   NAME
*       ex_OpenLibs -- attempt to open multiple libraries.
*
*   SYNOPSIS
*       success = ex_OpenLibs(Argc,ProgName,ErrorStr,
*                   LibVerFmt,ButtonText,Libs)
*
*       BOOL ex_OpenLibs(ULONG Argc, STRPTR ProgName, STRPTR ErrorString, 
*              STRPTR LibVerFmt, STRPTR ButtonText, struct Libs *Libs);
*
*   FUNCTION
*       Attempt to open multiple Libraries.  If any library
*       fails to open, a requester is opened to notify the 
*       user listing all of the libraries that failed to open. 
*
*   INPUTS
*       Argc       - argc from main()
*       ProgName   - pointer to a string containing the 
*                   program's name.
*       ErrorStr   - error string.  May be NULL.  Defaults to
*                   "The following libraries are required:\n";
*       LibVerFmt  - printf style format string.  Defaults to 
*                    "  %s version %ld\n"
*       ButtonText - If a requester is used to display an error
*                    message, this text is used in the button.
*                    Defaults to "Ok"
*       Libs       - an array of libraries to open.
*
*   RESULT
*       return 0 on failure and non-zero on success.
*
*   EXAMPLE
*       struct IntuitionBase *IntuitionBase;
*       struct GfxBase *GfxBase;
*       struct Library *GadToolsBase;
*       
*       struct Libs MyLibs[]=
*       {
*         &IntuitionBase,"intuition.library"    ,37, 0,
*         &GfxBase      ,"graphics.library"     ,37, 0,
*         &GadToolsBase ,"gadtools.library"     ,37, 0,
*         &LocaleBase   ,"datatypes.library"    ,39, OLF_OPTIONAL,
*         0,0,0
*       };
*
*       void main(int argc, char **argv) 
*       {
*         if(ex_OpenLibs(arcg,"MyProgram",0,0,0,MyLibs))
*         {
*           ...
*           CloseLibs(MyLibs);
*         }
*       }
*
*   NOTES
*       On error, this function will automatically display an 
*       intuition requester if Argc=0 or print error information 
*       out to STDIO if Argc>0.
*
*       exec.library must already be open.(usually done by the 
*       compiler's startup code)
*
*       revision 1.1
*         autodoc fix
*         now opens exec.library on it's own.
*       revision 1.2
*         renamed to ex_OpenLib due to conflict with reaction.lib
*
*       
*
*   BUGS
*
*   SEE ALSO
*       ex_CloseLibs()
******************************************************************************
*
*/

BOOL ex_OpenLibs(ULONG Argc, 
              STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              STRPTR ButtonText, 
              struct Libs *Libs)
{
  struct ExecBase *SysBase;
  struct Libs *l;
  BOOL rv=TRUE;

  SysBase=(struct ExecBase *)(*((ULONG *)4));

#ifndef LIBCODE
  if(!ErrorString)
    ErrorString=(STRPTR)"The following libraries are required:\n";
  if(!LibVerFmt)
    LibVerFmt=(STRPTR)"  %s version %ld\n";
  if(!ButtonText)
    ButtonText=(STRPTR)"Ok";
#endif

  l=Libs;
  while(l->LibBase)
  {
    *l->LibBase=NULL;
    l++;
  }

  l=Libs;
  while(l->LibBase)
  {
    if(!(*l->LibBase=OpenLibrary(l->LibName,l->Version)))
    {
      if(!(l->Flags & OLF_OPTIONAL))
      {
        rv=FALSE;
      }
    }
    l++;
  }
  
  if(!rv)
  {
#ifndef LIBCODE
    if(Argc==0)
    {
      NeedLibs_WB(ProgName,ErrorString,LibVerFmt,ButtonText,Libs);
    }
    else
    {
      NeedLibs_CLI(ProgName,ErrorString,LibVerFmt,Libs);
    }
#endif
    ex_CloseLibs(Libs);
  }
  return(rv);
}

#ifndef LIBCODE
void NeedLibs_WB(STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              STRPTR ButtonText, 
              struct Libs *Libs)
{
  struct IntuitionBase *IntuitionBase;
  UBYTE  *str,*s2;
  ULONG l,len,reqlen,arglen;
  struct EasyStruct es;
 
  IntuitionBase =(struct IntuitionBase *)OpenLibrary((STRPTR)"intuition.library",0);
  
  if(IntuitionBase)
  {
    len=strlen(ErrorString);
    arglen=strlen(LibVerFmt);
    reqlen=len;
    
    l=0;
    while(Libs[l].LibBase)
    {
      if(*Libs[l].LibBase==0 && !(Libs[l].Flags & OLF_OPTIONAL))
      {
        reqlen+=strlen(Libs[l].LibName);
        reqlen+=7;  // for the Version #
        reqlen+=arglen;
      }
      l++;
    }

    if(str=AllocVec(reqlen+1,MEMF_CLEAR|MEMF_PUBLIC))
    {
      strcpy(str,ErrorString);
      s2=str+len;

      l=0;
        
      while(Libs[l].LibBase)
      {
        if(!(*Libs[l].LibBase))
        {
          s2+=sprintf(s2,LibVerFmt,Libs[l].LibName,Libs[l].Version);
        }
        l++;
      }
      es.es_StructSize    =sizeof(struct EasyStruct);
      es.es_Flags         =0;
      es.es_Title         =ProgName;
      es.es_TextFormat    =str;
      es.es_GadgetFormat  =ButtonText;
      EasyRequest(0,&es,0);
      FreeVec(str);
    }
    CloseLibrary((struct Library *)IntuitionBase);
  }
}

void NeedLibs_CLI(STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              struct Libs *Libs)
{
  ULONG l=0;
 
  printf("%s: %s",ProgName,ErrorString);
  while(Libs[l].LibBase)
  {
    if(!(*Libs[l].LibBase))
    {
      printf(LibVerFmt,Libs[l].LibName,Libs[l].Version);
    }
    l++;
  }
  printf("\n");
}

#endif