/*
 * aslreqs.c  V2.1
 *
 * file & font requester handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Handle window IDCMP's */
__stkargs static struct IntuiMessage *RequesterHook(ULONG mask,
                                                    struct IntuiMessage *msg,
                                                    void *dummy)
{
 if (mask==FRF_INTUIFUNC) { /* FOF_INTUIFUNC == FRF_INTUIFUNC */
  /* Only refresh events are executed */
  if (msg->Class==IDCMP_REFRESHWINDOW) {
   struct Window *w=msg->IDCMPWindow;

   /* Execute GadTools refresh */
   GT_BeginRefresh(w);
   GT_EndRefresh(w,TRUE);
  }

  /* Return pointer to original IntuiMessage */
  return(msg);
 }
 return(0);
}

/* Open a file requester */
char *OpenFileRequester(struct Requester *req)
{
 struct Window *w;
 ULONG oldidcmp;
 char *oldfile,*filepart,*pattern;
 char *dirname=NULL,*newfile=NULL;
 ULONG len;

 w=FileReqParms.frp_Window;
 oldidcmp=w->IDCMPFlags;
 DisableWindow(w,req);

 /* Split old file name */
 oldfile=FileReqParms.frp_OldFile;
 filepart=FilePart(oldfile);

 /* Got a directory? Can we allocate memory for name? */
 len=filepart-oldfile+1;
 if (dirname=malloc(len)) {
  struct FileRequester *filereq;

  if (len>1) strncpy(dirname,oldfile,len-1);
  dirname[len-1]='\0';

  /* Select Pattern */
  if (FileReqParms.frp_Flags2 & FRF_REJECTICONS)
   pattern="~(#?.info)";
  else
   pattern="#?";

  /* Allocate File Requester */
  if (filereq=AllocAslRequestTags(ASL_FileRequest,
                                  ASLFR_Window,          w,
                                  ASLFR_InitialLeftEdge, w->LeftEdge,
                                  ASLFR_InitialTopEdge,  w->TopEdge+WindowTop,
                                  ASLFR_TitleText,     FileReqParms.frp_Title,
                                  ASLFR_PositiveText,  FileReqParms.frp_OKText,
                                  ASLFR_NegativeText,
                                    AppStrings[MSG_FILEREQ_CANCEL_GAD],
                                  ASLFR_Flags1,       FileReqParms.frp_Flags1 |
                                                      FRF_INTUIFUNC,
                                  ASLFR_Flags2,       FileReqParms.frp_Flags2,
                                  ASLFR_HookFunc,        RequesterHook,
                                  ASLFR_InitialDrawer,   dirname,
                                  ASLFR_InitialFile,     filepart,
                                  ASLFR_InitialPattern,  pattern,
                                  TAG_DONE)) {
   /* Show requester */
   if (AslRequest(filereq,NULL)) {
    /* Build file name */
    len=strlen(filereq->fr_File)+1;

    /* File name valid or drawers only? */
    if ((len>1) || (FileReqParms.frp_Flags2 & FRF_DRAWERSONLY)) {
     /* Add drawer string length */
     if (filereq->fr_Drawer) len+=strlen(filereq->fr_Drawer)+1;

     /* Allocate memory for string */
     if (newfile=malloc(len)) {
      *newfile='\0';
      if (filereq->fr_Drawer) strcpy(newfile,filereq->fr_Drawer);
      if (!(FileReqParms.frp_Flags2 & FRF_DRAWERSONLY))
       AddPart(newfile,filereq->fr_File,len);
     }
    }
   }
   FreeAslRequest(filereq);
  }
  free(dirname);
 }

 /* Enable old window */
 EnableWindow(w,req,oldidcmp);

 /* return new file name */
 return(newfile);
}

static struct TextAttr dummyta;

/* Open a file requester */
struct TextAttr *OpenFontRequester(struct Window *w, struct Requester *req,
                                   struct TextAttr *oldfont)
{
 struct FontRequester *fontreq;
 struct TextAttr *curfont,*newfont=NULL;
 ULONG oldidcmp;

 /* Switch off edit window IDCMP */
 oldidcmp=w->IDCMPFlags;
 DisableWindow(w,req);

 /* Set font */
 if (oldfont)
  curfont=oldfont;
 else
  curfont=&ScreenTextAttr;

 /* Allocate font requester */
 if (fontreq=AllocAslRequestTags(ASL_FontRequest,
                                 ASLFO_Window,          w,
                                 ASLFO_InitialLeftEdge, w->LeftEdge,
                                 ASLFO_InitialTopEdge,  w->TopEdge+WindowTop,
                                 ASLFO_TitleText,
                                   AppStrings[MSG_FONTREQ_TITLE],
                                 ASLFO_PositiveText,
                                   AppStrings[MSG_FILEREQ_OK_GAD],
                                 ASLFO_NegativeText,
                                   AppStrings[MSG_FILEREQ_CANCEL_GAD],
                                 ASLFO_Flags,           FOF_DOSTYLE|
                                                        FOF_INTUIFUNC,
                                 ASLFO_HookFunc,        RequesterHook,
                                 ASLFO_InitialName,     curfont->ta_Name,
                                 ASLFO_InitialSize,     curfont->ta_YSize,
                                 ASLFO_InitialStyle,    curfont->ta_Style,
                                 ASLFO_InitialFlags,    curfont->ta_Flags,
                                 TAG_DONE)) {

  DEBUG_PRINTF("FontRequester 0x%08lx\n",fontreq);

  /* Show requester */
  if (AslRequest(fontreq,NULL)) {
   /* User selected new font */
   char *f=fontreq->fo_Attr.ta_Name;
   char *s=NULL;

   DEBUG_PRINTF("Font name '%s'",f);
   DEBUG_PRINTF(" (0x%08lx)\n",f);

   /* Copy font name (Pointer valid? Valid font name (that is "*.font")? */
   if (!f || (strlen(f)<6) || (s=strdup(f))) {
    /* All OK. */
    dummyta=fontreq->fo_Attr;
    dummyta.ta_Name=s;        /* s==NULL if NO font selected! */
    newfont=&dummyta;
   }
  }

  FreeAslRequest(fontreq);
 }

 /* Enable old window */
 EnableWindow(w,req,oldidcmp);

 /* return new file name */
 return(newfont);
}
