/*
 *   Alert 1.10 - A program for analyzing alert numbers
 *   Written by Stefan Zeiger in 12/1991 and 1/1992
 *   ©1991/1992 by ! Wizard Works ! - FREEWARE
 *   Information from : - "exec/alerts.h" release 2.04 revision 36.18
 *                      - ARP library include file "arpbase.h"
 *                      - "Amiga C Manual 2.0" by Anders Bjerin
 *                      - many alerts with various alert numbers (produced by
 *                        my own programs :-)
 *
 *   30.12.1991  Created 1.00
 *   31.12.1991  Updated 1.01
 *   09.01.1992  Updated 1.10 with ARP alert numbers
 */

#define ARPALERTS

#include <exec/types.h>
#include <exec/alerts.h>
#ifdef ARPALERTS
#include <libraries/arpbase.h>
#endif

struct Alert {ULONG al_code; UBYTE *al_name; UBYTE *al_text; };

struct Alert AlertCode[]=  /* GENERAL PURPOSE ALERT CODES */
{
  { AG_ProcCreate,"AG_ProcCreate : Process creation failed",NULL },
  { AG_CloseDev,"AG_CloseDev : Device closing error or a mismatched close",NULL },
  { AG_CloseLib,"AG_CloseLib : Usually too many closes",NULL },
  { AG_BadParm,"AG_BadParm",NULL },
  { AG_NoSignal,"AG_NoSignal",NULL },
  { AG_IOError,"AG_IOError",NULL },
  { AG_OpenRes,"AG_OpenRes",NULL },
  { AG_OpenDev,"AG_OpenDev",NULL },
  { AG_OpenLib,"AG_OpenLib",NULL },
  { AG_MakeLib,"AG_MakeLib",NULL },
  { AG_NoMemory,"AG_NoMemory",NULL },
  { NULL,NULL,NULL }
};

struct Alert AlertObject[]=  /* ALERT OBJECTS */
{
  { AO_Unknown,"AO_Unknown","Unknown alert object" },
  { AO_GadTools,"AO_GadTools","GadTools.library" },
  { AO_DiskCopy,"AO_DiskCopy","DiskCopy" },
  { AO_Workbench,"AO_Workbench","Workbench" },
  { AO_BootStrap,"AO_BootStrap","Bootstrap" },
  { AO_MiscRsrc,"AO_MiscRsrc","Misc.resource" },
  { AO_DiskRsrc,"AO_DiskRsrc","Disk.resource" },
  { AO_CIARsrc,"AO_CIARsrc","CIA.resource" },
  { AO_TimerDev,"AO_TimerDev","Timer.device" },
  { AO_TrackDiskDev,"AO_TrackDiskDev","Trackdisk.device" },
  { AO_KeyboardDev,"AO_KeyboardDev","Keyboard.device" },
  { AO_GamePortDev,"AO_GamePortDev","Gameport.device" },
  { AO_ConsoleDev,"AO_ConsoleDev","Console.device" },
  { AO_AudioDev,"AO_AudioDev","Audio.device" },
  { AO_UtilityLib,"AO_UtilityLib","Utility.library" },
  { AO_DiskfontLib,"AO_DiskfontLib","Diskfont.library" },
  { AO_ExpansionLib,"AO_ExpansionLib","Expansion.library" },
  { AO_IconLib,"AO_IconLib","Icon.library" },
  { AO_RAMLib,"AO_RAMLib","Ram.library" },
  { AO_DOSLib,"AO_DOSLib","Dos.library" },
  { AO_MathLib,"AO_MathLib","Math.library" },
  { AO_Intuition,"AO_Intuition","Intuition.library" },
  { AO_LayersLib,"AO_LayersLib","Layers.library" },
  { AO_GraphicsLib,"AO_GraphicsLib","Graphics.library" },
  { AO_ExecLib,"AO_ExecLib","Exec.library" },
#ifdef ARPALERTS
  { AO_ArpLib,"AO_ArpLib","ARP.library" },
#endif
  NULL
};

