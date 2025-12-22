#include <libraries/dos.h>
#include <intuition/intuition.h>
#include <exec/memory.h>

#define loadname names[0]
#define savename names[1]
#define variablename names[2]
#define variablelenname names[3]
#define BLKSTART (('B'<<24)+('L'<<16)+('O'<<8)+'K')

/* ------------- Requester Data -------------------- */

struct IntuitionBase     *IntuitionBase=NULL;
struct GfxBase           *GfxBase=NULL;
struct RastPort          *rp;
struct Window            *wn=NULL;
struct IntuiMessage      *msg;
struct TextAttr ta={"topaz.font",8,FS_NORMAL,NULL};
char names[4][33]={"","","",""},undo[33];
ULONG class;

struct IntuiText booltext[4]=
{
   {1,0,JAM1,8,1,&ta,"Chip"  ,NULL},
   {1,0,JAM1,8,1,&ta,"Fast"  ,NULL},
   {1,0,JAM1,8,1,&ta,"Save"  ,NULL},
   {1,0,JAM1,0,1,&ta,"Cancel",NULL}
};
struct IntuiText stringtext[3]=
{
   {1,0,JAM1,16,-11,&ta,"Data File"    ,NULL},
   {1,0,JAM1, 8,-11,&ta,"Object File"  ,NULL},
   {1,0,JAM1, 0,-11,&ta,"Variable Name",NULL}
};
struct IntuiText errortext[2]=
{
   {1,0,JAM1,0,0,&ta,"Error,check input",NULL},
   {1,0,JAM1,0,0,&ta,"                 ",NULL},
};
struct StringInfo loadstr= {loadname,    undo,0,32,0,0,0,0,0,0,0};
struct StringInfo savestr= {savename,    undo,0,32,0,0,0,0,0,0,0};
struct StringInfo varstr = {variablename,undo,0,32,0,0,0,0,0,0,0};

USHORT booledges[]=
   {-1,-1, 49,-1, 49,9,-1,9,-1,-1};
USHORT stringedges[]=
   {-2,-2,105,-2,105,8,-2,8,-2,-2};

struct Border boolborder  ={0,0,1,0,JAM1,5,booledges  ,NULL};
struct Border stringborder={0,0,1,0,JAM1,5,stringedges,NULL};

struct Gadget chipgad=
   {NULL,10,15,48,9,GADGHCOMP,RELVERIFY|TOGGLESELECT,
    BOOLGADGET,(APTR)&boolborder,NULL,&booltext[0],NULL,NULL,0,NULL};
struct Gadget fastgad=
   {&chipgad,10,30,48,9,GADGHCOMP,RELVERIFY|TOGGLESELECT,
    BOOLGADGET,(APTR)&boolborder,NULL,&booltext[1],NULL,NULL,1,NULL};
struct Gadget savegad=
   {&fastgad,10,60,48,9,GADGHCOMP|GADGDISABLED,RELVERIFY,
    BOOLGADGET,(APTR)&boolborder,NULL,&booltext[2],NULL,NULL,2,NULL};
struct Gadget cancelgad=
   {&savegad,10,75,48,9,GADGHCOMP,RELVERIFY,
    BOOLGADGET,(APTR)&boolborder,NULL,&booltext[3],NULL,NULL,3,NULL};

struct Gadget loadgad=
   {&cancelgad,76,25,104,10,GADGHCOMP,RELVERIFY|STRINGCENTER,STRGADGET,
    (APTR)&stringborder,NULL,&stringtext[0],NULL,(APTR)&loadstr,4,NULL};
struct Gadget objectgad=
   {&loadgad,  76,50,104,10,GADGHCOMP,RELVERIFY|STRINGCENTER,STRGADGET,
    (APTR)&stringborder,NULL,&stringtext[1],NULL,(APTR)&savestr,5,NULL};
struct Gadget variablegad=
   {&objectgad,76,75,104,10,GADGHCOMP,RELVERIFY|STRINGCENTER,STRGADGET,
    (APTR)&stringborder,NULL,&stringtext[2],NULL,(APTR)&varstr,6,NULL};

struct NewWindow nw=
{
 60,40, 200,100, 0,1,
 GADGETUP|CLOSEWINDOW,
 WINDOWDEPTH|WINDOWCLOSE|WINDOWDRAG|SIMPLE_REFRESH|ACTIVATE|RMBTRAP,
 &variablegad,
 NULL,
 "Data to Object",
 NULL, NULL, NULL,NULL,NULL,NULL,
 WBENCHSCREEN,
};

