; removed all dx[] references and replaced with ax[] ones
; meaning, a6 is not used anymore.

#mode LIBRARY 37 1 "nodelist.library" "nodelist.library by LS 2000"

#link library.o strcmp.o

#include "LITTEL:macrofunctions/exec_lib.mf"
#include littel:lc/examples/class_lib/class_lib.i

#makefd nodelist_lib.fd _NodelistBase ; make .fd file for it

#fdef Nl_AddFirst (list,node)(a0/a1)
#fdef Nl_AddLast  (list,node)(a0/a1)
#fdef Nl_RemFirst (list)(a0)
#fdef Nl_RemLast  (list)(a0)
#fdef Nl_Remove   (list,node)(a0/a1)
#fdef Nl_Insert   (list,node,afternode)(a0/a1/a2)
#fdef Nl_Count    (list)(a0)
#fdef Nl_FindN    (list,id)(a0/d0)
#fdef Nl_FindCN   (list,id,name)(a0/d0/a1)
#fdef Nl_FindC    (list,name)(a0/a1)
#endfdef

#equ NIL 0
#equ TRUE -1
#equ FALSE 0

; the ListNode
#equ LN_PRIVATE  0  ; probably class ptr here
#equ LN_NEXT     4  ; ptr to next listlobj
#equ LN_PREV     8  ; ptr to previous listlobj
#equ LN_ID       12 ; id for this lobj
#equ LN_FIRST    16 ; ptr to first lobj of this listlobj
#equ LN_LAST     20 ; ptr to last lobj of this listlobj

#equ SIZEOF_listNODE 24

; the Node
#equ NO_PRIVATE  0  ; probably class ptr here
#equ NO_NEXT     4  ; ptr to next Lobj
#equ NO_PREV     8  ; ptr to prev Lobj
#equ NO_ID       12 ; this Lobj ID

#equ SIZEOF_NODE 16

#regpreserve a2/d4/d5  ; the IFs uses d4/d5
#libraryenv OFF



PROC Nl_AddFirst ; a0=list, a1=node
   ; a2 = firstnode

   copy a0[].LN_FIRST, a2        ; save first node in a2
   copy a1, a0[].LN_FIRST        ; copy nodeptr to list.first

   IF a2 = NIL                   ; if we are first node here
      copy a1, a0[].LN_LAST      ; copy nodeptr to list.last
   ENDIF

   copy NIL, a1[].NO_PREV        ; we have noone above us
   copy a2, a1[].NO_NEXT         ; let us point to previous top-node

   IF a2 <> NIL                  ; if there was a node already
      copy a1, a2[].NO_PREV      ; make it point to us
   ENDIF

ENDPROC a1 ; return node added

PROC Nl_AddLast ; a0=list, a1=node
   ; a2 = lastnode

   copy a0[].LN_LAST, a2        ; save last node in a2
   copy a1, a0[].LN_LAST        ; copy nodeptr to list.last

   IF a2 = NIL                  ; if we are first node here
      copy a1, a0[].LN_FIRST    ; copy nodeptr to list.first
   ENDIF

   copy NIL, a1[].NO_NEXT       ; noone after us
   copy a2, a1[].NO_PREV        ; let us point to whoever was before us

   IF a2 <> NIL                 ; if there was noone before us (emty list)
      copy a1, a2[].NO_NEXT
   ENDIF
ENDPROC a1

PROC Nl_RemFirst ; a0=list
   ; a1 = removed node
   ; a2 = next node

   copy NIL, a1                 ; default returnvalue

   IF a0[].LN_FIRST <> NIL      ; is there something to remove ?
      copy a0[].LN_FIRST, a1    ; lets get node to remove
      copy a1[].NO_NEXT, a0[].LN_FIRST ; fix gap
      IF a1[].NO_NEXT = NIL     ; if noone below us
         copy NIL, a0[].LN_LAST ;   set list.last to NIL
      ELSE                      ; elseif someone below us
         copy a1[].NO_NEXT, a2  ;   get belownode
         copy NIL, a2[].NO_PREV ;   it got no successor..
      ENDIF
   ENDIF
ENDPROC a1

PROC Nl_RemLast ; a0=list
   ; a1 = removed node
   ; a2 = previous node

   copy NIL, a1                 ; set default returnval

   IF a0[].LN_LAST <> NIL       ; is there something to remove ?
      copy a0[].LN_LAST, a1     ; get node to remove
      copy a1[].NO_PREV, a0[].LN_LAST ; set successor to first
      IF a1[].NO_PREV = NIL        ; if noone above us
         copy NIL, a0[].LN_FIRST   ;   clear list
      ELSE                         ; else
         copy a1[].NO_PREV, a2     ;   get successor
         copy NIL, a2[].NO_NEXT    ;   it got noone under it
      ENDIF
   ENDIF
