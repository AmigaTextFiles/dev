
#ifndef EXTFUNCPROC_H
#define EXTFUNCPROC_H

/*
**    $Filename: extfuncproc.h $
**    $Release:  1.1
**
**
**
**    (C) Copyright 1990  Goetz Mueller
**        All Rights Reserved
*/

#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif !EXEC_PORTS_H

struct ExtFuncPort {
   struct MsgPort efp_MsgPort;         /* Exec-Message-Port */
   UWORD efp_MatchWord;                /* 0x4AFC */
   struct ExtFuncPort *efp_MatchTag;   /* Pointer to start of structure */
};

#define EFP_PORTNAME    "ExtFuncPort"  /* Name of Port */
#define EFP_MATCHWORD   0x4AFC         /* illegel Opcode to identify */

struct ExtFuncMessage {
   struct Message efm_Msg;             /* Exec-Message */
   UBYTE *efm_LibName;                 /* Name of library to be opened */
   ULONG efm_LibVersion;               /* Version of library */
   WORD  efm_LibVectorOffset;          /* Entry in function table */
   ULONG efm_ArgD0;                    /* Function arguments */
   ULONG efm_ArgD1;
   ULONG efm_ArgD2;
   ULONG efm_ArgD3;
   ULONG efm_ArgD4;
   ULONG efm_ArgD5;
   ULONG efm_ArgD6;
   ULONG efm_ArgD7;
   ULONG efm_ArgA0;
   ULONG efm_ArgA1;
   ULONG efm_ArgA2;
   ULONG efm_ArgA3;
   ULONG efm_ArgA4;
   ULONG efm_ArgA5;
   ULONG efm_Result;                   /* Function result (D0) */
   ULONG efm_Result2;                  /* IoErr() of dos.library calls */
   ULONG efm_Error;                    /* Error before function starts
                                          e.g.  Can't open library */
};

#endif /* EXTFUNCPROC_H */

