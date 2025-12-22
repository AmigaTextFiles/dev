/*
** installhook() - Use it like this:
**
**   MODULE 'utility/hooks'
**
**   PROC main()
**	DEF myhook:hook
**	installhook(myhook, {myhookfunc})
**	/* do something with myhook */
**   ENDPROC
**
**   PROC myhookfunc(hook,obj,msg)
**	WriteF('hook:$\h, obj:\d, msg:\d\n',hook,obj,msg)
**   ENDPROC
*/

PROC installhook(hook,func)
   DEF r
   MOVE.L hook,A0
   MOVE.L func,12(A0)	/* store address of func in hook.subentry */
   LEA hookentry(PC),A1
   MOVE.L A1,8(A0)	/* store address of hookentry in hook.entry */
   MOVE.L A4,16(A0)	/* store ptr to vars in hook.data */
   MOVE.L A0,r
ENDPROC r

hookentry:
  MOVEM.L D2-D7/A2-A6,-(A7)
  MOVE.L 16(A0),A4	/* move ptr to vars to A4 */
  MOVE.L A0,-(A7)	/* move ptr to hookstructure to the stack */
  MOVE.L A2,-(A7)	/* move ptr to obj to the stack */
  MOVE.L A1,-(A7)	/* move msg to the stack */
  MOVE.L 12(A0),A0	/* move addr. of hookfunc. to A0 */
  JSR (A0)		/* call hookfunc. */
  LEA 12(A7),A7		/* remove the above from the stack */
  MOVEM.L (A7)+,D2-D7/A2-A6
  RTS			/* go back to the caller (MUI) */
