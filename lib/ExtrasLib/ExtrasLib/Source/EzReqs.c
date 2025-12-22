#include <clib/extras_protos.h>
#include <clib/extras/intuition_protos.h>
#include <proto/exec.h>
#include <proto/intuition.h>

//struct FontRequester *ML_FontReq;
/****** extras.lib/EZReq ******************************************
*
*   NAME
*       EZReq -- create an Intuition EasyRequest.
*
*   SYNOPSIS
*       retval = EZReq(Win, IDCMP_ptr, Title, Text,
*                       ButtonText,Arg,...)
*
*       LONG EZReq(struct Window *, ULONG *, STRPTR, STRPTR, 
*                  STRPTR, ULONG, ...);
*
*   FUNCTION
*       This function provides an easier method to use the 
*       intuition/EasyRequestArgs() function.
*
*   INPUTS
*       Win -
*       IDCMP_ptr - 
*       Title -
*       Text -
*       ButtonText -
*       Arg -
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*       requires the exec.library to be open, automatically opens
*       intuition.library.
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/

LONG EZReq(struct Window *Win,
           ULONG *IDCMP_ptr,
           STRPTR Title,
           STRPTR Text,
           STRPTR ButtonText,
           ULONG Arg,
           ... )
{
  struct EasyStruct es;    
//  struct IntuitionBase *IntuitionBase;
  LONG  rv;
  
//  if(IntuitionBase=(struct IntuitionBase *)OpenLibrary((UBYTE *)"intuition.library",36))
  {
    es.es_StructSize    =sizeof(struct EasyStruct);
    es.es_Flags         =0;
    es.es_Title         =Title;
    es.es_TextFormat    =Text;
    es.es_GadgetFormat  =ButtonText;
    rv=EasyRequestArgs(Win,&es,IDCMP_ptr,&Arg);
//    CloseLibrary((struct Library *)IntuitionBase);
  }
  return(rv);
}

/*
BOOL PickFont(struct Window *w,
              WORD InitLeft,
              WORD InitTop,
              WORD InitWidth,
              WORD InitHeight,
              struct TTextAttr *TA)
{
  if(TA)
  {
    if(!ML_FontReq)
      ML_FontReq=(struct FontRequester *)AllocAslRequestTags(ASL_FontRequest, 
                      ASLFO_InitialTopEdge,  InitTop,
                      ASLFO_InitialLeftEdge, InitLeft,
                      ASLFO_InitialWidth,    InitWidth,
                      ASLFO_InitialHeight,   InitHeight,
                      ASLFO_SleepWindow,     TRUE,
                      ASLFO_TitleText,       FontReqTitle,
                      ASLFO_DoStyle,         TRUE,
                      ASLFO_MinHeight,       1,
                      ASLFO_MaxHeight,       65535,
                      TAG_DONE);
    if(ML_FontReq)
    {
      if(AslRequestTags(ML_FontReq, 
                  ASLFO_Window   ,       w,
                                  TAG_DONE))
      {
        if(TA->tta_Name)  
          FreeVec(TA->tta_Name);
        if(TA->tta_Name=AllocVec(strlen(ML_FontReq->fo_TAttr.tta_Name)+1,MEMF_PUBLIC|MEMF_CLEAR))
          strcpy(TA->tta_Name,ML_FontReq->fo_TAttr.tta_Name);
        TA->tta_YSize = ML_FontReq->fo_TAttr.tta_YSize;
        TA->tta_Style = ML_FontReq->fo_TAttr.tta_Style & (~FSF_TAGGED);
        TA->tta_Flags = ML_FontReq->fo_TAttr.tta_Flags;
        return(TRUE);
      }   
    }
  }
  return(FALSE);
}
*/