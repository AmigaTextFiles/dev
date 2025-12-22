
#include <exec/lists.h>
#include <libraries/dos.h>
#include <rexx/rxslib.h>
#include <rexx/errors.h>

#include <clib/rexxsyslib_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *VersionString = "$VER: SAS/C Rexx Interface V1.00";
char *_procname = "Oh-no! More LSE";

#ifndef DEBUG
extern BPTR _Backstdout;
#endif

struct RxsLib *RexxSysBase;

#pragma libcall RexxSysBase CreateArgstring 7E 0802
#pragma libcall RexxSysBase DeleteArgstring 84 801
#pragma libcall RexxSysBase CreateRexxMsg 90 09803
#pragma libcall RexxSysBase DeleteRexxMsg 96 801

#define LSE_PORT_NAME "Lse"

char *Commands[] ={"OW","LE","NE","QU",NULL};

struct Error
 {
  struct Node Err_Node;
  LONG Err_Line;
  char Err_Text[256];
 };
struct List ErrorList;

struct MsgPort *CreateRexxPort(char *Name)

{
 struct MsgPort *NewRexxPort;

 Forbid();
 if (FindPort(Name)) NewRexxPort=NULL;
 else NewRexxPort=CreatePort(Name,0);
 Permit();

 return NewRexxPort;
}

LONG SendRexxMsg(char *Command)

{
 struct MsgPort *ReplyPort,*TargetPort;
 struct RexxMsg *OutRexxMsg;
 UBYTE *CmdArgstring;

 if (ReplyPort=CreatePort(NULL,0))
  {
   if (OutRexxMsg=CreateRexxMsg(ReplyPort,NULL,RXSDIR))
    {
     if (CmdArgstring=CreateArgstring(Command,strlen(Command)))
      {
#ifdef DEBUG
       OutRexxMsg->rm_Action=RXCOMM;
#else
       OutRexxMsg->rm_Action=RXCOMM|RXFF_NOIO;
#endif
       OutRexxMsg->rm_Args[0]=(STRPTR)CmdArgstring;

       Forbid();
       if (TargetPort=FindPort(RXSDIR))
        {
         PutMsg (TargetPort,&OutRexxMsg->rm_Node);
         Permit();

         (void)WaitPort(ReplyPort);
         (void)GetMsg(ReplyPort);

#ifdef DEBUG
         printf ("OUT: %s\n",CmdArgstring);
#endif
         DeleteArgstring (CmdArgstring);
         DeleteRexxMsg (OutRexxMsg);
         DeletePort (ReplyPort);

         return TRUE;
        }
       Permit();
       DeleteArgstring (CmdArgstring);
      }
     DeleteRexxMsg (OutRexxMsg);
    }
   DeletePort (ReplyPort);
  }

 return FALSE;
}

void SetResult(struct RexxMsg *RexxMsg,LONG Result)

{
 RexxMsg->rm_Result1=Result;
 RexxMsg->rm_Result2=NULL;
}

char *BaseName(char *FileName)

{
 char *BN;

 BN=FileName;
 while (*FileName)
  {
   if ((*FileName==':')||(*FileName=='/')) BN=++FileName;
   else FileName++;
  }
 return BN;
}

LONG LoadErrorFile(char *ErrorName,char *SourceName)

{
 FILE *ErrorFile;
 char Buffer[256],ThisName[128],*Ptr;
 struct Error *NextError;

 while (ErrorList.lh_Head->ln_Succ)
  {
   NextError=(struct Error *)ErrorList.lh_Head;
   RemHead (&ErrorList);
   free (NextError);
  }

 if (ErrorFile=fopen(ErrorName,"r"))
  {
   while (fgets(Buffer,255,ErrorFile))
    {
     if (Ptr=strchr(Buffer,'\n')) *Ptr='\0';
     if (NextError=malloc(sizeof(struct Error)))
      {
       if ((sscanf(Buffer,"%s %ld %s",ThisName,&NextError->Err_Line,NextError->Err_Text)==3)&&
           (strcmp(SourceName,ThisName)==0))
        {
         strcpy (NextError->Err_Text,strchr(strchr(Buffer,' ')+1L,' ')+1L);
         AddTail (&ErrorList,&NextError->Err_Node);
         printf ("LE INSERT: %ld %s\n",NextError->Err_Line,NextError->Err_Text);
        }
       else
        {
#ifdef DEBUG
         printf ("LE IGNORE: %s\n",Buffer);
#endif
         free (NextError);
        }
      }
     else
      {
       fclose (ErrorFile);
       return FALSE;
      }
    }
   fclose (ErrorFile);
   return TRUE;
  }

 return FALSE;
}

