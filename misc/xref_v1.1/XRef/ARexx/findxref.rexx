/*
** $PROJECT: ARexx script to find some xref entries
**
** $VER: findxref.rexx 1.4 (08.01.95)
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
** 30.11.94 : 001.003 : LoadXRef() added
** 26.11.94 : 001.002 : now it works with xref.library v1.19
** 20.11.94 : 001.001 : initial
*/

OPTIONS RESULTS               /* use results */

IF ~SHOW('L','rexxxref.library') THEN
    CALL ADDLIB('rexxxref.library',0,-30)

IF LoadXRef('sys_autodoc.xref') THEN
   Say "sys_autodoc.xref loaded !"

IF FindXRef("#?Window#?",,10) THEN
    DO i = 1 TO xref.count
        Say "XRef     : " xref.i.Name
        Say "Type     : " xref.i.Type
        Say "NodeName : " xref.i.NodeName
        Say "File     : " xref.i.File
        Say "Path     : " xref.i.Path
        Say "Line     : " xref.i.Line
        Say "--------------------------------------------------------"
    END
else
    Say "FindXRef() nothing found !"
EXIT

