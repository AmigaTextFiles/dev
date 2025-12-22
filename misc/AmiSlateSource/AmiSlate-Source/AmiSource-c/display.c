/* This module was hacked painfully from a Commodore AmigaMail example. */

/* ScreenDisplayModes.c - V36 Screen Displaymode selector example
   hacked by Jeremy Friesner 12/30/94 -- do not distribute! It ain't pretty! */
		
#include <stdio.h>		
#include <string.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <graphics/displayinfo.h>
#include <graphics/text.h>
#include <exec/memory.h>
#include <exec/ports.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include "AmiSlate.h"

#define SWITCH 888
#define QUIT   999

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
extern struct Library *GadToolsBase;
extern struct Library *SysBase;
extern BOOL BAGA;
extern BOOL BDos20;
extern int screentype;
extern int nSynchPaletteMode;
extern char szVersionString[];

int nWorkbenchDepth;

/* module-private functions */
__stkargs static struct Screen *ShowDisplayModes(struct List * dlist, 
			WORD bRHeight, WORD bRWidth, BYTE bRDepth);
static struct Screen *OpenAScreen(struct DimensionInfo * di, UBYTE * name,
			   ULONG overscantype, int nDepth);
static struct Window *OpenAWindow(struct Screen * screen, ULONG overscantype);

struct DisplayNode {
    struct Node dn_Node;
    struct DimensionInfo dn_Dimensioninfo;
};

/* The workbench compatible pens we'll use for that New Look. */
static UWORD dri_Pens[] = {0, 1, 1, 2, 1, 3, 1, 0, 3, ~0};

struct EasyStruct failedES =
{
    sizeof(struct EasyStruct), 0, "SDM",
    "%s",
    "OK",
};


struct Screen *GetDisplay(WORD wRHeight, WORD wRWidth, BYTE bRDepth)
{
    struct List *dlist;
    struct DisplayNode *dnode;
    struct DisplayNode *wnode, *nnode;
	 struct Screen *sScreen;
	 struct Node NWorkbenchNode;
	 char szWorkBench[] = "Workbench";  	 	 
    ULONG modeID;
    ULONG skipID;
    ULONG result;
    struct DisplayInfo displayinfo;
    struct NameInfo nameinfo;
 
	 /* Note:  This node is statically allocated */    
    NWorkbenchNode.ln_Name = szWorkBench;

    if (dlist = AllocMem(sizeof(struct List), MEMF_CLEAR)) 
    {
         NewList(dlist);
	
	   	 AddTail(dlist, &NWorkbenchNode);
		  
    	 /*
         * Don't want duplicate entries in the list for the
         * 'default monitor', so we'll skip the the videomode
         * for which default.monitor is the alias.
         */

         /* INVALID_ID indicates the beginning and the end
	      * of the list of available keys.
		  */
         modeID = INVALID_ID;

         GetDisplayInfoData(NULL, (UBYTE *) & displayinfo, sizeof(struct DisplayInfo),
         						       DTAG_DISP, LORES_KEY);
         if (displayinfo.PropertyFlags & DIPF_IS_PAL)
            skipID = PAL_MONITOR_ID;
         else
            skipID = NTSC_MONITOR_ID;
         while ((modeID = NextDisplayInfo(modeID)) != INVALID_ID) 
         {
           if ((modeID & MONITOR_ID_MASK) != skipID) 
           {
			    /*
			     * For this example,only 'named' keys are accepted.  Others
			     * which have no description are left out
 			     * even though they may be available.
 			     * HAM and EXTRAHALFBRIGHT are examples of this.
 			     * If needed a name could be made like '320x400 HAM Interlace'.
 			     */

              if (result = GetDisplayInfoData(NULL,(UBYTE *) & nameinfo,
				sizeof(struct NameInfo), DTAG_NAME, modeID)) 
	      {
                 result = GetDisplayInfoData(NULL,(UBYTE *) & displayinfo,
				sizeof(struct DisplayInfo), DTAG_DISP,modeID);
                 if (!(displayinfo.NotAvailable)) 
                 {
                     if (dnode = (struct DisplayNode *) 
                        AllocMem(sizeof(struct DisplayNode),MEMF_CLEAR)) 
                     {
                        result = GetDisplayInfoData(NULL,(UBYTE *) &
    			 	  (dnode->dn_Dimensioninfo),sizeof(struct DimensionInfo),
		   		  DTAG_DIMS, modeID);
               			/* to keep it short: if NOMEM,
				 * just don't copy
				 */
                        if (dnode->dn_Node.ln_Name = AllocMem(
                        	strlen(nameinfo.Name)+ 1, MEMF_CLEAR))
                     			strcpy(dnode->dn_Node.ln_Name, nameinfo.Name);
                   		AddTail(dlist, (struct Node *) dnode);
                 		}
                 		else 
                 		{
                   		EasyRequest(NULL, &failedES, NULL, "Out of memory");
                                        
                   		/* Force modeID to INVALID to break */
                   		modeID = INVALID_ID;
                		}
                 }
              }
           }
         }
      sScreen = ShowDisplayModes(dlist, wRWidth, wRHeight, bRDepth);    

	  /* Cleanup! */				
	  /* Start with second in List because the first was statically allocated */
      wnode = (struct DisplayNode *) dlist->lh_Head->ln_Succ;
      while (nnode = (struct DisplayNode *) (wnode->dn_Node.ln_Succ)) 
      {
        if (wnode->dn_Node.ln_Name)
           FreeMem(wnode->dn_Node.ln_Name,strlen(wnode->dn_Node.ln_Name) +1);
           
        Remove((struct Node *) wnode);
        FreeMem(wnode, sizeof(struct DisplayNode));
        wnode = nnode;
      }
      FreeMem(dlist, sizeof(struct List));
    } 
    else
    EasyRequest(NULL, &failedES, NULL, "Out of memory");
  return(sScreen); 
}