/* ------------- Program Data -------------------- */

BOOL fast=FALSE,chip=FALSE;
BPTR flock,in,out;
short i;

struct DataToWrite
{
 char  *start;        /* pointer to the data */
 ULONG length;        /* length of the data block to write */
};

struct ObjectFile
{
 ULONG Hunk_Unit;     /* type of file, this a object file (0x3e7) */
 ULONG Namelen;       /* length of the name of this hunk (0 = no name) */
 ULONG Hunk_Data;     /* start of a data hunk (0x3ea) */
 ULONG HunkLen;
 /* length in long words */

 ULONG datastart1;    /* 'BLOK' */
 struct DataToWrite data;  /* data info */

 ULONG RealLength;    /* used to store the real length of the data-file */
 ULONG Hunk_Ext;      /* start of external definitions (0x3ef) */
 ULONG Ext_Def1;      /* type of definition (01 = external definition) */

 ULONG datastart2;    /* 'BLOK' */
 struct DataToWrite varname;  /* name of the data hunk */

 ULONG Value1;        /* offset in data hunk */
 ULONG Ext_Def2;      /* same for the length of the data hunk */

 ULONG datastart3;
 struct DataToWrite varlenname;

 ULONG Value2;
 ULONG Hunk_Ext_End;  /* end of external definitions = null */
 ULONG Hunk_End;      /* =0x3f2 */
}object=
{
 0x3e7,
 NULL,
 0x3ea,
 NULL,
 BLKSTART,
 {NULL,NULL},
 NULL,
 0x3ef,
 0x01000000,
 BLKSTART,
 {variablename,NULL},
 NULL,
 0x01000000,
 BLKSTART,
 {variablelenname,NULL},
 NULL,
 NULL,
 0x3f2
};

void main(),get_parms(),refreshwindow(),quit(),set_defaults();
BOOL writeobj();

/*------------------------ Main program ---------------------------*/
void main(argc,argv)
short argc;
char *argv[];
{
 for(i=1;i<4 && i<argc && *argv[i]!='-';i++) /* get names for files and */
  strcpy(names[i-1],argv[i]);                /* variables */

 if(argc && *argv[i]=='-')                   /* check for options */
  if(!stricmp(argv[i],"-f"))                 /* -f = fast-mem */
  {
   fastgad.Flags|=SELECTED;
   fast=TRUE;
  }
  else if(!stricmp(argv[i],"-c"))            /* -c = chip-mem */
  {
   chipgad.Flags|=SELECTED;
   chip=TRUE;
  }
 if(!(IntuitionBase=(struct IntuitionBase*)
   OpenLibrary("intuition.library",0L))) exit(20);
 if(!(GfxBase=(struct GfxBase*)
   OpenLibrary("graphics.library",0L))) quit(20);

 set_defaults();

 if(i!=4) get_parms(NULL); /* if parameters are missing,create a requester */

 while(!writeobj())        /* pop up the requester until we did write the */
  get_parms(1);            /* object file to disk */

 quit(0);
}

/*------------------ Get parameters from a requester ------------------*/
void get_parms(error)
short error;
{
 if(!wn)
  if(!(wn=(struct Window *) OpenWindow(&nw))) quit(20);

 /* if the requester was created by an error, display message */
 if(error) PrintIText(wn->RPort,&errortext[0],28,90);
 for(;;)
 {
  /* enable SAVE gadget if all data have been entered */
  if(*loadname && *variablename && *savename &&
     savegad.Flags & GADGDISABLED)
  {
   OnGadget(&savegad,wn,NULL);
   refreshwindow();
  }
  else /* disable SAVE gadget */
  if((!*loadname || !*variablename || !*savename) &&
     !(savegad.Flags & GADGDISABLED))
  {
   OffGadget(&savegad,wn,NULL);
   refreshwindow();
  }
  WaitPort(wn->UserPort);
  if(msg=(struct IntuiMessage*)GetMsg(wn->UserPort))
  {
   class=msg->Class;
   ReplyMsg(msg);
   switch(class)
   {
    case CLOSEWINDOW:
     quit(20);
    case GADGETUP:
     switch (((struct Gadget*)msg->IAddress)->GadgetID)
     {
      case 0:         /* CHIP */
       chip^=TRUE;    /* toggle */
       fastgad.Flags&=~SELECTED;
       fast=FALSE;
       refreshwindow();
       break;
      case 1:         /* FAST */
       fast^=TRUE;    /* toggle */
       chipgad.Flags&=~SELECTED;
       chip=FALSE;
       refreshwindow();
       break;
      case 2:         /* SAVE */
       return;
      case 3:         /* CANCEL */
       quit(20);
      case 4:         /* DATAFILE */
       set_defaults();
       refreshwindow();
     }
   }
   if(error)
   {
    PrintIText(wn->RPort,&errortext[1],28,90);
    error=NULL;
   }
  }
 }
}

