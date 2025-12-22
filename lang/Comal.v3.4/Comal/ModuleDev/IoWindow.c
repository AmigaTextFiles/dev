/************************************************************************/
/*																                                      */
/*																                                      */
/*								   AmigaCOMAL Interpreter 				                    */
/*								 Input/output window module                           */
/*									   version 93.01.31  				                        */
/*																                                      */
/*																                                      */
/************************************************************************/

#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <devices/conunit.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/layers.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include "Comal.h"
#include "Comal_protos.h"

extern struct ComalStruc *ComalStruc;

static unsigned char SetCurStr[] = {0x9B,0,0,0,0x3B,0,0,0,0x48,0};
static LONG SetCurStrLen = 9;
static unsigned char CurOffStr[] = {0x9B,0x30,0x20,0x70,0};
static LONG CurOffStrLen = 4;
static unsigned char CurOnStr[] = {0x9B,0x20,0x70,0};
static LONG CurOnStrLen = 3;


struct KeyBuffer
{
  UBYTE NumBytes;     /* Number of bytes in buffer      */
  UBYTE NextByte;     /* Next byte to read              */
  UBYTE Buffer[30];   /* Key buffer                     */
};

struct ConsoleId
{
  struct IOStdReq *OutputMsg;
  struct IOStdReq *InputMsg;
	UBYTE  InputMsgBuf;
	UBYTE  InputSignal;
  struct KeyBuffer KeyBuffer;
  unsigned ConDevOpen:   1;   /* 'console.device' open          */
  unsigned CrtOpen:      1;
  unsigned KbdOpen:      1;
  unsigned CloseReq:     1;   /* Close as soon as possible      */
};

static struct Screen *Screen;
static struct Window *Window;
static struct ConsoleId *ConsoleId;

static struct NewScreen NewScreen =
{
	0,0,640,256,
	4,			/* Screen depth */
	0,1,
	HIRES | SPRITES,
	CUSTOMSCREEN,
	0,
	"Special IO screen",
	0,0
};

static void CloseConsole(void);
static void QueueRead(struct ConsoleId *ConsoleId);
BOOL CrtWrite(ULONG ConId, UBYTE *Data, LONG *NumByte);
static ULONG ReadOneKey(void);

/************************************************************************/
/*                                                                      */
/*   Open and close routines for common IO window                       */
/*                                                                      */
/************************************************************************/

struct Window *MakeIoWindow(void)
{
  struct NewWindow NewWindow;

  if ( Screen = OpenScreen(&NewScreen) )
  {
    NewWindow.LeftEdge = 0;
    NewWindow.TopEdge =12;
    NewWindow.DetailPen = 0;
    NewWindow.BlockPen = 1;
    NewWindow.Title = "Special IO window";
    NewWindow.Flags = WINDOWCLOSE | SMART_REFRESH | ACTIVATE | WINDOWSIZING
                      | WINDOWDRAG | WINDOWDEPTH | NOCAREREFRESH | GIMMEZEROZERO;
    NewWindow.IDCMPFlags = NULL;
    NewWindow.Type = CUSTOMSCREEN;
    NewWindow.Screen = Screen;
    NewWindow.Width = Screen->Width;
    NewWindow.Height = Screen->Height-NewWindow.TopEdge;
    NewWindow.MaxWidth = Screen->Width;
    NewWindow.MaxHeight = Screen->Height;
    NewWindow.FirstGadget = NULL;
    NewWindow.CheckMark = NULL;
    NewWindow.BitMap = NULL;
    NewWindow.MinWidth = 150;
    NewWindow.MinHeight = 75;
    if ( !(Window = OpenWindow(&NewWindow)) )
      CloseScreen(Screen);
  }
  return(Window);
}

void RemoveIoWindow(void)
{
  if ( Window )
  {
		CloseWindow(Window);
    Window = NULL;
  }
  if (Screen )
  {
    CloseScreen(Screen);
    Screen = NULL;
  }
}

/************************************************************************/
/*                                                                      */
/*   Standard console IO routines                                       */
/*                                                                      */
/************************************************************************/

static struct ConsoleId *OpenConsole(void)
{
  struct MsgPort *Port;

