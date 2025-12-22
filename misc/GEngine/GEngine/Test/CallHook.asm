
   SECTION  code
   incdir   "sys:devpac/include/"
   INCLUDE  "exec/types.i"
   INCLUDE  "exec/nodes.i"

   IFND  HOOK_I
   INCLUDE  "sys:devpac/gengine/hook.i"
   ENDC

	XDEF _CallHook
      XDEF _HookEntry

_HookEntry:
	move.l  a0,-(sp)
	move.l  a2,-(sp)
	move.l  a1,-(sp)
	move.l  h_SubEntry(a0),a0
	jsr     (a0)
	lea     12(sp),sp
	rts

_CallHook:
	movem.l a0-a3,-(sp)
      move.l  28(sp),a0
	move.l  24(sp),a2
      move.l  20(sp),a1
	move.l  h_Entry(a0),a3
	jsr     (a3)
	movem.l (sp)+,a0-a3
	rts

	END