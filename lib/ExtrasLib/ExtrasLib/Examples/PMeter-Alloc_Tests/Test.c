#include <clib/extras_protos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>
#include <proto/dos.h>
#include <stdio.h>
#include <exec/memory.h>
#include <stdlib.h>

extern struct Custom custom;
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct Library *GadToolsBase, 
               *DiskfontBase;

struct Libs Libs[]=
{
  (APTR)&DiskfontBase , (STRPTR)"diskfont.library" , 36, 0,
  (APTR)&GfxBase      , (STRPTR)"graphics.library" , 36, 0,
  (APTR)&GadToolsBase , (STRPTR)"gadtools.library" , 36, 0,
  (APTR)&IntuitionBase, (STRPTR)"intuition.library", 36, 0,
  0,0,0,0
};

void main(int argc, char **argv)
{
  LONG l;
  APTR a=0,b=0,c=0;
  APTR pool;
  BOOL success;
  ProgressMeter pm[3];
  LONG t,m=3;
  struct Screen *s;
  ULONG canceled=0,can;
          
  if(OpenLibs(argc,(STRPTR)"TestProg",0,0,0,Libs))
  {
    s=LockPubScreen(0);
    
    printf("Testing Progress Meter...\nCancel the requester to continue\n");
    
    pm[0]=AllocProgressMeter(
                          PM_WinTitle  ,        (ULONG)"Demo Meter 1",
                          PM_MeterLabel,        (ULONG)"Formating disk...",
                          PM_LowText   ,        (ULONG)"0%",
                          PM_HighText  ,        (ULONG)"100%",
                          PM_Screen,            s,
                          PM_TextAttr,          s->Font,
                          PM_Ticks,             5,
                          PM_HighValue,         200,
                          PM_MeterValue,        100,
                          PM_CancelButton,      TRUE,
                          PM_CancelText,        (ULONG)"Stop",
                          TAG_DONE);
                          
    pm[1]=AllocProgressMeter(PM_WinTitle  ,     "Demo Meter 2",
                          PM_MeterLabel,        "Hex-o-meter",
                          PM_LowText   ,        "0",
                          PM_HighText  ,        "200",
                          PM_CancelButton,      TRUE,
                          PM_CancelText,        "Cancel",
                          PM_Screen,            s,
                          PM_MinWidth,          320,
                          PM_TextAttr,          s->Font,
                          PM_Ticks,             10,
                          PM_HighValue,         200,
                          PM_MeterValue,        10,
                          PM_MeterPen   ,       1,
                          PM_MeterBgPen ,       3, 
                          PM_MeterType,         PM_TYPE_NUMBER,
                          PM_MeterFormat,       "%X",
                          TAG_DONE);
   pm[2]=AllocProgressMeter(PM_WinTitle  ,      "Demo Meter 3",
                          PM_MeterLabel,        "Volume",
                          PM_LowText   ,        "0%",
                          PM_HighText  ,        "100%",
                          PM_Screen,            s,
                          PM_TextAttr,          s->Font,
                          PM_Ticks,             1,
                          PM_MinWidth,          128,
                          PM_LowValue,          0,
                          PM_HighValue,         128*4,
                          PM_MeterValue,        10,
                          PM_MeterType,         PM_TYPE_STRING,
                          PM_MeterFormat,       "",
                          TAG_DONE);
    while(!canceled)
    for(l=0;l<201 && !canceled;l++)
    {
      for(t=0;t<m;t++)
      {
        WaitTOF();
        WaitTOF();
        UpdateProgressMeter(pm[t],
                         PM_MeterValue  ,l,
                         PM_QueryCancel ,&can,
                         TAG_DONE);
        canceled+=can;
      }
    }
    
    for(t=0;t<m;t++)
      FreeProgressMeter(pm[t]);
    
    UnlockPubScreen(0,s);
    
    
    printf("MultiAllocX() tests\n");
    /* Multiple AllocVec */
    success=MultiAllocVec(0,&a, 100,MEMF_CLEAR,
                    &b, 120,MEMF_PUBLIC,
                    &c,   8,MEMF_FAST,
                    0);
    printf("Vec  success=%d  a=%8x  b=%8x  c=%8x\n",success,a,b,c);
    MultiFreeVec(3,a,
                   b,
                   c);


    /* Multiple AllocMem */
    MultiAllocMem(0,&a, 100,MEMF_CLEAR,
                    &b, 120,MEMF_PUBLIC,
                    &c,   8,MEMF_FAST,
                    0);
    printf("Mem  success=%d  a=%8x  b=%8x  c=%8x\n",success,a,b,c);
    MultiFreeMem(3,a,100,
                   b,120,
                   c,8);

    /* Multiple AllocPooled */
    if(pool=CreatePool(MEMF_CLEAR,1000,1000))
    {
      MultiAllocPooled(pool,0,&a, 100,
                              &b, 120,
                              &c,   8,
                              0);
      printf("Pool success=%d  a=%8x  b=%8x  c=%8x\n",success,a,b,c);
      MultiFreePooled(pool,3,a, 100,
                             b, 120,
                             c, 8);
      DeletePool(pool);
    }     

    /* the following demonstrate the MA_FAILSIZE0 flag */
    /* Multiple AllocVec without MA_FAILSIZE0 flag*/
    success=MultiAllocVec(0,&a, 0    ,MEMF_CLEAR,
                            &b, 120  ,MEMF_PUBLIC,
                            &c, 8    ,MEMF_FAST,
                            0);
    printf("Vec  success=%d  a=%8x  b=%8x  c=%8x  without MA_FAILSIZE0\n",success,a,b,c);
    MultiFreeVec(3,a,
                   b,
                   c);
    
    /* Multiple AllocVec with MA_FAILSIZE0 flag*/
    success=MultiAllocVec(MA_FAILSIZE0, &a, 0   ,MEMF_CLEAR,
                                        &b, 120 ,MEMF_PUBLIC,
                                        &c, 8   ,MEMF_FAST,
                                        0);
    printf("Vec  success=%d  a=%8x  b=%8x  c=%8x  with MA_FAILSIZE0\n",success,a,b,c);
    MultiFreeVec(3,a,
                   b,
                   c);

    CloseLibs(Libs);
  }
}
