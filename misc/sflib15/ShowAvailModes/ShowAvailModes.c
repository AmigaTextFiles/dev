/* Quickie to show available DisplayModes */

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/utility.h>

#include <proto/screenfool.h>

#include <graphics/displayinfo.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <exec/lists.h>

/* Prototypes for functions defined in ShowAvailModes.c */
void main(void);
void Cleanup(LONG retCode);
void ShowDisplayList(void);

void Break(void);
void BreakPressed(void);

LONG Power(LONG, ULONG);

// Quick defines
#define Properties(dmi)  ((dmi)->dmi_Display->PropertyFlags)
#define RectWidth(rect)  ((rect).MaxX-(rect).MinX)+1
#define RectHeight(rect) ((rect).MaxY-(rect).MinY)+1
#define SameDMI(a,b)     ((a)->dmi_DisplayID==(b)->dmi_DisplayID)

void exit(int rc);

int CXBRK(void) { return(0); }
void chkabort(void) { return; }

struct ScreenFoolList *DMIList;

struct Library *ScreenFoolBase;

void main(void)
  {
  ScreenFoolBase=OpenLibrary("screenfool.library",0L);
  if(!ScreenFoolBase) exit(RETURN_FAIL);
  
  DMIList=AllocSFList(sfNT_DISPLAY);
  if(!DMIList)
    {
    CloseLibrary(ScreenFoolBase);
    exit(RETURN_FAIL);
    }
  
  ClearDisplayList(DMIList);
  NewDisplayList(DMIList,
    DIPF_IS_DUALPF | DIPF_IS_HAM | DIPF_IS_EXTRAHALFBRITE);
  ShowDisplayList();
  Cleanup(0L);
  }

void BreakPressed(void)
  {
  if(SetSignal(NULL, NULL) & SIGBREAKF_CTRL_C) Break();
  if(SetSignal(NULL, NULL) & SIGBREAKF_CTRL_D) Break();
  }

void Break(void)
  {
  SetSignal(NULL, SIGBREAKF_CTRL_C);
  Cleanup(ERROR_BREAK);
  }

void Cleanup(LONG retCode)
  {
  LONG rc=RETURN_OK;
  
  ClearDisplayList(DMIList);
  
  if(retCode) {
    if(retCode!=ERROR_BREAK)
      {
      PrintFault(retCode,"ShowAvailModes failed");
      rc=RETURN_FAIL;
      }
    else
      {
      Printf("*** Break: ShowAvailModes\n");
      rc=RETURN_WARN;
      }
    }
  
  DeallocSFList(DMIList);
  CloseLibrary(ScreenFoolBase);
  
  exit(rc);
  }
  
#define CFreeVec(x) { if(x) FreeVec(x); }

void ShowDisplayList(void)
  {
  struct DisplayModeInfo *dmi;
  
  dmi=(struct DisplayModeInfo *)DMIList->lh_Head;
  
  while(dmi!=(struct DisplayModeInfo *)(DMIList->lh_TailPred->ln_Succ))
    {
    Printf("Display name (ID): %s (0x%08lx)\n",dmi->dmi_Name->Name,
      dmi->dmi_DisplayID);
    
    Printf("\nResolution (Text Overscan): %4ld x %4ld\n",
      (LONG)RectWidth(dmi->dmi_Dimensions->TxtOScan),
      (LONG)RectHeight(dmi->dmi_Dimensions->TxtOScan));
    
    Printf("Maximum Bitplanes: %ld\n",dmi->dmi_Dimensions->MaxDepth);
    
    /* Note: for V39, you would use the extension fields
        RedBits, GreenBits, and BlueBits instead of PaletteRange.
      */
    
    Printf("Maximum Colors:    %ld of %ld\n",\
      Power(2,dmi->dmi_Dimensions->MaxDepth),
      dmi->dmi_Display->PaletteRange);
    
    Printf("\nProperties:\n");
    
    if(Properties(dmi) & DIPF_IS_LACE)
      {
      Printf("  Interlaced\n");
      }
    else
      {
      Printf("  Non-Interlaced\n");
      }
    
    if(Properties(dmi) & DIPF_IS_WB)
      Printf("  Workbench-compatible\n");
      
    if(Properties(dmi) & DIPF_IS_HAM)
      Printf("  HAM\n");
      
    if(Properties(dmi) & DIPF_IS_PAL)
      Printf("  PAL (50 Hz)\n");
    
    if(Properties(dmi) & DIPF_IS_ECS)
      Printf("  ECS or AGA Only\n");
    
    if(Properties(dmi) & DIPF_IS_SPRITES)
      Printf("  Can display user sprites\n");
      
    if(Properties(dmi) & DIPF_IS_GENLOCK)
      Printf("  Is genlockable\n");
     
    if(Properties(dmi) & DIPF_IS_PANELLED)
      Printf("  Is panelled (A2024)\n");
    
    if(Properties(dmi) & DIPF_IS_DUALPF)
      Printf("  Dual-playfield\n");
      
    if(Properties(dmi) & DIPF_IS_PF2PRI)
      Printf("    (Playfield 2 on top)\n");
          
    if(Properties(dmi) & DIPF_IS_EXTRAHALFBRITE)
      Printf("  Extra-Halfbrite\n");
    
    if(Properties(dmi) & DIPF_IS_DRAGGABLE)
      Printf("  Draggable\n");
      
    Printf("-----\n");
    
    BreakPressed();
    dmi=(struct DisplayModeInfo *)dmi->dmi_Node.ln_Succ;
    }
  }

LONG Power(LONG base, ULONG exponent)
  {
  if(exponent==0) return(1L);
  if(exponent==1) return(base);
  return(base*Power(base,exponent-1));
  }