__stkargs static struct Screen *
ShowDisplayModes(struct List * dlist, WORD wRWidth, WORD wRHeight, BYTE bRDepth)
{
    struct Screen *screen = NULL;
    struct Window *window;
    struct Gadget *glist, *gadget, *hitgadget;
    struct DrawInfo *drawinfo;
    struct TextFont *defaultfont;
    struct TextAttr *textattr;
    struct IntuiMessage *imsg;
    struct NewGadget *ng;
	 STRPTR pnames[] = {"Both", "Remote", "Local", "Neither", NULL};
    int nDepth;
    void *vi;
    char sBuffer[200];
    ULONG iclass, icode;
    struct DisplayNode *dnode;
    struct DimensionInfo *dimensioninfo;
    ULONG curmode = 0;
    BOOL ABORT = TRUE, OK, BWriteScreenInfo = TRUE;
    int i;
	
	 /* 0 = set to our default, otherwise use remote screen val as current */
	 if (bRDepth == -1) 
	 {
	 	bRDepth = (BAGA*5)+3;
	 	BWriteScreenInfo = FALSE;
	 }
	 
    if (ng = AllocMem(sizeof(struct NewGadget), MEMF_CLEAR)) 
    {
        if (textattr = AllocMem(sizeof(struct TextAttr), MEMF_CLEAR)) 
        {
            if (textattr->ta_Name = AllocMem(48, MEMF_CLEAR)) 
            {
                  dnode = (struct DisplayNode *) dlist->lh_Head;
	              OK = FALSE;
                  screen = LockPubScreen("Workbench");
                  if (screen == NULL) return(NULL);
                  nWorkbenchDepth = screen->RastPort.BitMap->Depth;
						nDepth = nWorkbenchDepth;
						drawinfo = GetScreenDrawInfo(screen);
                  defaultfont = drawinfo->dri_Font;
                  strcpy(textattr->ta_Name,defaultfont->tf_Message.mn_Node.ln_Name);

                  textattr->ta_YSize = defaultfont->tf_YSize;
                  textattr->ta_Style = defaultfont->tf_Style;
                  textattr->ta_Flags = defaultfont->tf_Flags;

                  if (window = OpenAWindow(screen, OSCAN_TEXT))
                  {
                  	vi = GetVisualInfo(screen, TAG_END);
                  	
                    	if (gadget = CreateContext(&glist)) 
                     {
                     	/* ListView Gadget */
			ng->ng_LeftEdge = window->BorderLeft + 10;
			ng->ng_TopEdge  = window->BorderTop + 10;
			ng->ng_Width    = window->Width - (window->BorderLeft + 10) -
					  							(window->BorderRight + 10);
			ng->ng_Height   = window->Height - (window->BorderTop + 10) - (25 * BWriteScreenInfo) -
					  (window->BorderBottom + 10) - (4 + defaultfont->tf_YSize + 2);
                        ng->ng_TextAttr = textattr;
                        ng->ng_GadgetText = NULL;
                        ng->ng_VisualInfo = vi;
                        ng->ng_GadgetID   = 1;
                        ng->ng_Flags      = PLACETEXT_ABOVE;
                        gadget =	CreateGadget(LISTVIEW_KIND, gadget,
						      ng, GTLV_Labels, dlist,
						      GTLV_ShowSelected, NULL,
						      GTLV_Selected, curmode,
						      TAG_END);

			/* OK Gadget */
                       	ng->ng_TopEdge += gadget->Height + 7 + (BDos20 * defaultfont->tf_YSize);
                        ng->ng_LeftEdge = ng->ng_LeftEdge + ng->ng_Width - 80;
                        ng->ng_Width = 80;
                       	ng->ng_Height = defaultfont->tf_YSize + 8;
                        ng->ng_GadgetID = 2;
                        ng->ng_GadgetText = "OK";
                        ng->ng_VisualInfo = vi;
                        ng->ng_Flags = PLACETEXT_IN;
                        gadget = CreateGadget(BUTTON_KIND, gadget, ng, TAG_END);
														
						/* Slider Gadget */
                        ng->ng_Width = window->Width - 130;
                        ng->ng_LeftEdge =	(window->BorderLeft + 25);
					    				   					
			ng->ng_Height = window->Height - ng->ng_TopEdge - defaultfont->tf_YSize - 6 - (25 * BWriteScreenInfo);
			if (ng->ng_Height < 4) ng->ng_Height = 4;
			
                        ng->ng_GadgetID = 3;
                        ng->ng_GadgetText = "BitMap Depth";
                        ng->ng_VisualInfo = vi;
                        ng->ng_Flags = PLACETEXT_BELOW;
                        gadget = CreateGadget(SLIDER_KIND, gadget, ng, GA_Disabled, TRUE,
                        			GTSL_Min, 1, GTSL_Max, (BAGA*3)+5,
                        			GTSL_Level, nWorkbenchDepth, GTSL_LevelFormat,
                        			"%1ld", GTSL_MaxLevelLen, 1,
                        			TAG_END);
	
	                     AddGList(window, glist, -1, -1, NULL);
	                     RefreshGList(glist, window, NULL, -1);
  	                     GT_RefreshWindow(window, NULL);
  	                     ABORT = FALSE;
                     } 
                     else
                     EasyRequest(window, &failedES, NULL,"Can't create gadget context");
                       
                     /* Put in Remote dimension message if appropriate */
                     if (BWriteScreenInfo == TRUE)
                     {
                     	SetAPen(window->RPort, 1);
                     	Move(window->RPort, 70, window->Height-17);
                     	Text(window->RPort, "Your partner is using a",23);
                     	Move(window->RPort, 45, window->Height-6);
                     	sprintf(sBuffer, "%u x %u, %u bitplane screen",
                     				wRWidth, wRHeight, bRDepth);
                     	Text(window->RPort,sBuffer, strlen(sBuffer));
                     }
                     
                     do 
                     {
                        WaitPort(window->UserPort);
                        while (imsg = GT_GetIMsg(window->UserPort)) 
                        {
                          iclass = imsg->Class;
                          icode = imsg->Code;
                          hitgadget = (struct Gadget *) imsg->IAddress;
                          GT_ReplyIMsg(imsg);

                          switch (iclass) 
                          {
                            case GADGETUP:
                              switch (hitgadget->GadgetID)
                              {
                              	case 1:
                                		dnode = (struct DisplayNode *) dlist->lh_Head;
                                		if (icode == 0)
						    		     		{
						    		     				/* Disable Slider Gadget */
						    		     				GT_SetGadgetAttrs(gadget, window, NULL, GA_Disabled, TRUE, TAG_END);
						    		     		}
						    		     		else
						    		     		{
						    		     			/* Enable it */
						    		     			/* Disable Slider Gadget */
						    		     			GT_SetGadgetAttrs(gadget, window, NULL, GA_Disabled, FALSE,  TAG_END);
						    		     		}
						    		     		for (i = 0; i < icode; i++)
                                		{
                                  		dnode = (struct DisplayNode *) dnode->dn_Node.ln_Succ;
						    		     	 		curmode = i;
						    		     		}
						    		     	break;
						    		     	
						    	 case 2:
                               			OK = TRUE;
                               	break;
                              }
                              break;

									 case IDCMP_MOUSEMOVE:
									 	if (hitgadget->GadgetID == 3) nDepth = icode;
                              break;
                             
                            case CLOSEWINDOW:
                              ABORT = TRUE;
                              break;
                              
                            case VANILLAKEY:
                              switch(icode)
                              {
                              	case 13:
                              		OK = TRUE;		/* Return pressed */
                              		break;
                              	case 27:
                              		ABORT = TRUE;	/* Escape pressed */
                              		break;
                              }
                              break;
                          }
                        }
                     } 
                     while (ABORT == FALSE && OK == FALSE);
                     
                     CloseWindow(window);
                     FreeVisualInfo(vi);
                     FreeGadgets(glist);
                     FreeMem(textattr->ta_Name, 48);
                     FreeMem(ng, sizeof(struct NewGadget));
            		 FreeMem(textattr, sizeof(struct TextAttr));

					 FreeScreenDrawInfo(screen, drawinfo);
					 UnlockPubScreen("Workbench",screen);

                     if (ABORT == TRUE) return(NULL);
				                     
					 if (OK == TRUE) 
                     {
                     	if (strcmp(dnode->dn_Node.ln_Name,"Workbench") == 0)
                     	{
                     		screentype = USE_WORKBENCHSCREEN;
                     		screen = NULL;
                     	}
                     	else
                     	{
                    	 	dimensioninfo = &(dnode->dn_Dimensioninfo);
                     		screen = OpenAScreen(dimensioninfo,
                                          dnode->dn_Node.ln_Name,
                                          OSCAN_TEXT,nDepth);  
                            screentype = USE_CUSTOMSCREEN;
                        }
                     }
                     return(screen);
                  } 
                  else
                  {
                     EasyRequest(NULL, &failedES, NULL,"Can't open window");
                  }
               
               
               } 
            else
            {
            	EasyRequest(NULL, &failedES, NULL, "Out of memory");
        			FreeMem(ng, sizeof(struct NewGadget));
            	FreeMem(textattr, sizeof(struct TextAttr));
           	}
         } 
         else
         {
            EasyRequest(NULL, &failedES, NULL, "Out of memory");
        		FreeMem(ng, sizeof(struct NewGadget));
         }
    } 
    else
    {
    	EasyRequest(NULL, &failedES, NULL, "Out of memory");
    }
	return(NULL);
}