/*------------------ Refresh Window and Gadgets ------------------*/
void refreshwindow()
{
 SetRast(wn->RPort,0); /* clear window */
 /* refresh gadgets; if anyone knows why this works better than */
 /* RefreshGadget(), please tell me. */
 RefreshWindowFrame(wn);
}

/*---------------------- Clean up and Exit ----------------------*/
void quit(errnum)
short errnum;
{
 if (wn)            CloseWindow(wn);
 if (IntuitionBase) CloseLibrary(IntuitionBase);
 if (GfxBase)       CloseLibrary(GfxBase);
 exit(errnum);
}

/*---------------------- Write Object File ----------------------*/
BOOL writeobj()
{
 struct FileInfoBlock *fib;
 BOOL success=FALSE;
 ULONG *pointer;

 strcpy(variablelenname,variablename);
 strcat(variablelenname,"len");
 object.varname.length    =((strlen(variablename)+3) >> 2) <<2;
 object.Ext_Def1         |=((strlen(variablename)+3) >> 2);
 object.varlenname.length =((strlen(variablelenname)+3) >> 2) <<2;
 object.Ext_Def2         |=((strlen(variablelenname)+3) >> 2);
 object.Hunk_Data |= (fast << 31) | (chip << 30);

 if(flock=Lock(loadname,ACCESS_READ)) /* data file */
 {
  if(fib=(struct FileInfoBlock*)
     AllocMem(sizeof(struct FileInfoBlock),MEMF_PUBLIC))
  {
   if(Examine(flock,fib))             /* get info; we need the size */
   {
    if(fib->fib_DirEntryType<0)       /* is it a file ? */
    {
     object.HunkLen = ((fib->fib_Size+3) >> 2)+1;
     object.data.length = ((fib->fib_Size+3) >> 2) << 2;
     object.RealLength = fib->fib_Size;
     object.Value2 = ((fib->fib_Size+3) >> 2) << 2;

     if(in=Open(loadname,MODE_OLDFILE)) /* yes, open */
     {
      if(object.data.start= (char*) AllocMem(fib->fib_Size,
                                             MEMF_CLEAR|MEMF_PUBLIC))
      {
       if(out=Open(savename,MODE_NEWFILE)) /* open object file */
       {
        if(Read(in,object.data.start,fib->fib_Size)==fib->fib_Size)
        {
         for (pointer=(ULONG*)&object;pointer <= &object.Hunk_End;pointer++)
         {
          if(*pointer!=BLKSTART)
          {
           if(!Write(out,pointer,sizeof(ULONG))) break;
          }
          else if(!Write(out,*(++pointer),*(++pointer))) break;
         }
         Close(out);
         success=TRUE;
        }
       }     /* if out */
       FreeMem(object.data.start,fib->fib_Size);
      }     /* if buffer */
      Close(in);
     }     /* if in */
    }     /* if DirEntryType */
   }     /* if Info */
   FreeMem(fib,sizeof(struct FileInfoBlock));
  }     /* if fib */
  UnLock(flock);
 }     /* if flock */
 return(success);
}

/*------------------------- Set default names ---------------------*/
void set_defaults()                           /* fill name requesters with */
{                                             /* default names */
 short strstart,strend;

 if(*loadname)                                /* we need the data filename */
 {
  /* search and replace filename extension */
  for(strend=strlen(loadname)-1;strend>-1;strend--)
   if(loadname[strend]=='.') break;

  if(strend==-1) strend=strlen(loadname);

  if(!*savename)
  {
   strncpy(savename,loadname,strend);
   savename[strend]='\0';
   strcat(savename,".o");                   /* new extension is '.o' */
  }
  if(!*variablename)
  {
   /* default variablename is */
   /* '_'+filename without the path and w/o the file extension */
   for(strstart=strlen(loadname)-1;strstart>-1;strstart--)
   if(loadname[strstart]=='/' || loadname[strstart]==':') break;
   strstart++;
   if(strend < strstart) strstart=0;
   strcpy(variablename,"_");
   strncat(variablename,&loadname[strstart],strend-strstart);
   /*variablename[strend-strstart+1]='\0';*/
  }
 }
}