struct Alert SpecAlert[]=  /* SPECIFIC ALERTS */
{
  { AN_ExecLib,"AN_ExecLib","EXEC.LIBRARY" },
  { AN_ExcptVect,"AN_ExcptVect","EXEC.LIBRARY : 68000 exception vector checksum (obs.)" },
  { AN_BaseChkSum,"AN_BaseChkSum","EXEC.LIBRARY : Execbase checksum (obs.)" },
  { AN_LibChkSum,"AN_LibChkSum","EXEC.LIBRARY : Library checksum failure" },
  { AN_MemCorrupt,"AN_MemCorrupt","EXEC.LIBRARY : Corrupt memory list detected in FreeMem" },
  { AN_IntrMem,"AN_IntrMem","EXEC.LIBRARY : No memory for interrupt servers" },
  { AN_InitAPtr,"AN_InitAPtr","EXEC.LIBRARY : InitStruct() of an APTR source (obs.)" },
  { AN_SemCorrupt,"AN_SemCorrupt","EXEC.LIBRARY : A semaphore is in an illegal state at ReleaseSempahore()" },
  { AN_FreeTwice,"AN_FreeTwice","EXEC.LIBRARY : Freeing memory already freed" },
  { AN_BogusExcpt,"AN_BogusExcpt","EXEC.LIBRARY : illegal 68k exception taken (obs.)" },
  { AN_IOUsedTwice,"AN_IOUsedTwice","EXEC.LIBRARY : Attempt to reuse active IORequest" },
  { AN_MemoryInsane,"AN_MemoryInsane","EXEC.LIBRARY : Sanity check on memory list failed during AvailMem(MEMF_LARGEST)" },
  { AN_IOAfterClose,"AN_IOAfterClose","EXEC.LIBRARY : IO attempted on closed IORequest" },
  { AN_StackProbe,"AN_StackProbe","EXEC.LIBRARY : Stack appears to extend out of range" },
  { AN_BadFreeAddr,"AN_BadFreeAddr","EXEC.LIBRARY : Memory header not located. [ Usually an invalid address passed to FreeMem() ]" },
  { AN_GraphicsLib,"AN_GraphicsLib","GRAPHICS.LIBRARY" },
  { AN_GfxNoMem,"AN_GfxNoMem","GRAPHICS.LIBRARY : graphics out of memory" },
  { AN_GfxNoMemMspc,"AN_GfxNoMemMspc","GRAPHICS.LIBRARY : MonitorSpec alloc, no memory" },
  { AN_LongFrame,"AN_LongFrame","GRAPHICS.LIBRARY : long frame, no memory" },
  { AN_ShortFrame,"AN_ShortFrame","GRAPHICS.LIBRARY : short frame, no memory" },
  { AN_TextTmpRas,"AN_TextTmpRas","GRAPHICS.LIBRARY : text, no memory for TmpRas" },
  { AN_BltBitMap,"AN_BltBitMap","GRAPHICS.LIBRARY : BltBitMap, no memory" },
  { AN_RegionMemory,"AN_RegionMemory","GRAPHICS.LIBRARY : regions, memory not available" },
  { AN_MakeVPort,"AN_MakeVPort","GRAPHICS.LIBRARY : MakeVPort, no memory" },
  { AN_GfxNewError,"AN_GfxNewError","GRAPHICS.LIBRARY" },
  { AN_GfxFreeError,"AN_GfxFreeError","GRAPHICS.LIBRARY" },
  { AN_GfxNoLCM,"AN_GfxNoLCM","GRAPHICS.LIBRARY : emergency memory not available" },
  { AN_ObsoleteFont,"AN_ObsoleteFont","GRAPHICS.LIBRARY : unsupported font description used" },
  { AN_LayersLib,"AN_LayersLib","LAYERS.LIBRARY" },
  { AN_LayersNoMem,"AN_LayersNoMem","LAYERS.LIBRARY : layers out of memory" },
  { AN_Intuition,"AN_Intuition","INTUITION.LIBRARY" },
  { AN_GadgetType,"AN_GadgetType","INTUITION.LIBRARY : unknown gadget type" },
  { AN_BadGadget,"AN_BadGadget","INTUITION.LIBRARY : Recovery form of AN_GadgetType" },
  { AN_CreatePort,"AN_CreatePort","INTUITION.LIBRARY : create port, no memory" },
  { AN_ItemAlloc,"AN_ItemAlloc","INTUITION.LIBRARY : item plane alloc, no memory" },
  { AN_SubAlloc,"AN_SubAlloc","INTUITION.LIBRARY : sub alloc, no memory" },
  { AN_PlaneAlloc,"AN_PlaneAlloc","INTUITION.LIBRARY : plane alloc, no memory" },
  { AN_ItemBoxTop,"AN_ItemBoxTop","INTUITION.LIBRARY : item box top < RelZero" },
  { AN_OpenScreen,"AN_OpenScreen","INTUITION.LIBRARY : open screen, no memory" },
  { AN_OpenScrnRast,"AN_OpenScrnRast","INTUITION.LIBRARY : open screen, raster alloc, no memory" },
  { AN_SysScrnType,"AN_SysScrnType","INTUITION.LIBRARY : open sys screen, unknown type" },
  { AN_AddSWGadget,"AN_AddSWGadget","INTUITION.LIBRARY : add SW gadgets, no memory" },
  { AN_OpenWindow,"AN_OpenWindow","INTUITION.LIBRARY : open window, no memory" },
  { AN_BadState,"AN_BadState","INTUITION.LIBRARY : Bad State Return entering Intuition" },
  { AN_BadMessage,"AN_BadMessage","INTUITION.LIBRARY : Bad Message received by IDCMP" },
  { AN_WeirdEcho,"AN_WeirdEcho","INTUITION.LIBRARY : Weird echo causing incomprehension" },
  { AN_NoConsole,"AN_NoConsole","INTUITION.LIBRARY : couldn't open the Console Device" },
  { AN_MathLib,"AN_MathLib","MATH.LIBRARY" },
  { AN_DOSLib,"AN_DOSLib","DOS.LIBRARY" },
  { AN_StartMem,"AN_StartMem","DOS.LIBRARY : no memory at startup" },
  { AN_EndTask,"AN_EndTask","DOS.LIBRARY : EndTask didn't" },
  { AN_QPktFail,"AN_QPktFail","DOS.LIBRARY : Qpkt failure" },
  { AN_AsyncPkt,"AN_AsyncPkt","DOS.LIBRARY : Unexpected packet received" },
  { AN_FreeVec,"AN_FreeVec","DOS.LIBRARY : Freevec failed" },
  { AN_DiskBlkSeq,"AN_DiskBlkSeq","DOS.LIBRARY : Disk block sequence error" },
  { AN_BitMap,"AN_BitMap","DOS.LIBRARY : Bitmap corrupt" },
  { AN_KeyFree,"AN_KeyFree","DOS.LIBRARY : Key already free" },
  { AN_BadChkSum,"AN_BadChkSum","DOS.LIBRARY : Invalid checksum" },
  { AN_DiskError,"AN_DiskError","DOS.LIBRARY : Disk Error" },
  { AN_KeyRange,"AN_KeyRange","DOS.LIBRARY : Key out of range" },
  { AN_BadOverlay,"AN_BadOverlay","DOS.LIBRARY : Bad overlay" },
  { AN_BadInitFunc,"AN_BadInitFunc","DOS.LIBRARY : Invalid init packet for cli/shell" },
  { AN_FileReclosed,"AN_FileReclosed","DOS.LIBRARY : A filehandle was closed more than once" },
  { AN_RAMLib,"AN_RAMLib","RAMLIB.LIBRARY" },
  { AN_BadSegList,"AN_BadSegList","RAMLIB.LIBRARY : no overlays in library seglists" },
  { AN_IconLib,"AN_IconLib","ICON.LIBRARY" },
  { AN_ExpansionLib,"AN_ExpansionLib","EXPANSION.LIBRARY" },
  { AN_BadExpansionFree,"AN_BadExpansionFree","EXPANSION.LIBRARY : freeed free region" },
  { AN_DiskfontLib,"AN_DiskfontLib","DISKFONT.LIBRARY" },
  { AN_AudioDev,"AN_AudioDev","AUDIO.DEVICE" },
  { AN_ConsoleDev,"AN_ConsoleDev","CONSOLE.DEVICE" },
  { AN_NoWindow,"AN_NoWindow","CONSOLE.DEVICE : Console can't open initial window" },
  { AN_GamePortDev,"AN_GamePortDev","GAMEPORT.DEVICE" },
  { AN_KeyboardDev,"AN_KeyboardDev","KEYBOARD.DEVICE" },
  { AN_TrackDiskDev,"AN_TrackDiskDev","TRACKDISK.DEVICE" },
  { AN_TDCalibSeek,"AN_TDCalibSeek","TRACKDISK.DEVICE : calibrate: seek error" },
  { AN_TDDelay,"AN_TDDelay","TRACKDISK.DEVICE : delay: error on timer wait" },
  { AN_TimerDev,"AN_TimerDev","TIMER.DEVICE" },
  { AN_TMBadReq,"AN_TMBadReq","TIMER.DEVICE : bad request" },
  { AN_TMBadSupply,"AN_TMBadSupply","TIMER.DEVICE : power supply -- no 50/60Hz ticks" },
  { AN_CIARsrc,"AN_CIARsrc","CIA.RESOURCE" },
  { AN_DiskRsrc,"AN_DiskRsrc","DISK.RESOURCE" },
  { AN_DRHasDisk,"AN_DRHasDisk","DISK.RESOURCE : get unit: already has disk" },
  { AN_DRIntNoAct,"AN_DRIntNoAct","DISK.RESOURCE : interrupt: no active unit" },
  { AN_MiscRsrc,"AN_MiscRsrc","MISC.RESOURCE" },
  { AN_BootStrap,"AN_BootStrap","BOOTSTRAP" },
  { AN_BootError,"AN_BootError","BOOTSTRAP : boot code returned an error" },
  { AN_Workbench,"AN_Workbench","WORKBENCH" },
  { AN_NoFonts,"AN_NoFonts","WORKBENCH" },
  { AN_WBBadStartupMsg1,"AN_WBBadStartupMsg1","WORKBENCH" },
  { AN_WBBadStartupMsg2,"AN_WBBadStartupMsg2","WORKBENCH" },
  { AN_WBBadIOMsg,"AN_WBBadIOMsg","WORKBENCH" },
  { AN_WBInitPotionAllocDrawer,"AN_WBInitPotionAllocDrawer","WORKBENCH" },
  { AN_WBCreateWBMenusCreateMenus1,"AN_WBCreateWBMenusCreateMenus1","WORKBENCH" },
  { AN_WBCreateWBMenusCreateMenus2,"AN_WBCreateWBMenusCreateMenus2","WORKBENCH" },
  { AN_WBLayoutWBMenusLayoutMenus,"AN_WBLayoutWBMenusLayoutMenus","WORKBENCH" },
  { AN_WBAddToolMenuItem,"AN_WBAddToolMenuItem","WORKBENCH" },
  { AN_WBReLayoutToolMenu,"AN_WBReLayoutToolMenu","WORKBENCH" },
  { AN_WBinitTimer,"AN_WBinitTimer","WORKBENCH" },
  { AN_WBInitLayerDemon,"AN_WBInitLayerDemon","WORKBENCH" },
  { AN_WBinitWbGels,"AN_WBinitWbGels","WORKBENCH" },
  { AN_WBInitScreenAndWindows1,"AN_WBInitScreenAndWindows1","WORKBENCH" },
  { AN_WBInitScreenAndWindows2,"AN_WBInitScreenAndWindows2","WORKBENCH" },
  { AN_WBInitScreenAndWindows3,"AN_WBInitScreenAndWindows3","WORKBENCH" },
  { AN_WBMAlloc,"AN_WBMAlloc","WORKBENCH" },
  { AN_DiskCopy,"AN_DiskCopy","DISKCOPY" },
  { AN_GadTools,"AN_GadTools","GADTOOLS.LIBRARY" },
  { AN_UtilityLib,"AN_UtilityLib","UTILITY.LIBRARY" },
  { AN_Unknown,"AN_Unknown","Unknown alert (Produced by an application ?)" },
  { 0x8000000B,"CPU ERROR","Opcode 1111 emulation (Instruction word F000-FFFF)" },
  { 0x8000000A,"CPU ERROR","Opcode 1010 emulation (Instruction word A000-AFFF)" },
  { 0x80000009,"CPU ERROR","Trace" },
  { 0x80000008,"CPU ERROR","Privilege violation" },
  { 0x80000007,"CPU ERROR","TRAPV instruction" },
  { 0x80000006,"CPU ERROR","CHK instruction" },
  { 0x80000005,"CPU ERROR","Division by zero" },
  { 0x80000004,"CPU ERROR","Illegal instruction" },
  { 0x80000003,"CPU ERROR","Address error (Word access on odd byte boundary)" },
  { 0x80000002,"CPU ERROR","Bus Error (Hardware error)" },
#ifdef ARPALERTS
  { AN_ArpLib,"AN_ArpLib","ARP.LIBRARY" },
  { AN_ArpNoMem,"AN_ArpNoMem","ARP.LIBRARY : No more memory" },
  { AN_ArpInputMem,"AN_ArpInputMem","ARP.LIBRARY : No memory for input buffer" },
  { AN_ArpNoMakeEnv,"AN_ArpNoMakeEnv","ARP.LIBRARY : No memory to make EnvLib" },
  { AN_ArpNoDOS,"AN_ArpNoDOS","ARP.LIBRARY : Can't open dos.library" },
  { AN_ArpNoGfx,"AN_ArpNoGfx","ARP.LIBRARY : Can't open graphics.library" },
  { AN_ArpNoIntuit,"AN_ArpNoIntuit","ARP.LIBRARY : Can't open intuition" },
  { AN_BadPackBlues,"AN_BadPackBlues","ARP.LIBRARY : Bad packet returned to SendPacket()" },
  { AN_Zombie,"AN_Zombie","ARP.LIBRARY : Zombie roaming around system" },
  { AN_ArpScattered,"AN_ArpScattered","ARP.LIBRARY : Scatter loading not allowed for arp" },
#endif
  NULL
};

