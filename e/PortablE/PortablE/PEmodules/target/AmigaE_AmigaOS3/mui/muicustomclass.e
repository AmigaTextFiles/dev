OPT NATIVE, INLINE
MODULE 'muimaster', 'libraries/mui', 'intuition/classes'
MODULE 'exec/libraries', 'exec/types'
{MODULE 'mui/muicustomclass'}

/*****************************************************
** Easy use of MUI-custom-classes in E.
** Written by Jan Hendrik Schulz
**
** Usage: Simply use eMui_CreateCustomClass() instead of
**        the original Mui_CreateCustomClass()-function.
**        Your dispatcher-function should look like this:
**
**        PROC myDispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
**            DEF methodID
**
**            methodID:=msg.methodid
**            SELECT methodID
**                CASE ...
**                ...
**            ENDSELECT
**
**            RETURN doSuperMethodA(cl,obj,msg)
**        ENDPROC
******************************************************/

NATIVE {data} OBJECT

NATIVE {eMui_CreateCustomClass} PROC
PROC eMui_CreateCustomClass(base:PTR TO lib, supername:ARRAY OF CHAR, supermcc:PTR TO mui_customclass, datasize:VALUE, dispfunc:PTR) IS NATIVE {eMui_CreateCustomClass(} base {,} supername {,} supermcc {,} datasize {,} dispfunc {)} ENDNATIVE !!PTR TO mui_customclass

NATIVE {dispentry} PROC
