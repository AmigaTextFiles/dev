main()
{
 puts("Start...");

 Test("Test: %ld %ld  %ld-%ld-%ld-%ld\n",12345,54321,1,2,3,4);

 puts("Ende!");
}


/*
   movem.l sichert:
   zuerst angeg. Adressregister von A7-A0, dann Datenregister D7-D0
   Anmerk.: UMGEKEHRTE REIHENFOLGE!
*/



/* Test(a1,a0,a2,d7,d1,d3,d4) */
#asm
   machine mc68020
   public _Test
   public _printf
_Test:                   ; Linker-Library
   move.l 4(sp),a1
   move.l 8(sp),a0
   move.l 12(sp),a2
   move.l 16(sp),d7
   move.l 20(sp),d1
   move.l 24(sp),d3
   move.l 28(sp),d4
   jmp .TestLib

.TestLib:                ; Assembler-Teil der Library
   movem.l d3/d4,-(sp)
   move.l d1,-(sp)
   move.l d7,-(sp)
   movem.l a0/a2,-(sp)
   move.l a1,-(sp)
   jsr _printf

   add.w #28,sp
   rts
#endasm