  if ( !(ConsoleId = (struct ConsoleId *)calloc(1,sizeof(struct ConsoleId))) )
    return(NULL);
  if ( !MakeIoWindow() )
  {
    free((char *)ConsoleId);
    ConsoleId = NULL;
    return(NULL);
  }

  if ( !(Port = CreatePort(0,0)) )
  {
    CloseConsole();
    return(NULL);
  }
  if ( !(ConsoleId->InputMsg = CreateStdIO(Port)) )
  {
    DeletePort(Port);
    CloseConsole();
    return(NULL);
  }
  ConsoleId->InputSignal = Port->mp_SigBit;
  if ( !(Port = CreatePort(0,0)) )
  {
    CloseConsole();
    return(NULL);
  }
  if ( !(ConsoleId->OutputMsg = CreateStdIO(Port)) )
  {
    DeletePort(Port);
    CloseConsole();
    return(NULL);
  }
  ConsoleId->OutputMsg->io_Data = (APTR)Window;
  ConsoleId->OutputMsg->io_Length = sizeof(struct Window);
  if ( OpenDevice("console.device",0,(struct IORequest *)ConsoleId->OutputMsg,0) )
  {
    CloseConsole();
    return(NULL);
  }
  ConsoleId->ConDevOpen = 1;
  
  ConsoleId->InputMsg->io_Device = ConsoleId->OutputMsg->io_Device;
  ConsoleId->InputMsg->io_Unit = ConsoleId->OutputMsg->io_Unit;
  CrtWrite((ULONG)ConsoleId,CurOffStr,&CurOffStrLen);
  AddSignal(1 << ConsoleId->InputSignal);
  QueueRead(ConsoleId);
	return(ConsoleId);
}

static void CloseConsole(void)
{
	struct MsgPort *Port;
	
	if (ConsoleId->ConDevOpen)
	{
		AbortIO((struct IORequest *)ConsoleId->InputMsg);
		CloseDevice((struct IORequest *)ConsoleId->OutputMsg);
    RemSignal(1 << ConsoleId->InputSignal);
		ConsoleId->ConDevOpen = 0;
	}
	if ( ConsoleId->InputMsg )
	{
		Port = ConsoleId->InputMsg->io_Message.mn_ReplyPort;
		DeleteStdIO(ConsoleId->InputMsg);
		DeletePort(Port);
		ConsoleId->InputMsg = NULL;
	}
	if ( ConsoleId->OutputMsg )
	{
		Port = ConsoleId->OutputMsg->io_Message.mn_ReplyPort;
		DeleteStdIO(ConsoleId->OutputMsg);
		DeletePort(Port);
		ConsoleId->OutputMsg = NULL;
	}

  RemoveIoWindow();

  free((char *)ConsoleId);
  ConsoleId = NULL;
}

ULONG CrtOpen(char *Name,UWORD Mode,short *Status)
{
  if ( ConsoleId == NULL )
    OpenConsole();
  if ( ConsoleId )
  {
    if ( (ComalStruc->Flags & F_TRACEMODE) == 0 )
      WindowToFront(Window);
    ConsoleId->CrtOpen = 1;
  }
  return((ULONG)ConsoleId);
}

void CrtClose(ULONG ConId)
{
  ConsoleId->CrtOpen = 0;
  if ( ConsoleId->CloseReq && !ConsoleId->KbdOpen )
    CloseConsole();
}

ULONG KbdOpen(char *Name,UWORD Mode,short *Status)
{
  if ( ConsoleId == NULL )
    OpenConsole();
  if ( ConsoleId )
  {
    if ( (ComalStruc->Flags & F_TRACEMODE) == 0 )
      (void)ActivateWindow(Window);
    ConsoleId->KbdOpen = 1;
  }
  return((ULONG)ConsoleId);
}

void KbdClose(ULONG ConId)
{
  ConsoleId->KbdOpen = 0;
  if ( ConsoleId->CloseReq && !ConsoleId->CrtOpen )
    CloseConsole();
}

/*--------------------------------------------------------------*/
/*															                                */
/* 										Console IO routines			              */
/*															                                */
/*--------------------------------------------------------------*/

static void QueueRead(struct ConsoleId *ConsoleId)
{
	ConsoleId->InputMsg->io_Data = (APTR)(&ConsoleId->InputMsgBuf);
	ConsoleId->InputMsg->io_Length = 1;
	ConsoleId->InputMsg->io_Command = CMD_READ;
	SendIO((struct IORequest *)ConsoleId->InputMsg);
}

