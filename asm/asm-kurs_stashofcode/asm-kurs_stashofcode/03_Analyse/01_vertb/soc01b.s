
; soc01b.s	

; a) erklärt Speichern und Wiederherstellen der Interrupt-Vektoren

start:
	btst #6,$BFE001
	bne start

; Interrupt-Vektoren

	movea.l VBRPointer,a0		; 20 cy		; den Inhalt von VBRPointer nach a0 laden hier 0
	lea $64(a0),a0				; 8 cy
	lea vectors,a1
	REPT 6						; Hardware-Interrupts erzeugen Interrupts der Stufen 1 bis 6, 
								; die den Vektoren 25 bis 30 entsprechen und auf die Adressen
								; $64 bis $78 zeigen
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

	nop
; Interruptvektoren wiederherstellen

	movea.l VBRPointer,a0
	lea $64(a0),a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR
	
	rts

_rte:
	rte

	; Daten

VBRPointer:			DC.L 0
vectors:			BLK.L 6

	end

;------------------------------------------------------------------------------
; WinUAE-Debugger öffnen mit Shift+F12

>d pc 20
00026518 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00026520 6600 fff6                bne.w #$fff6 == $00026518 (T)
00026524 2079 0002 6586           movea.l $00026586 [00000000],a0
0002652a 41e8 0064                lea.l (a0,$0064) == $000000e0,a0			; a0 = $26586
0002652e 43f9 0002 658a           lea.l $0002658a,a1						; a1 = $2658a hier werden die "alten" Adressen abgelegt
00026534 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]	; wird 6x wiederholt
00026536 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]		; an der Adresse ist nur ein rte
0002653c 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]
0002653e 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]
00026544 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]
00026546 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]
0002654c 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]
0002654e 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]
00026554 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]
00026556 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]
0002655c 22d0                     move.l (a0) [00fc0e86],(a1)+ [00000000]
0002655e 20fc 0002 6584           move.l #$00026584,(a0)+ [00fc0e86]
00026564 4e71                     nop
00026566 2079 0002 6586           movea.l $00026586 [00000000],a0
0002656c 41e8 0064                lea.l (a0,$0064) == $000000e0,a0
00026570 43f9 0002 658a           lea.l $0002658a,a1
00026576 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]	; zurückkopieren
00026578 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]
0002657a 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]
0002657c 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]
0002657e 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]
00026580 20d9                     move.l (a1)+ [00000000],(a0)+ [00fc0e86]
00026582 4e75                     rts  == $00c4f6d0
00026584 4e73                     rte  == $f6d02030
00026586 0000 0000                or.b #$00,d0
0002658a 0000 0000                or.b #$00,d0
0002658e 0000 0000                or.b #$00,d0
>i
$00000000 00:    Reset:SSP $00000000  $00000080 32:      TRAP 00 $00FC0836
$00000004 01:     EXECBASE $00C00276  $00000084 33:      TRAP 01 $00FC0838
$00000008 02:    BUS ERROR $00FC0818  $00000088 34:      TRAP 02 $00FC083A
$0000000C 03:    ADR ERROR $00FC081A  $0000008C 35:      TRAP 03 $00FC083C
$00000010 04:    ILLEG OPC $00FC081C  $00000090 36:      TRAP 04 $00FC083E
$00000014 05:     DIV BY 0 $00FC081E  $00000094 37:      TRAP 05 $00FC0840
$00000018 06:          CHK $00FC0820  $00000098 38:      TRAP 06 $00FC0842
$0000001C 07:        TRAPV $00FC0822  $0000009C 39:      TRAP 07 $00FC0844
$00000020 08:   PRIVIL VIO $00FC090E  $000000A0 40:      TRAP 08 $00FC0846
$00000024 09:        TRACE $00FC0826  $000000A4 41:      TRAP 09 $00FC0848
$00000028 10:    LINEA EMU $00FC0828  $000000A8 42:      TRAP 10 $00FC084A
$0000002C 11:    LINEF EMU $00FC082A  $000000AC 43:      TRAP 11 $00FC084C
$00000038 14:   FORMAT ERR $00FC0830  $000000B0 44:      TRAP 12 $00FC084E
$0000003C 15:   INT Uninit $00FC0832  $000000B4 45:      TRAP 13 $00FC0850
$00000060 24:   INT Unjust $00FC0834  $000000B8 46:      TRAP 14 $00FC0852
$00000064 25:    Lvl 1 Int $00FC0C8E  $000000BC 47:      TRAP 15 $00FC0854
$00000068 26:    Lvl 2 Int $00FC0CE2
$0000006C 27:    Lvl 3 Int $00FC0D14
$00000070 28:    Lvl 4 Int $00FC0D6C
$00000074 29:    Lvl 5 Int $00FC0DFA
$00000078 30:    Lvl 6 Int $00FC0E40
$0000007C 31:          NMI $00FC0E86
>f 26524
Breakpoint added.
>g


