/* A really dumb example of screenfool.library */

#include <proto/exec.h>
#include <proto/dos.h>

#include <proto/screenfool.h>
#include <libraries/screenfool.h>

void main(void);

struct Library *ScreenFoolBase=NULL;

void main(void)
  {
  struct ScreenFoolList *pslist, *dmilist;
  
  ScreenFoolBase=OpenLibrary("screenfool.library",0L);
  if(ScreenFoolBase) /* Will not open if SysBase->lib_Version<36 */
    {
    pslist=AllocSFList(sfNT_SCREEN);
    if(pslist)
      {
      dmilist=AllocSFList(sfNT_DISPLAY);
      if(dmilist)
        {
        if(NewDisplayList(dmilist,DIPF_IS_DUALPF) && NewPubScreenList(pslist))
          {
          struct DisplayModeInfo *dmi;
          struct PublicScreenInfo *psi;
          struct Screen *tempscreen;
          UWORD penArray={ ~0 };
          
          tempscreen=OpenPublicScreen("DumbExample.1",
            SA_DisplayID, HIRES_KEY,
            SA_Depth,     2,
            SA_Overscan,  OSCAN_TEXT,
            SA_Pens,      (ULONG)&penArray,
            TAG_DONE);
          
          if(tempscreen)
            {
            BPTR console;
            
            console=Open("CON:0/0/640/200/Dumb Example/WAIT/CLOSE/SCREENDumbExample.1",
              MODE_READWRITE);
            if(console)
              {
              VFPrintf(console,"\nDisplays:\n",NULL);
              dmi=(struct DisplayModeInfo *)dmilist->sfl_List.lh_Head;
            
              do
                {
                FPrintf(console,"  %s (0x%lx)\n", dmi->dmi_Node.ln_Name,
                  dmi->dmi_DisplayID);
                dmi=(struct DisplayModeInfo *)dmi->dmi_Node.ln_Succ;
                } while (dmi!=(dmilist->sfl_List.lh_TailPred->ln_Succ));
              
              VFPrintf(console,"\nScreens:\n",NULL);
              psi=(struct PublicScreenInfo *)pslist->sfl_List.lh_Head;
              
              do
                {
                FPrintf(console,"  %s (0x%lx)\n", psi->psi_Node.ln_Name,
                  psi->psi_Screen);
                psi=(struct PublicScreenInfo *)psi->psi_Node.ln_Succ;
                } while (psi!=(pslist->sfl_List.lh_TailPred->ln_Succ));
              
              Close(console);
              }
            
            while(!ClosePublicScreen("DumbExample.1"))
              {
              Delay(5);
              }
            }
          
          ClearDisplayList(dmilist);
          ClearPubScreenList(pslist);
          }
        
        DeallocSFList(dmilist);
        }
      
      DeallocSFList(pslist);
      }
    
    CloseLibrary(ScreenFoolBase);
    }
  }
