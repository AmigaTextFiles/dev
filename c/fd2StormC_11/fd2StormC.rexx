/*
** fd2StormC.rexx
**
** FD2Pragma for Storm-C - Version 1.1 / 12.8.1996
**
** Copyright © 1996 by Michael Conrad
*/

IF ARG() ~= 1 THEN /* check, if fd-filename given */
DO
  SAY "Usage: rx fd2StormC.rexx <fd-filename without path>" /* if not, print usage instruction */
  EXIT 10 /* return error code 10 */
END

offset = 30 /* initialise call-offset for library function to 0x1e */

PARSE ARG fdfilename . /* get fd-filename, usually: 'dummy_lib.fd' */
fdname = LEFT(fdfilename,LASTPOS("_lib.fd",fdfilename) - '1') /* get 'dummy' */
pragmafilename = INSERT(fdname,"_pragmas.h")

IF ~OPEN('fdfile',fdfilename,'READ') THEN /* open fd-file for read access */
DO
  SAY "Error: failed to open fd-file "fdfilename /* error, if not successful */
  EXIT 10 /* return error code 10 */
END

IF ~OPEN('pragmafile',pragmafilename,'WRITE') THEN /* open pragma-file for write access */
DO
  SAY "Error: failed to open pragma-file "pragmafilename /* error, if not successful */
  CLOSE('fdfile')
  EXIT 10 /* return error code 10 */
END

WRITELN('pragmafile',"#ifndef _INCLUDE_PRAGMA_"UPPER(fdname)"_LIB_H")
WRITELN('pragmafile',"#define _INCLUDE_PRAGMA_"UPPER(fdname)"_LIB_H")
WRITELN('pragmafile',"")
WRITELN('pragmafile',"/*")
WRITELN('pragmafile',"**  $VER: "fdname"_lib.h ("DATE(EUROPEAN)")")
WRITELN('pragmafile',"**")
WRITELN('pragmafile',"**  Storm-C pragma file")
WRITELN('pragmafile',"*/")
WRITELN('pragmafile',"")
WRITELN('pragmafile',"#ifndef CLIB_"UPPER(fdname)"_PROTOS_H")
WRITELN('pragmafile',"#include <clib/"fdname"_protos.h>")
WRITELN('pragmafile',"#endif")
WRITELN('pragmafile',"")
WRITELN('pragmafile',"#ifdef __cplusplus")
WRITELN('pragmafile','extern "C" {')
WRITELN('pragmafile',"#endif")
WRITELN('pragmafile',"")

fdline = READLN('fdfile') /* read line from fd-file */
DO WHILE ~EOF('fdfile') /* check, if end-of-file reached */
  SELECT
    WHEN FIND(fdline,"##base") > 0 THEN /* get base name */
    DO
      PARSE VAR fdline . base .

      IF LEFT(base,1) == '_' THEN /* strip '_' from base name */
        base = RIGHT(base,LENGTH(base) - '1')
    END

    WHEN VERIFY(UPPER(LEFT(fdline,1)),"ABCDEFGHIJKLMNOPQRSTUVWXYZ") == 0 THEN /* get line with fd-function description */
    DO
      PARSE VAR fdline function '(' parameter ')' register .
      register = TRANSLATE(register,"0123456789AaDd,","0123456789AaDd/")

      WRITELN('pragmafile',"#pragma amicall("base", 0x"D2X(offset)", "function""register")") /* generate 'amicall' pragma */

      IF LASTPOS("TAGLIST",UPPER(parameter)) ~= 0 THEN /* for taglists, generate 'tagcall' pragma */
      DO
        index = LASTPOS("TAGLIST",UPPER(function))

        SELECT
          WHEN index ~= 0 THEN
          DO
            function = INSERT(LEFT(function,index - '1'),"Tags")
          END

          OTHERWISE /* special case, e.g. NewObjectA -> NewObject for 'tagcall' */
          DO
            function = LEFT(function,LENGTH(function) - '1')
          END
        END

        WRITELN('pragmafile',"#pragma tagcall("base", 0x"D2X(offset)", "function""register")")
      END

      offset = offset + 6 /* increase call-offset */
    END

    OTHERWISE /* do nothing */
  END

  fdline = READLN('fdfile') /* read next line from fd-file */
END

CLOSE('fdfile')

WRITELN('pragmafile',"")
WRITELN('pragmafile',"#ifdef __cplusplus")
WRITELN('pragmafile',"}")
WRITELN('pragmafile',"#endif")
WRITELN('pragmafile',"")
WRITELN('pragmafile',"#endif")

CLOSE('pragmafile')