>m 26586
00026586 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026596 0000 0000 0000 0000 0000 0000 0000 1234  ...............4
000265A6 5678 0101 0000 000E 0101 0000 0018 0101  Vx..............
000265B6 0000 0020 0101 0000 0028 0101 0000 0030  ... .....(.....0
>fi nop
Cycles: 140 Chip, 280 CPU. (V=210 H=24 -> V=210 H=164)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0000007C   A1 000265A2   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF0
USP  00C5FDF0 ISP  00C60DF0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 2079 (MOVEA) Chip latch 00000000
00026564 4e71                     nop
Next PC: 00026566
>i
$00000000 00:    Reset:SSP $00000000  $00000080 32:      TRAP 00 $00FC0836
$00000004 01:     EXECBASE $00C00276  $00000084 33:      TRAP 01 $00FC0838
$00000008 02:    BUS ERROR $00FC0818  $00000088 34:      TRAP 02 $00FC083A
$0000000C 03:    ADR ERROR $00FC081A  $0000008C 35:      TRAP 03 $00FC083C
$00000010 04:    ILLEG OPC $00FC081C  $00000090 36:      TRAP 04 $00FC083E
$00000014 05:     DIV BY 0 $00FC081E  $00000094 37:      TRAP 05 $00FC0840
$00000018 06:          CHK $00FC0820  $00000098 38:      TRAP 06 $00FC0842
$0000001C 07:        TRAPV $00FC0822  $0000009C 39:      TRAP 07 $00FC0844
$00000020 08:   PRIVIL VIO $00FC090E  $000000A0 40:      TRAP 08 $00FC0846
$00000024 09:        TRACE $00FC0826  $000000A4 41:      TRAP 09 $00FC0848
$00000028 10:    LINEA EMU $00FC0828  $000000A8 42:      TRAP 10 $00FC084A
$0000002C 11:    LINEF EMU $00FC082A  $000000AC 43:      TRAP 11 $00FC084C
$00000038 14:   FORMAT ERR $00FC0830  $000000B0 44:      TRAP 12 $00FC084E
$0000003C 15:   INT Uninit $00FC0832  $000000B4 45:      TRAP 13 $00FC0850
$00000060 24:   INT Unjust $00FC0834  $000000B8 46:      TRAP 14 $00FC0852
$00000064 25:    Lvl 1 Int $00026584  $000000BC 47:      TRAP 15 $00FC0854		; Lvl 1 bis 6 Adresse von $00026584 
$00000068 26:    Lvl 2 Int $00026584
$0000006C 27:    Lvl 3 Int $00026584
$00000070 28:    Lvl 4 Int $00026584
$00000074 29:    Lvl 5 Int $00026584
$00000078 30:    Lvl 6 Int $00026584
$0000007C 31:          NMI $00FC0E86
>m 26586																		; Basis-Adresse ist 0 (Basepointer)
00026586 0000 0000 00FC 0C8E 00FC 0CE2 00FC 0D14  ................				; an der folgenden Adressen stehen die alten  Interruptadressen
00026596 00FC 0D6C 00FC 0DFA 00FC 0E40 0000 1234  ...l.......@...4
000265A6 5678 0101 0000 000E 0101 0000 0018 0101  Vx..............
000265B6 0000 0020 0101 0000 0028 0101 0000 0030  ... .....(.....0
>d 26584
00026584 4e73                     rte  == $f6d02030								; nur rte


>d pc
00026564 4e71                     nop
00026566 2079 0002 6586           movea.l $00026586 [00000000],a0
0002656c 41e8 0064                lea.l (a0,$0064) == $000000e0,a0
00026570 43f9 0002 658a           lea.l $0002658a,a1
00026576 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
00026578 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
0002657a 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
0002657c 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
0002657e 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
00026580 20d9                     move.l (a1)+ [00001234],(a0)+ [00fc0e86]
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=164 -> V=210 H=166)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0000007C   A1 000265A2   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF0
USP  00C5FDF0 ISP  00C60DF0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2079 (MOVEA) 0002 (OR) Chip latch 00000000
00026566 2079 0002 6586           movea.l $00026586 [00000000],a0
Next PC: 0002656c
>t
Cycles: 10 Chip, 20 CPU. (V=210 H=166 -> V=210 H=176)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 000265A2   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF0
USP  00C5FDF0 ISP  00C60DF0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 41e8 (LEA) 0064 (OR) Chip latch 00000000
0002656c 41e8 0064                lea.l (a0,$0064) == $00000064,a0
Next PC: 00026570
>d pc
0002656c 41e8 0064                lea.l (a0,$0064) == $00000064,a0
00026570 43f9 0002 658a           lea.l $0002658a,a1
00026576 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
00026578 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
0002657a 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
0002657c 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
0002657e 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
00026580 20d9                     move.l (a1)+ [00001234],(a0)+ [00000000]
00026582 4e75                     rts  == $00c4f6d0
00026584 4e73                     rte  == $f6d02030
>fi
Cycles: 70 Chip, 140 CPU. (V=210 H=176 -> V=211 H=19)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0000007C   A1 000265A2   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF0
USP  00C5FDF0 ISP  00C60DF0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 4e73 (RTE) Chip latch 00000000
00026582 4e75                     rts  == $00c4f6d0
Next PC: 00026584
>i
$00000000 00:    Reset:SSP $00000000  $00000080 32:      TRAP 00 $00FC0836
$00000004 01:     EXECBASE $00C00276  $00000084 33:      TRAP 01 $00FC0838
$00000008 02:    BUS ERROR $00FC0818  $00000088 34:      TRAP 02 $00FC083A
$0000000C 03:    ADR ERROR $00FC081A  $0000008C 35:      TRAP 03 $00FC083C
$00000010 04:    ILLEG OPC $00FC081C  $00000090 36:      TRAP 04 $00FC083E
$00000014 05:     DIV BY 0 $00FC081E  $00000094 37:      TRAP 05 $00FC0840
$00000018 06:          CHK $00FC0820  $00000098 38:      TRAP 06 $00FC0842
$0000001C 07:        TRAPV $00FC0822  $0000009C 39:      TRAP 07 $00FC0844
$00000020 08:   PRIVIL VIO $00FC090E  $000000A0 40:      TRAP 08 $00FC0846
$00000024 09:        TRACE $00FC0826  $000000A4 41:      TRAP 09 $00FC0848
$00000028 10:    LINEA EMU $00FC0828  $000000A8 42:      TRAP 10 $00FC084A
$0000002C 11:    LINEF EMU $00FC082A  $000000AC 43:      TRAP 11 $00FC084C
$00000038 14:   FORMAT ERR $00FC0830  $000000B0 44:      TRAP 12 $00FC084E
$0000003C 15:   INT Uninit $00FC0832  $000000B4 45:      TRAP 13 $00FC0850
$00000060 24:   INT Unjust $00FC0834  $000000B8 46:      TRAP 14 $00FC0852
$00000064 25:    Lvl 1 Int $00FC0C8E  $000000BC 47:      TRAP 15 $00FC0854		; wiederhergestellt
$00000068 26:    Lvl 2 Int $00FC0CE2
$0000006C 27:    Lvl 3 Int $00FC0D14
$00000070 28:    Lvl 4 Int $00FC0D6C
$00000074 29:    Lvl 5 Int $00FC0DFA
$00000078 30:    Lvl 6 Int $00FC0E40
$0000007C 31:          NMI $00FC0E86
>