ENDPROC a1

PROC Nl_Remove ; a0=list, a1=node

   IF a1[].NO_PREV = NIL        ; if there is noone above us
      dpr Nl_RemFirst           ; RemFirst us, as we are first
      RET                       ; and return
   ENDIF

   IF a1[].NO_NEXT = NIL        ; if there is noone under us
      dpr Nl_RemLast            ; RemLast us, as we are last
      RET                       ; and return
   ENDIF
           ; we are somewhere in the middle

   ; a0=previous node
   ; a2=next node

   copy a1[].NO_PREV, a0  ; save ptr to previous
   copy a1[].NO_NEXT, a2  ; save ptr to next
   copy a2, a0[].NO_NEXT  ; make previous point to next
   copy a0, a2[].NO_PREV  ; make next point to previous

ENDPROC a1

PROC Nl_Insert ; a0=list, a1=node, a2=afterthis

   IF a2[].NO_NEXT = NIL ; if we go last
      dpr Nl_AddLast     ; addlast us
      RET                ; and return
   ENDIF

   ; a0 = next node

   copy a2[].NO_NEXT, a0  ; save afterthis.next in a0
   copy a1, a2[].NO_NEXT  ; copy node to afterthis.next
   copy a2, a1[].NO_PREV  ; copy afterthis to node.prev
   copy a0, a1[].NO_NEXT  ; copy afterthis.next to node.next
   copy a1, a0[].NO_PREV  ; copy node to afterthis.next.prev

ENDPROC a1

PROC Nl_Count ; a0=list
   ; a1=node
   ; d0=count

   copy NIL, d0              ; reset counter
   copy a0[].LN_FIRST, a1    ; get first node
   WHILE a1 <> NIL           ; while node
      inc d0                 ; inc counter
      copy a1[].NO_NEXT, a1  ; node := node.next
   ENDWHILE

ENDPROC ; count is returned in d0

; find first node with nodeid
PROC Nl_FindN ; a0=list, d0=id
   ; a1 = node

   copy a0[].LN_FIRST, a1            ; get first node
   WHILE a1 <> NIL                   ; while node
      IF a1[].NO_ID = d0             ; if node.id = id
         RET a1                      ; return node
      ENDIF
      copy a1[].NO_NEXT, a1  ; node := node.next
   ENDWHILE
ENDPROC NIL

         #xref StrCmp

#regpreserve a2/a6/d4/d5 ; a6 is used for calling class.library

; find first node with classname and nodeid
PROC Nl_FindCN ; a0=list, a1=classname, d0=id
   ; a2 = node
   CODESTART ; proc is now stacksafe
   copy a0[].LN_FIRST, a2            ; get first node
   WHILE a2 <> NIL
      IF a2[].NO_ID = d0             ; if node.id = id
         rtos a0/a1/d0/d1 ; save scratch on stack
         copy a2, a0      ; copy node to a0
         call _classbase Cl_GetOCName ; classname in d0
         dpr StrCmp(a1, d0) ; result in d0
         IF d0 = TRUE \ RET a2 \ ENDIF ; return node
         stor a0/a1/d0/d1 ; restore scratch from stack
      ENDIF
      copy a2[].NO_NEXT, a2  ; node := node.next
   ENDWHILE
ENDPROC NIL

; find first node with classname
PROC Nl_FindC ; a0=list, a1=classname
   ; a2 = node
   CODESTART
   copy a0[].LN_FIRST, a2            ; get first node
   WHILE a2 <> NIL
      rtos a0/a1/d0/d1 ; save scratch on stack
      copy a2, a0      ; copy node to a0
      call _classbase Cl_GetOCName ; classname in d0
      dpr StrCmp(a1, d0) ; result in d0
      IF d0 = TRUE \ RET a2 \ ENDIF   ; return node if d0=TRUE
      stor a0/a1/d0/d1 ; restore scratch from stack
   ENDWHILE
ENDPROC NIL

#regpreserve OFF

; The 4 required functions

GVAR _classbase

PROC init
   STRING _classlibname "/class_lib/class.library"
   openlibrary _classlibname 37 _classbase
ENDPROC 1
PROC open
ENDPROC 1
PROC close
ENDPROC
PROC expunge
   closelibrary _classbase
ENDPROC

END

