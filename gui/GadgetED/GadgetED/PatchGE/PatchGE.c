/*
 *  PatchGE.c version 1.0 - © 1991 Jaba Development
 *
 *  written in Aztec C version 5.0a by Jan van den Baard
 *
 *  Since I have been so stupid as not to leave any room for improvement
 *  in the binary file structure of "GE" files made with GadgetED version 2.0
 *  I had to write a patch program that will upgrade these files to GadgetED
 *  version 2.1 and up..... sorry !
 */
#include <tool.h>
#include "PatchGE.h"
#include <functions.h>

struct OldBin
{
    ULONG               FileType;
    ULONG               NumGads;
    ULONG               ScrDepth;
    BOOL                ReqGads;
    BOOL                WBScreen;
    ULONG               NumTexts;
    USHORT              Colors[32];

    BOOL                skip_zero_planes;
    BOOL                auto_size;
    BOOL                image_copy;

    struct NewWindow    new_window;

    char                window_title[80];
    char                window_label[32];
};

struct NewBin
{
    ULONG               FileType;
    USHORT              Version;
    USHORT              Revision;
    USHORT              NumGads;
    USHORT              ScrDepth;
    BOOL                ReqGads;
    BOOL                WBScreen;
    USHORT              NumTexts;
    USHORT              Colors[32];
    USHORT              FPen;
    USHORT              BPen;
    USHORT              BackFill;
    USHORT              WDBackFill;
    USHORT              LightSide;
    USHORT              DarkSide;
    USHORT              Res[2];

    BOOL                skip_zero_planes;
    BOOL                auto_size;
    BOOL                image_copy;
    BOOL                text_copy;
    BOOL                static_structures;
    BOOL                no_flags;
    BOOL                Res1[2];

    struct NewWindow    new_window;

    char                window_title[80];
    char                window_label[32];
};

struct ToolBase      *ToolBase;
struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;

struct Window        *window = NULL;
struct IntuiMessage  *msg;
struct Gadget        *gadget;
struct RastPort      *rport;
struct FileRequester *freq = NULL;
struct OldBin        *oldbin = NULL;

struct NewBin         newbin;

ULONG                 class, filesize;
USHORT                code, id;

void bail()
{
    if(oldbin)          FreeMem(oldbin,filesize);
    if(freq)            FreeFreq(freq);
    if(window)          CloseWindow(window);
    if(ToolBase)        CloseLibrary(ToolBase);
    exit(0L);
}

void setup()
{
    if(NOT(ToolBase = (struct ToolBase *)
        OpenLibrary("tool.library",TOOL_VERSION)))
        bail();

    IntuitionBase = ToolBase->IntuitionBase;
    GfxBase       = ToolBase->GfxBase;

    if(NOT(freq = AllocFreq()))
        bail();

    if(NOT(window = (struct Window *)OpenWindow(NEWWINDOW)))
        bail();

    rport = window->RPort;
}

void do_patch()
{
    USHORT  i;

    SetAPen(rport,0);
    SetDrMd(rport,JAM1);
    RectFill(rport,212,18,373,63);
    SetAPen(rport,3);

    Move(rport,212,25);
    Text(rport,freq->fr_FileName,strlen(freq->fr_FileName));
    Move(rport,212,34);
    FormatText(rport,"%ld",oldbin->NumGads);
    Move(rport,212,43);
    if(oldbin->ReqGads)
        Text(rport,"Requester",9L);
    else
        Text(rport,"Window",6L);
    Move(rport,212,52);
    FormatText(rport,"%ld",oldbin->NumTexts);
    Move(rport,212,61);
    if(oldbin->WBScreen)
        Text(rport,"Workbench 4 colors",18L);
    else
        FormatText(rport,"Custom %ld colors",(1 << oldbin->ScrDepth));

    newbin.FileType     =   'EG2+';
    newbin.Version      =   2;
    newbin.Revision     =   1;
    newbin.NumGads      =   oldbin->NumGads;
    newbin.ScrDepth     =   oldbin->ScrDepth;
    newbin.ReqGads      =   oldbin->ReqGads;
    newbin.WBScreen     =   oldbin->WBScreen;
    newbin.NumTexts     =   oldbin->NumTexts;

    CopyMem((char *)&oldbin->Colors[0],(char *)&newbin.Colors[0],64L);

    newbin.FPen         =   1;
    newbin.BPen         =   0;
    newbin.BackFill     =   1;
    newbin.WDBackFill   =   0;
    newbin.LightSide    =   2;
    newbin.DarkSide     =   1;

    for(i=0;i<2;i++)    newbin.Res[i] = 0;

    newbin.skip_zero_planes  = oldbin->skip_zero_planes;
    newbin.auto_size         = oldbin->auto_size;
    newbin.image_copy        = oldbin->image_copy;
    newbin.text_copy         = FALSE;
    newbin.static_structures = FALSE;
    newbin.no_flags          = FALSE;

    for(i=0;i<2;i++)    newbin.Res1[i] = 0;

    CopyMem((char *)&oldbin->new_window,(char *)&newbin.new_window,sizeof(struct NewWindow));

    strcpy((char *)&newbin.window_title,(char *)&oldbin->window_title);
    strcpy((char *)&newbin.window_label,(char *)&oldbin->window_label);
}

