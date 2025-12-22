main()
{
 printf("Removing Kickstart...\n");

#asm
         machine  mc68020
         mc68851
         xref     _LVODisable
         xref     _LVOSuperState

Start:
         move.l   $4,a6                ; get ExecBase
         jsr      _LVODisable(a6)      ; disable interrupts
         jsr      _LVOSuperState(a6)   ; go to supervisor mode
         clr.l    -(sp)                ; clear top of stack
         pmove    (sp),tc              ; disable MMU
         move.l   #$0,$7FFFFFC         ; change Kickstart
loop     bra      loop                 ; infinite loop
#endasm
}
