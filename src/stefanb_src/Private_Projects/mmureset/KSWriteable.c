void DoRemove(void);

long tc=0,tmptc=0;

void main(void)
{
 printf("KSWriteable V0.01\n");
 DoRemove();
}

void DoRemove(void)
{
#asm
         machine  mc68020
         mc68851
         xref     _LVODisable,_LVOEnable
         xref     _LVOSuperState
         xref     _LVOUserState

Start:   movem.l  d0-d7/a0-a6,-(a7)
         move.l   $4,a6
         jsr      _LVODisable(a6)      ; Disable interrupts
         jsr      _LVOSuperState(a6)   ; go to supervisor mode
         move.l   d0,d7
MagicCode:
         pmove    tc,_tmptc            ; Save TC
         pmove    _tc,tc               ; disable MMU
         move.l   #$07F80019,$07FFF378 ; Remove write protection from
         move.l   #$07F80019,$07FFF37C ; MMU Table for Kickstart RAM
         pmove    _tmptc,tc            ; Restore TC

         move.l   d7,d0                ; go to user mode
         jsr      _LVOUserState(a6)
         jsr      _LVOEnable(a6)       ; Enable interrrupts
End:     movem.l  (a7)+,d0-d7/a0-a6
#endasm
}
