;
; ----------------------------
;
; PureBasic InLine ASM example
;
; ----------------------------
;
; Note: This example is only for programmers who already knows
;       the asm low-level langage.
;
; General Informations:
;
; + Always disable the debugger before doing an asm routine with
;   'DisableDebugger'.
;
; + You can use the Pointers or variables directly in the ASM code.
;   But they must be declared BEFORE. Arrays, LinkedList or
;   structures variables are not allowed.
;
; + All instructions from 68000 to 68060 are supported ! Read the
;   PhxAss.guide or any 680x0 document for more infos.
;   For now the FPU or MMU instructions are lacking (who need them ?)
;
; + When you reference a label, the prefix 'p' MUST be 
;   put before the label. It's annoying but it's the only
;   solution for now. It will may be change later.
;
; + The ASM errors are not signaled by PureBasic but by PhxAss. It will
;   open a cli window and display a message. Check you ASM.
; 


*Intuition = IntuitionBase()
*Dos       = DosBase()

Result.l   = 0

Dim Hello.l(100)

ArrayHello.l = @Hello()

;
; ASM Start here. We can use following registers: d0 to d7, a0,a1,a2,a5,a6 (and a7 but it's the stack)
; You can use the register a3 if NO strings are used at any point of
; the program, else it's forbidden !

DisableDebugger

  MOVE.l  *Intuition,a6 ; Get the IntuitionBase pointer. PureBasic open and close the libraries for us :)
  MOVE.l  #0,a0         ; No parameters (big borderless window)
  MOVE.l  #0,a1         ; 
  JSR    -$25e(a6)      ; OpenWindowTagList(*Window, TagList) a0/a1
  TST.l   d0            ;
  BEQ     l_endprogram  ; If the window isn't opened, quit.
                        ; Note the 'p' before the label, it's needed.
  MOVE.l  d0,d2         ; Save the value for later use
  MOVE.l  *Dos,a6       ;
  MOVEQ   #100,d1       ; Call the Delay() function from DOS library
  JSR    -$c6(a6)       ; Wait 2 seconds
                      
  MOVE.l  *Intuition,a6 ;
  MOVE.l  d2,a0         ; Use our previously saved value
  JSR    -$48(a6)       ; Close the window...

  MOVE.l  #1,Result     ; Set the Result value to TRUE.

  MOVEQ   #100,d0
  MOVE.l  ArrayHello,a0

;
; You can put any number on instructions on the same line:
;

FillArray:
  MOVE.l  #23,(a0)+ : SUBQ.l #1,d0 : BNE l_fillarray ; The same as 'For k=0 to 100 : Hello(k) = 23 : Next'
                                                     ; but much faster.
EndProgram:

EnableDebugger

Print("'Result' value is: ") : PrintNumberN(Result)

For k=0 To 5              ; Prove it !
  PrintNumberN(Hello(k))  ;
Next                      ;

MouseWait()

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=PureBasic:Examples/Sources/
; Debugger=1
; EnableASM=1