BOOL CrtWrite(ULONG ConId, UBYTE *Data, LONG *NumByte)
{
  if ( *NumByte )
  {
  	ConsoleId->OutputMsg->io_Length = *NumByte;
	  ConsoleId->OutputMsg->io_Data = Data;
  	ConsoleId->OutputMsg->io_Command = CMD_WRITE;
	  DoIO((struct IORequest *)ConsoleId->OutputMsg);
  }
  return(TRUE);
}

BOOL CrtWriteLine(ULONG ConId, UBYTE *Line, LONG *NumByte)
{
  if ( *NumByte )
  {
  	ConsoleId->OutputMsg->io_Length = *NumByte;
	  ConsoleId->OutputMsg->io_Data = Line;
  	ConsoleId->OutputMsg->io_Command = CMD_WRITE;
	  DoIO((struct IORequest *)ConsoleId->OutputMsg);
  }
	ConsoleId->OutputMsg->io_Length = 1;
	ConsoleId->OutputMsg->io_Data = "\n";
	ConsoleId->OutputMsg->io_Command = CMD_WRITE;
	DoIO((struct IORequest *)ConsoleId->OutputMsg);
  return(TRUE);
}

BOOL CrtSetCursor(ULONG ConId, short Row, short Col)
{
  short i;

  Row++;
  Col++;
	for (i = 3; i > 0; i--, Row /= 10)
		SetCurStr[i] = (Row % 10)+'0';
	for (i = 7; i > 4; i--, Col /= 10)
		SetCurStr[i] = (Col % 10)+'0';
  CrtWrite(ConId,SetCurStr,&SetCurStrLen);
  return(TRUE);
}

BOOL CrtGetCursor(ULONG ConId, short *Row, short *Col)
{
	struct ConUnit *ConsoleUnit;

	ConsoleUnit = (struct ConUnit *)(ConsoleId->OutputMsg->io_Unit);
	*Row = ConsoleUnit->cu_YCCP;
	*Col = ConsoleUnit->cu_XCCP;
  return(TRUE);
}

short KbdRead(ULONG Id, UBYTE *Buffer, LONG *NumByte, ULONG BreakMask)
{
  struct KeyBuffer *Key;
  UBYTE CharRead;
  
  Key = &ConsoleId->KeyBuffer;
  CharRead = 0;
  while ( CharRead < *NumByte )
  {
    while ( Key->NumBytes == 0 )
    {
      if ( ReadOneKey() & BreakMask )
      {
        *NumByte = CharRead;  /* Return number of bytes actually read   */
        return(0);
      }
      if ( ComalStruc->BreakFlags )
        ExecBreak();
    }
    Buffer[CharRead++] = Key->Buffer[Key->NextByte++];
    Key->NumBytes--;
  }
  *NumByte = CharRead;        /* Return number of bytes actually read   */
  return(0);
}

short KbdReadLine(ULONG ConId, UBYTE *Line, LONG *MaxBytes)
{
  struct KeyBuffer *Key;
  LONG Number;
  
  CrtWrite(ConId,CurOnStr,&CurOnStrLen);
  Key = &ConsoleId->KeyBuffer;
  Number = 0;
  do
  {
    Key->NumBytes = 0;
    do
    {
      (void)ReadOneKey();
      if ( ComalStruc->BreakFlags )
      {
        CrtWrite(ConId,CurOffStr,&CurOffStrLen);
        ExecBreak();
        CrtWrite(ConId,CurOnStr,&CurOnStrLen);
      }
    } while ( Key->NumBytes == 0 );
    if ( (Key->Buffer[0] == '\b') && Number )
    {
    	ConsoleId->OutputMsg->io_Length = 1;
	    ConsoleId->OutputMsg->io_Data = Key->Buffer;
    	ConsoleId->OutputMsg->io_Command = CMD_WRITE;
	    DoIO((struct IORequest *)ConsoleId->OutputMsg);
      Number--;
    }
    else if ( isprint(Key->Buffer[0]) )
    {
      Line[Number++] = Key->Buffer[0];
    	ConsoleId->OutputMsg->io_Length = 1;
	    ConsoleId->OutputMsg->io_Data = Key->Buffer;
    	ConsoleId->OutputMsg->io_Command = CMD_WRITE;
	    DoIO((struct IORequest *)ConsoleId->OutputMsg);
    }
  } while ( (Key->Buffer[0] != '\r') && Number < *MaxBytes );
  *MaxBytes = Number;       /* Return number of bytes actually read     */
  CrtWrite(ConId,CurOffStr,&CurOffStrLen);
  return(0);
}

