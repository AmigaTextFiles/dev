/*
** $PROJECT: rexxxref.library
**
** $VER: rexxcmdparser.c 1.4 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994,1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.004 : changed to rexxxref.library
** 30.11.94 : 001.003 : added LoadXRef() and ExpungeXRef()
** 26.11.94 : 001.002 : now FindXRef() works
** 28.05.94 : 001.001 : initial
*/

/* ------------------------------- include -------------------------------- */

#include "rexxxref.h"

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** rexxxref.library/--rexxhost-- ****************************************
*
*    HOST INTERFACE
*        rexxxref.library provides an ARexx function host interface that
*        enables ARexx programs to take advantage of the features of the
*        XRef-System.
*
*        The function host library vector is located at offset -30 from the
*        library. This is the value you provide to ARexx in the AddLib()
*        function call.
*
*    FUNCTIONS
*        FindXRef(STRING/A,CATEGORY,LIMIT/N,NOPATTERN/S,NOCASE/S,STEM)
*        LoadXRef(FILE/A,XREFPRI/N,LOCK/S,INDEX/S)
*        ExpungeXRef(CATEGORY,FILE,FORCE/S)
*
*    EXAMPLES
*        \* xref.library ARexx example *\
*        OPTIONS RESULTS
*
*        IF ~SHOW('L','xref.library') THEN
*            CALL ADDLIB('xref.library',0,-30)
*
*        \* load explicitly the sys_autodoc.xref *\
*        IF LoadXRef('sys_autodoc.xref',10,,'INDEX') THEN
*           Say "sys_autodoc.xref loaded with priority 10 !"
*        ELSE
*           Say "Can't load sys_autodoc.xref"
*
*        IF FindXRef('#?Window#?',,10,,,,) THEN
*            DO i = 1 TO xref.count
*                Say "XRef     : " xref.i.Name
*                Say "Type     : " xref.i.Type
*                Say "NodeName : " xref.i.NodeName
*                Say "File     : " xref.i.File
*                Say "Path     : " xref.i.Path
*                Say "Line     : " xref.i.Line
*            END
*        ELSE
*            Say "FindXRef() error : " ERRORTEXT(RC)
*        EXIT
*
*    SEE ALSO
*        ParseXRef() ,XR_LoadXRef() ,XR_ExpungeXRef()
*
******************************************************************************
*
*/
/*FE*/

/* --------------------- My ARexx function structure ---------------------- */

struct ARexxFunction
{
   STRPTR af_Name;
   ULONG (*af_Function)(const struct ARexxFunction *func,struct RexxMsg *rmsg,STRPTR *argstr,struct RexxXRefBase *rxb);
   UWORD af_Args;
};

/* ---------------------- ARexx Function definition ----------------------- */

static const struct ARexxFunction rexxfunc[] = {
   {"FINDXREF"    ,findxref    ,FX_MAX},
   {"LOADXREF"    ,loadxref    ,LX_MAX},
   {"EXPUNGEXREF" ,expungexref ,EX_MAX},
   {NULL,NULL,0}};

/* ------------------------ ARexx Function Server ------------------------- */

LibCall ULONG RexxCmdParser(REGA0 struct RexxMsg *rmsg,REGA6 struct RexxXRefBase *rxb)
{
   if(rmsg && rmsg->rm_Args[0])
   {
      const struct ARexxFunction *func = rexxfunc;

      while(func->af_Function)
      {
         if(!Stricmp(rmsg->rm_Args[0],func->af_Name))
         {
            UBYTE buf[20];
            STRPTR argstr = NULL;
            ULONG rc;

            DB(("ARexx Function :\n"));
            D({
                  ULONG i;
                  bug("%s(",rmsg->rm_Args[0]);
                  for(i = 1 ; i < func->af_Args ; i++)
                     if(rmsg->rm_Args[i])
                        bug("\"%s\",",rmsg->rm_Args[i]);
                  bug("\"%s\")\n",rmsg->rm_Args[i]);
              });

            rc = func->af_Function(func,rmsg,&argstr,rxb);

            if(rc == RC_OK && !argstr)
               if(!(argstr = CreateArgstring("0",1)))
                  rc = RXERR_NO_FREE_STORE;

            DB(("rc : %ld\n",rc));

            /* set RC variable */
            sprintf(buf,"%ld",rc);
            SetRexxVar((struct Message *) rmsg,"RC",buf,strlen(buf));

            putreg(REG_A0,(LONG) argstr);

            return(rc);
         }
         func++;
      }
   }
   return(1);
}