char *versionstring="$VER: Alert 1.10 (9.1.1992)";


void main(int argc,char **argv)
{
  ULONG alnum=0;
  USHORT i;
  BOOL printed;

  if(argc<2)
  {
    puts("Argument missing.");
    exit(20L);
  }
  if(argc>2)
  {
    puts("Only one argument allowed.");
    exit(20L);
  }
  if(!strcmp(argv[1],"?"))
  {
    printf("\033[32mAlert 1.10 by Stefan Zeiger - © 1991/1992 by ! Wizard Works !\033[31m\nSyntax: Alert <32-bit hex number>\n");
    exit(0L);
  }
  if((stch_l(argv[1],&alnum))!=8)
  {
    puts("The argument must be a 32-bit hex number.");
    exit(20L);
  }

  printf("\033[32mAlert 1.10 by Stefan Zeiger - © 1991/1992 by ! Wizard Works !\033[31m\n\033[33mALERT NUMBER   :\033[31m 0x%s\n\033[33mALERT TYPE     :\033[31m ",argv[1]);
  if(alnum & AT_DeadEnd)
    puts("AT_DeadEnd : Dead end error");
    else puts("AT_Recovery : Recoverable error");

  printf("\033[33mALERT CODE     :\033[31m ");
  printed=FALSE;
  for(i=0;(AlertCode[i].al_name)!=NULL;i++)
  {
    if((AlertCode[i].al_code)==((alnum)&(0x00FF0000)))
    {
      printf("%s\n",AlertCode[i].al_name);
      printed=TRUE;
    }
  }
  if(!printed) printf("<UNKNOWN>\n");

  printf("\033[33mALERT OBJECT   :\033[31m ");
  printed=FALSE;
  for(i=0;(AlertObject[i].al_name)!=NULL;i++)
  {
    if((AlertObject[i].al_code)==((alnum)&(0x0000FFFF)))
    {
      printf("%s\n    %s\n",AlertObject[i].al_name,AlertObject[i].al_text);
      printed=TRUE;
    }
  }
  if(!printed) printf("<UNKNOWN>\n");

  printf("\033[33mSPECIFIC ALERT :\033[31m ");
  printed=FALSE;
  for(i=0;(SpecAlert[i].al_name)!=NULL;i++)
  {
    if(((SpecAlert[i].al_code)==(alnum)))
    {
      printf("%s\n    %s\n",SpecAlert[i].al_name,SpecAlert[i].al_text);
      printed=TRUE;
    }
  }
  if(!printed) printf("<UNKNOWN>\n");

  exit(0L);
}
