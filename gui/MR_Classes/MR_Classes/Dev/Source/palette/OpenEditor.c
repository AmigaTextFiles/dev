#include "ui.h"
#include "edata.h"
#include "apptags.h"
#include "gids.h"

#define DEBUG
#include <debug.h>

void InitGadgetValues(struct EData *edata);

ULONG i_OpenEditor(Class *C, Object *Obj, struct opSet *Set)
{
  struct EData *edata;
  ULONG retval=0;

  edata=INST_DATA(C,Obj);

//  DKP("InitGV\n");
  InitGadgetValues(edata);
//  DKP("EndInitGV\n");



  if( edata->Window = (struct Window *) RA_OpenWindow(edata->Win_Object) )
  {
    ULONG wait, signal, result, done = FALSE;
    WORD Code;
  				
    /* Obtain the window wait signal mask.	 */
    GetAttr( WINDOW_SigMask, edata->Win_Object, &signal );
    /* Input Event Loop	 */
  	while( !done )
  	{
  	  wait = Wait(signal|SIGBREAKF_CTRL_C);
      // DKP("wait=%d %x\n",wait,wait);
  		if (wait & SIGBREAKF_CTRL_C)
      {
        done = TRUE;
      }
  		else
      {
 			  while ((result = RA_HandleInput(edata->Win_Object,&Code)) != WMHI_LASTMSG)
  			{
          //DKP("result=%d %x\n",result,result);
  				switch (result & WMHI_CLASSMASK)
  				{
  				  case WMHI_CLOSEWINDOW:
  					  done = TRUE;
  						break;
 					  case WMHI_GADGETUP:
  					  switch(result & WMHI_GADGETMASK)
  						{
  						  case GID_OK:
                  done=TRUE;
                  GetAttr(TCPALETTE_RGBPalette, edata->G_Palette, edata->pr_InitialPalette);//         (44.3.1) (09/03/00)
                  retval=1;
  							  break;
  						  case GID_CANCEL:
                  done=TRUE;
                  retval=0;
                  break;
                case GID_RESET:
                  SetGadgetAttrs(edata->G_Palette,edata->Window,0,
                      TCPALETTE_NumColors,  edata->pr_Colors,
                      TCPALETTE_RGBPalette, edata->pr_InitialPalette,
                      TAG_DONE);    
                
  							  break;
                case GID_UNDO:
                  SetGadgetAttrs(edata->G_Palette,edata->Window,0,
                      TCPALETTE_Undo,  1,
                      TAG_DONE);    
                
  							  break;
                  
  						}
  				    break;
  				}
  			}
      }
    }
    RA_CloseWindow(edata->Win_Object);
  }
  return(retval);  
}


ULONG __saveds __asm IDCMPDispatch( register __a0 struct IDCMP_Hook *hook,
                    				        register __a2 APTR	   object,
                                    register __a1 struct IntuiMessage *IMsg)
{
  struct TagItem *tag,*tstate;
  struct EData *edata;
  
  edata=hook->EData;

  switch(IMsg->Class)
  {
    case IDCMP_IDCMPUPDATE:
//      DKP("IDCMP_IDCMPUPDATE - \n");
      ProcessTagList(IMsg->IAddress, tag, tstate)
      {
        ULONG t,d;
  
        t=tag->ti_Tag;
        d=tag->ti_Data;
        switch(t)
        {
          case GA_ID:
//            DKP("  GA_ID: %ld\n",d);
            break;
            
          default:
          /*
            if(~(t & REACTION_Dummy))
            {
              DKP("  0x%08lx,%ld\n",t,d);            
            }*/
        }
      }
      break;
  }
  return(1);
}

void InitGadgetValues(struct EData *edata)
{
  SetAttrs(edata->Win_Object, 
//    WA_PubScreenName,   edata->pr_PubScreenName,
//    WA_CustomScreen,    edata->pr_Screen,
//    WINDOW_RefWindow,   edata->pr_Window,
//    WINDOW_Position,    WPOS_CENTERWINDOW,
    WINDOW_TextAttr,    edata->pr_TextAttr,
    WA_Title,           (edata->pr_TitleText ? edata->pr_TitleText : GetString(MSG_W_TITLE)),
    WA_ScreenTitle,           (edata->pr_TitleText ? edata->pr_TitleText : GetString(MSG_W_TITLE)),
    TAG_DONE);

  SetAttrs(edata->G_Palette,
    TCPALETTE_NumColors,  edata->pr_Colors,
    TCPALETTE_RGBPalette, edata->pr_InitialPalette,
    TAG_DONE);
    
  SetAttrs(edata->G_OK,
    GA_Text, (edata->pr_PositiveText ? edata->pr_PositiveText : "OK"),
    TAG_DONE);
    
  SetAttrs(edata->G_Cancel,
    GA_Text, (edata->pr_NegativeText ? edata->pr_NegativeText : "Cancel"),
    TAG_DONE);
}



