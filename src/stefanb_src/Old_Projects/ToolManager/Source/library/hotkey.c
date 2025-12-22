/*
 * hotkey.c  V2.1
 *
 * Replacement for amiga.lib/HotKey(), fixes a bug in ParseIX()
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* #define this constant to use a modified Hotkey() code, which tries to  */
/* circumvent a bug in commodities.library/ParseIX() V37 (and early V38). */
/* Otherwise the normal HotKey() code is used...                          */
#undef PATCH_V37_MOUSEQUALIFIER_BUG

#ifdef PATCH_V37_MOUSEQUALIFIER_BUG

/* Modified HotKey() code */
CxObj *HotKey(UBYTE *desc, struct MsgPort *mp, long ID)
{
 struct InputXpression ix;

 /* Set structure version number */
 ix.ix_Version=IX_VERSION;

 /* Parse Commodities input description string */
 if (!ParseIX(desc,&ix)) {
  CxObj *filter;

  DEBUG_PRINTF("IX Version :   0x%02lx\n",ix.ix_Version);
  DEBUG_PRINTF("Class      :   0x%02lx\n",ix.ix_Class);
  DEBUG_PRINTF("Code       : 0x%04lx\n",ix.ix_Code);
  DEBUG_PRINTF("CodeMask   : 0x%04lx\n",ix.ix_CodeMask);
  DEBUG_PRINTF("Qualifier  : 0x%04lx\n",ix.ix_Qualifier);
  DEBUG_PRINTF("QualMask   : 0x%04lx\n",ix.ix_QualMask);
  DEBUG_PRINTF("QualSame   : 0x%04lx\n",ix.ix_QualSame);

  /* Correct bug in ParseIX(): Now mouse button qualifiers work again! */
  ix.ix_QualMask|=ix.ix_Qualifier;

  DEBUG_PRINTF("Corrected QualMask: 0x%04lx\n",ix.ix_QualMask);

  /* Create dummy filter object */
  if (filter=CxFilter("a")) {
   CxObj *sender;

   DEBUG_PRINTF("Filter: 0x%08lx\n",filter);

   /* Set filter */
   SetFilterIX(filter,&ix);

   DEBUG_PRINTF("Filter set, Error: 0x%08lx\n",CxObjError(filter));

   /* Create sender object */
   if (sender=CxSender(mp,ID)) {
    CxObj *translate;

    DEBUG_PRINTF("Sender: 0x%08lx\n",sender);

    /* Attach sender to filter */
    AttachCxObj(filter,sender);

    /* Create a black hole translation object */
    if (translate=CxTranslate(NULL)) {

     DEBUG_PRINTF("Translator: 0x%08lx\n",translate);

     /* Attach translator to filter */
     AttachCxObj(filter,translate);

     DEBUG_PRINTF("Cx Error: 0x%08lx\n",CxObjError(filter));

     /* Got a Commodities error? */
     if (!CxObjError(filter))
      /* All OK! */
      return(filter);
    }
   }

   /* Delete all CxObjects */
   DeleteCxObjAll(filter);
  }
 }

 /* Call failed */
 return(NULL);
}

#else

/* Original HotKey() code */
CxObj *HotKey(UBYTE *desc, struct MsgPort *mp, long ID)
{
 CxObj *filter;

 /* Create dummy filter object */
 if (filter=CxFilter(desc)) {
  CxObj *sender;

  DEBUG_PRINTF("Filter: 0x%08lx\n",filter);

  /* Create sender object */
  if (sender=CxSender(mp,ID)) {
   CxObj *translate;

   DEBUG_PRINTF("Sender: 0x%08lx\n",sender);

   /* Attach sender to filter */
   AttachCxObj(filter,sender);

   /* Create a black hole translation object */
   if (translate=CxTranslate(NULL)) {

    DEBUG_PRINTF("Translator: 0x%08lx\n",translate);

    /* Attach translator to filter */
    AttachCxObj(filter,translate);

    DEBUG_PRINTF("Cx Error: 0x%08lx\n",CxObjError(filter));

    /* Got a Commodities error? */
    if (!CxObjError(filter))
     /* All OK! */
     return(filter);
   }
  }

  /* Delete all CxObjects */
  DeleteCxObjAll(filter);
 }

 /* Call failed */
 return(NULL);
}

#endif