short KbdScan(ULONG Id, UBYTE *Buffer, LONG *NumByte)
{
  struct KeyBuffer *Key;
  
  Key = &ConsoleId->KeyBuffer;
  if ( (Key->NumBytes == 0) && CheckIO((struct IORequest *)ConsoleId->InputMsg) )
    (void)ReadOneKey();
  if ( Key->NumBytes )
  {
    *Buffer = Key->Buffer[Key->NextByte++];
    Key->NumBytes--;
    *NumByte = 1;
  }
  else
    *NumByte = 0;
  return(0);
}

static ULONG ReadOneKey(void)
{
  struct KeyBuffer *Key;
	ULONG SignalMask,RetMask;

	SignalMask = (1 << ConsoleId->InputSignal);
  Key = &ConsoleId->KeyBuffer;
  Key->NextByte = 0;
  if ( (RetMask = ComalWait(SignalMask)) & SignalMask )
  {
    GetMsg(ConsoleId->InputMsg->io_Message.mn_ReplyPort);
    if ( ConsoleId->InputMsg->io_Actual && (Key->Buffer[Key->NumBytes++] = ConsoleId->InputMsgBuf) == 0x9B )
    {
      do
      {
        QueueRead(ConsoleId);
        RetMask |= ComalWait(SignalMask);
        GetMsg(ConsoleId->InputMsg->io_Message.mn_ReplyPort);
      } while ((Key->Buffer[Key->NumBytes++] = ConsoleId->InputMsgBuf) < 0x40);
    }
    QueueRead(ConsoleId);
  }
  return(RetMask);
}

struct Window *IoWindow(void)
{
  return(Window);
}

struct IoDevice CrtDevice =
{
  NULL,             /* Next device in list        */
  "ds:",            /* Name of device             */
  CRT_DEVICE,       /* Screen type device         */
  0,                /* Reserved                   */
  &CrtOpen,         /* Open routine               */
  &CrtClose,        /* Close routine              */
  NULL,             /* No read block              */
  &CrtWrite,        /* Write block                */
  NULL,             /* No read line               */
  &CrtWriteLine,    /* Write line                 */
  NULL,             /* No scan routine            */
  &CrtGetCursor,    /* Get cursor                 */
  &CrtSetCursor,    /* Set cursor                 */
  NULL              /* No IO error function       */
};

struct IoDevice KbdDevice =
{
  NULL,             /* Next device in list        */
  "kb:",            /* Device name                */
  KBD_DEVICE,       /* Sequential device          */
  0,                /* Reserved                   */
  &KbdOpen,         /* Open routine               */
  &KbdClose,        /* Close routine              */
  &KbdRead,         /* Read block                 */
  &CrtWrite,        /* Write INPUT guide text     */
  &KbdReadLine,     /* Read line                  */
  NULL,             /* No write line              */
  &KbdScan,         /* Scan keyboard              */
  &CrtGetCursor,    /* Get cursor                 */
  &CrtSetCursor,    /* Set cursor                 */
  NULL              /* No IO error function       */
};

short ModuleInit(void)
{
	if ( !(IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",0)) )
    return(150);
  else
  {
    AddComalDevice(&KbdDevice);
    AddComalDevice(&CrtDevice);
    return(0);
  }
}

void signal(short Signal)
{
  switch ( Signal )
  {
    case SIG_CLEAR:
      if ( ConsoleId ) 
        CloseConsole();
      break;
    case SIG_CLOSE:
    case SIG_DISCARD: 
      if ( ConsoleId ) 
      {
        RemComalDevice(&KbdDevice);
        RemComalDevice(&CrtDevice);
        CloseConsole();
      }
      if( IntuitionBase )
        CloseLibrary((struct Library *)IntuitionBase);
      break;
    default:
      break;
  }
}
