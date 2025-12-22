/*
** installhook2() - Use it like this:
**
**   MODULE 'utility/hooks'
**
**   PROC main()
**	DEF myhook:hook
**	installhook2(myhook, {myhookfunc})
**	/* do something with myhook */
**   ENDPROC
**
**   PROC myhookfunc(obj,msg)
**	WriteF('obj:\d, msg:\d\n',hook,obj,msg)
**   ENDPROC
*/

PROC installhook2(hook,func)
   DEF r
   MOVE.L hook,A0
   MOVE.L func,12(A0)	/* store address of func in hook.subentry */
   LEA hookentry2(PC),A1
   MOVE.L A1,8(A0)	/* store address of hookentry in hook.entry */
   MOVE.L A4,16(A0)	/* store ptr to vars in hook.data */
   MOVE.L A0,r
ENDPROC r

hookentry2:
  MOVEM.L D2-D7/A2-A6,-(A7)
  MOVE.L 16(A0),A4	/* move ptr to vars to A4 */
  /* no ptr to the hookstructure is given to the hookfunc */
  MOVE.L A2,-(A7)	/* move ptr to obj to the stack */
  MOVE.L A1,-(A7)	/* move msg to the stack */
  MOVE.L 12(A0),A0	/* move addr. of hookfunc. to A0 */
  JSR (A0)		/* call hookfunc. */
  LEA 8(A7),A7		/* remove the above from the stack */
  MOVEM.L (A7)+,D2-D7/A2-A6
  RTS			/* go back to the caller (MUI) */