void inform(char *text)
{
    SetAPen(rport,0);
    SetDrMd(rport,JAM1);
    RectFill(rport,212,18,373,63);
    SetAPen(rport,2);
    Move(rport,294-(strlen(text) << 2),43);
    Text(rport,text,strlen(text));
}

void load_file()
{
    strcpy(freq->fr_HeadLine,"Load a 'GE' file");
    freq->fr_Flags = FR_NoInfo|FR_ReturnOld;

    if(oldbin)
    {
        FreeMem(oldbin,filesize);
        oldbin          = NULL;
    }

    switch(FileRequest(freq))
    {
        case    FREQ_OK:
            inform("LOADING");
                       Seek(freq->fr_Handle,0,OFFSET_END);
            filesize = Seek(freq->fr_Handle,0,OFFSET_BEGINNING);

            if(oldbin = (struct OldBin *)AllocMem(filesize,MEMF_PUBLIC))
            {
                if(Read(freq->fr_Handle,(char *)oldbin,filesize) <= 0)
                {
                    Close(freq->fr_Handle);
                    inform("READ ERROR");
                    break;
                }
                if(oldbin->FileType == 'EG2+')
                {
                    FreeMem(oldbin,filesize);
                    oldbin = NULL;
                    Close(freq->fr_Handle);
                    inform("FILE ALREADY PATCHED");
                    break;
                }
                if(oldbin->FileType != 'EGAD')
                {
                    FreeMem(oldbin,filesize);
                    oldbin = NULL;
                    Close(freq->fr_Handle);
                    inform("UNKNOWN FILE");
                    break;
                }
                do_patch();
                Close(freq->fr_Handle);
            }
            break;

        case    FREQ_CANT_OPEN:
            inform("FILEREQUESTER ERROR"); break;

        case    FREQ_FILE_ERROR:
            inform("CANT OPEN THE FILE"); break;

        case    FREQ_CANCELED:      break;
    }
}

void save_file()
{
    if(NOT oldbin)  return;

    strcpy(freq->fr_HeadLine,"Save 'GE' patch");
    freq->fr_Flags = FR_NoInfo|FR_ReturnNew;

    switch(FileRequest(freq))
    {
     case    FREQ_OK:
        inform("SAVING");
        if(Write(freq->fr_Handle,(char *)&newbin,sizeof(struct NewBin)) < 0)
        {
            Close(freq->fr_Handle);
            inform("WRITE ERROR");
            break;
        }
        if(Write(freq->fr_Handle,(char *)((ULONG)oldbin+(ULONG)sizeof(struct OldBin)),filesize-sizeof(struct OldBin)) < 0)
        {
            Close(freq->fr_Handle);
            inform("WRITE ERROR");
            break;
        }
        Close(freq->fr_Handle);
        do_patch();
        break;

     case    FREQ_CANT_OPEN:
        inform("FILEREQUESTER ERROR"); break;

     case    FREQ_FILE_ERROR:
        inform("CANT OPEN THE FILE"); break;

     case    FREQ_CANCELED:
        break;
    }
}

void main()
{
    setup();

    do
    {   WaitPort(window->UserPort);
        while(msg = (struct IntuiMessage *)GetMsg(window->UserPort))
        {
            class   =   msg->Class;
            code    =   msg->Code;
            gadget  =   (struct Gadget *)msg->IAddress;
            id      =   gadget->GadgetID;
            ReplyMsg((struct Message *)msg);

            switch(id)
            {
                case    LOAD_ID:    load_file();
                                    break;
                case    SAVE_ID:    save_file();
                                    break;
            }
        }
    } while(id != QUIT_ID);

    bail();
}
