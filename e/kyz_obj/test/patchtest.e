-> A little patch that reverses the text in the gadgets of requesters.

OPT OSVERSION=37,PREPROCESS

MODULE 'dos/dos',  'exec/memory', 'exec/semaphores',
       'intuition/intuition', '*patch'

#define REQ(x,y) EasyRequestArgs(NIL, [20, 0, 'patchtest', x, y], 0, 0)

PROC main() HANDLE
  DEF es=NIL:PTR TO patch

  -> install patch  (_LVOEasyRequestArgs = -588)
  NEW es.install(intuitionbase, -588, {neweasy})

  -> and now enable our patch so it actually functions
  es.enable()

  REQ('Requester choices now read backwards\nCtrl-C to exit', 'OK')

  Wait(SIGBREAKF_CTRL_C) -> wait for Ctrl-C

  es.disable()

  IF es.remove() = FALSE
    -> if initial attempt to remove patch fails...
    REQ('Program will quit when all requesters close.', 'Including this one')
  ENDIF

EXCEPT DO
  END es -> remove and uninstall patch
ENDPROC


-> the actual patch. This will be called from any process
-> or task that thinks it's calling EasyRequestArgs()

-> (apologies for the 'branching out' and using highly unoptimised code -
-> real world patches should be conservative with variables and calls to
-> minimise stack usage)

#define REGISTERS a7, a6, a5, a4, a3, a2, a1:PTR TO easystruct, a0, \
                  d7, d6, d5, d4, d3, d2, d1, d0

-> EasyRequestArgs(window,easyStruct,idcmpPtr,args)(a0/a1/a2/a3)

PROC neweasy(entry, REGISTERS)
  DEF resp:REG

  resp := a1.gadgetformat

  -> reverse the string in the responses field.
  reverse(resp)

  -> setup args for original function
  MOVE.L a0, A0
  MOVE.L a1, A1
  MOVE.L a2, A2
  MOVE.L a3, A3
  MOVE.L a6, A6

  -> call original function
  MOVE.L A4, -(A7)
  MOVE.L entry, A4
  JSR	 (A4)
  MOVE.L (A7)+, A4

  -> collect result
  MOVE.L D0, d0

  -> reverse the string back again
  reverse(resp)

  -> reverse the user's choice to match the real gadget
ENDPROC IF d0 = 1 THEN 0 ELSE IF d0 = 0 THEN 1 ELSE bars(resp) + 2 - d0


PROC reverse(str)
  -> reverses the text in a normal string
  DEF end:REG, len:REG, pos:REG, swap:REG

  len := StrLen(str)
  end := str + len - 1

  FOR pos := 0 TO (len-1)/2
    swap      := str[pos]
    str[pos]  := end[-pos]
    end[-pos] := swap
  ENDFOR
ENDPROC


PROC bars(str)
  -> returns a count of '|' symbols in a string
  DEF count=0:REG, pos:REG
  FOR pos := 0 TO StrLen(str) DO IF str[pos] = "|" THEN INC count
ENDPROC count
