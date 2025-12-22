/*
** !! AutoCase off !!
*/
/*
** Taken from Jason R. Hulance RkrmSrc/Exec_Library/Interrupts/vertb.e
*/

OPT MODULE

MODULE 'exec/interrupts', 'exec/memory', 'exec/nodes'
MODULE 'other/eCode'


/* The extended interrupt structure
*/
OBJECT ext_is OF is
  type:LONG
ENDOBJECT


/*
** Starts an new interrupt server.
**  type - hardware/intbits/INTB_XXX
**  code - pointer to your proc
**  data - the data you got in A1
*/
EXPORT PROC addIntServer(type, code, data, name=NIL, pri=-60) HANDLE
DEF vbint=NIL:PTR TO ext_is

  -> Allocate memory for interrupt node.
  vbint:=NewM(SIZEOF ext_is, MEMF_PUBLIC OR MEMF_CLEAR)
  vbint.ln.type:=NT_INTERRUPT  -> Initialise the node.
  vbint.ln.pri :=pri
  vbint.ln.name:=name
  vbint.data:=data
  vbint.code:=eCodeIntServer(code)
  IF vbint.code=NIL THEN Raise("INTR")
  vbint.type:=type                      -> Remeber the type

  AddIntServer(type, vbint)     -> Kick this interrupt server into life.

EXCEPT

  IF vbint THEN Dispose(vbint)
  ReThrow()

ENDPROC vbint


/*
** Removes an interrupt server installed by addIntServer().
** returns NIL.
*/
EXPORT PROC remIntServer(vbint:PTR TO ext_is)

  IF vbint
    RemIntServer(vbint.type, vbint)   -> Kill interrupt server
    eCodeDispose(vbint.code)          -> free eCodeIntServer() memory
    Dispose(vbint)
  ENDIF

ENDPROC NIL