UBYTE *StripString(UBYTE *From)

{
 UBYTE *To,*Ptr;
 
 if (To=CreateArgstring(From,strlen(From)))
  {
   Ptr=To;
   while (*From==' ') From++;

   while ((*From!='\0')&&(*From!='\n')&&(*From!='\r')) *Ptr++=*From++;
   *Ptr='\0';
  }

 return To;
}

LONG ParseCommand(UBYTE *Command,LONG *Done)

{
 ULONG Index,Length;
 static char FileName[128];
 static LONG FileOpen=FALSE;
 static UBYTE CmdBuffer[144];
 struct Error *NextError;

 for (Index=0L; Commands[Index]!=NULL; Index++)
  {
   Length=strlen(Commands[Index]);
   if ((strnicmp(Commands[Index],Command,Length)==0L)&&
       ((Command[Length]==' ')||(Command[Length]=='\0')))
    {
     Command+=Length;
     while (*Command==' ') Command++;
     break;
    }
  }
 switch (Index)
  {
   case 0:
    strcpy (FileName,Command+2L);
    sprintf (CmdBuffer,"SRIOpen %s",FileName);
    if (FileOpen=SendRexxMsg(CmdBuffer)) return RC_OK;
    return RC_WARN;
   case 1:
    if (!FileOpen) return RC_WARN;

    if (LoadErrorFile(Command,BaseName(FileName))) return RC_OK;
    return RC_WARN;
   case 2:
    if (!FileOpen) return RC_WARN;

    if (ErrorList.lh_Head->ln_Succ)
     {
      NextError=(struct Error *)ErrorList.lh_Head;
      RemHead (&ErrorList);
      sprintf (CmdBuffer,"SRIShowError %s %ld %s",FileName,
               NextError->Err_Line,NextError->Err_Text);
     }
#ifdef GERMAN
    else sprintf (CmdBuffer,"SRIShowError %s 0 Keine weiteren Fehler !",FileName);
#else
    else sprintf (CmdBuffer,"SRIShowError %s 0 No more Errors !",FileName);
#endif

    if (SendRexxMsg(CmdBuffer)) return RC_OK;
    else return RC_WARN;
   case 3:
    *Done=TRUE;
    return RC_OK;
  }

 return RC_ERROR;
}

void main(void)

{
 struct MsgPort *SRIRexxPort;
 struct RexxMsg *InRexxMsg;
 LONG Done;
 UBYTE *CmdString;

#ifndef DEBUG
 if (_Backstdout) Close (_Backstdout);
#endif

 if ((RexxSysBase=(struct RxsLib *)OpenLibrary("rexxsyslib.library",33L))==NULL) exit (10L);
 if ((SRIRexxPort=CreateRexxPort(LSE_PORT_NAME))==NULL)
  {
   CloseLibrary (&RexxSysBase->rl_Node);
   exit (10L);
  }

 Done=FALSE;
 NewList (&ErrorList);
 while (!Done)
  {
   (void)WaitPort(SRIRexxPort);
   InRexxMsg=(struct RexxMsg *)GetMsg(SRIRexxPort);
   if (InRexxMsg->rm_Args[0])
    {
     if (CmdString=StripString(InRexxMsg->rm_Args[0]))
      {
#ifdef DEBUG
       printf ("IN: %s\n",CmdString);
#endif
       SetResult (InRexxMsg,ParseCommand(CmdString,&Done));
       DeleteArgstring (CmdString);
      }
    }
   ReplyMsg (&InRexxMsg->rm_Node);
  }

 DeletePort (SRIRexxPort);
 CloseLibrary (&RexxSysBase->rl_Node);

 exit (0L);
}
