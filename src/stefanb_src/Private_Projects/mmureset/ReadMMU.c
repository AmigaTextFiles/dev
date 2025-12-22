void ReadMMU(void);

/* MMU Register */
struct RootPointer {
                    unsigned long l1;
                    unsigned long l2;
                   } crp,srp;
unsigned long tc/*,tt0,tt1*/;
/*unsigned short mmusr;*/

void main(void)
{
 printf("ReadMMU V0.01\n");
 ReadMMU();
 printf("\nMMU Registers:\n");
 printf("CRP: %08lx %08lx\n",crp.l1,crp.l2);
 printf("SRP: %08lx %08lx\n",srp.l1,srp.l2);
 printf("TC : %08lx\n",tc);

 printf("Translation ");
 if (tc&0x80000000L) printf("enabled");
 else printf("disabled");
 printf("\nSupervisor Root Pointer ");
 if (tc&0x02000000L) printf("enabled");
 else printf("disabled");
 printf("\nFunction Code Lookup ");
 if (tc&0x01000000L) printf("enabled");
 else printf("disabled");
 printf("\nPage Size: %5d Bytes\n",256<<((tc&0x00700000L)>>20));
 printf("Initial Shift: %1lx\n",(tc&0x000F0000L)>>16);
 printf("Table Index A: %1lx\n",(tc&0x0000F000L)>>12);
 printf("Table Index B: %1lx\n",(tc&0x00000F00L)>>8);
 printf("Table Index C: %1lx\n",(tc&0x000000F0L)>>4);
 printf("Table Index D: %1lx\n",tc&0x0000000FL);
}

void ReadMMU(void)
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
         ; MMURegister -> C variables
         pmove    crp,_crp
         pmove    srp,_srp
         pmove    tc,_tc
;         pmove    tt0,_tt0
;         pmove    tt1,_tt1
;         pmove     mmusr,mmusr

         move.l   d7,d0                ; go to user mode
         jsr      _LVOUserState(a6)
         jsr      _LVOEnable(a6)       ; Enable interrrupts
End:     movem.l  (a7)+,d0-d7/a0-a6
#endasm
}