/*
 * It's advised to use one of the overscan constants and
 * STDSCREENWIDTH and STDSCREENHEIGHT. For this example however, we'll
 * skip all that an use QueryOverscan to get the rectangle describing the
 * requested overscantype and pass that as the displayclip description.
 * Actually, since we pass the standard rectangle from the display database,
 * it is equivalent to the prefered:
 *
 * screen = OpenScreenTags(NULL,
 *                         SA_DisplayID, di->Header.DisplayID,
 *                         SA_Overscan, overscantype,
 *                         SA_Width, STDSCREENWIDTH,
 *                         SA_Height, STDSCREENHEIGHT,
 *                         SA_Title, name,
 *                         SA_Depth, 2,
 *                         SA_SysFont, 1,
 *                         SA_Pens, dri_Pens,
 *                         TAG_END);
 */

struct Screen *
OpenAScreen(struct DimensionInfo * di, UBYTE * name, ULONG overscantype, int nDepth)
{

    struct Rectangle rectangle;

    /* Can't fail, already made sure it's a valid displayID */
    QueryOverscan(di->Header.DisplayID, &rectangle, overscantype);


    return (OpenScreenTags(NULL,
                           SA_DisplayID, di->Header.DisplayID,
                           SA_DClip, &rectangle,
                           SA_Title, szVersionString+5,
                           SA_Depth, nDepth,
                           SA_SysFont, 1,   /* Use the prefered WB screen font */
                           SA_Pens, dri_Pens,
                           TAG_END));
}

static struct Window *
OpenAWindow(struct Screen * screen, ULONG overscantype)
{
	 const int nWindowHeight = 200, nWindowWidth = 320;
	 int nWindowTop, nWindowLeft;
	 
	 if (screen->Width < nWindowWidth) return(NULL);
	 if (screen->Height < nWindowHeight) return(NULL);
	 
	 /* center window on screen */	  
	 nWindowTop =  (screen->BarHeight + 1)+
                  (((screen->Height-(screen->BarHeight+1))-nWindowHeight))/2;

	 nWindowLeft = ((screen->Width-nWindowWidth))/2;
                          
     return (OpenWindowTags(NULL,
                           WA_Top, nWindowTop,
                           WA_Left, nWindowLeft,
                           WA_Height, nWindowHeight,
                           WA_Width, nWindowWidth,
                           WA_IDCMP, CLOSEWINDOW | BUTTONIDCMP | LISTVIEWIDCMP | SLIDERIDCMP | IDCMP_VANILLAKEY,
                           WA_Flags, WINDOWCLOSE | ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET,
                           WA_Title, "Select a display resolution",
                           TAG_END));
}


