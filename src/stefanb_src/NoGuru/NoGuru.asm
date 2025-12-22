*
* NoGuru:  Residentes Modul, das beim Reset den Eintrag LastAlert der ExecBase
*          löscht. Damit wird der Guru-Routine vorgegaukelt, dass ein ganz
*          normaler Reset vorlag.
*
*    V1.01  (c) 3.5.1990 by Stefan Becker (private Version)
*

*
* INCLUDEDATEIEN
*

         INCLUDE  "exec/execbase.i"
         INCLUDE  "exec/ables.i"
         INCLUDE  "exec/memory.i"
         INCLUDE  "exec/resident.i"

*
* MACROS
*

XLIB     MACRO
         XREF     _LVO\1
         ENDM

CALLSYS  MACRO
         jsr      _LVO\1(a6)
         ENDM

*
* KONSTANTEN
*

_AbsExecBase   EQU   4
_intena        EQU   $dff09a

*
* BETRIEBSYSTEMAUFRUFE
*

         XLIB  AllocAbs
         XLIB  AllocMem
         XLIB  CloseLibrary
         XLIB  FindResident
         XLIB  Forbid
         XLIB  Insert
         XLIB  OpenLibrary
         XLIB  Output
         XLIB  Permit
         XLIB  Remove
         XLIB  SumKick     ; Sollte SumKickData heissen, aber MANX....
         XLIB  Write

*
* HAUPTPROGRAMM
*

         CSEG

Start    movem.l  d2-d3/a2-a4/a6,-(a7) ; Register retten
         move.l   _AbsExecBase,a6      ; Hole ExecBase

         lea.l    DosName,a1           ; Öffne dos.library
         clr.l    d0
         CALLSYS  OpenLibrary
         tst.l    d0                   ; Erfolg ?
         bne.s    Cont1                ; Ja --> weiter im Programm

         moveq    #20,d3               ; Fehlercode
         bra      Ende                 ; Abbruch

Cont1    move.l   d0,a3                ; Adresse nach A3

         move.l   d0,a6                ; Hole Ausgabegerät
         CALLSYS  Output
         move.l   d0,a4                ; Handle nach A4

         lea.l    RName,a1             ; Suche residentes Modul
         move.l   _AbsExecBase,a6
         CALLSYS  FindResident
         tst.l    d0                   ; Schon vorhanden?
         beq.s    Cont2                ; Nein --> NoGuru installieren

         move.l   a3,a6                ; Meldung 1 ausgeben
         move.l   a4,d1
         move.l   #Mesg1,d2
         moveq    #26,d3
         CALLSYS  Write

         clr.l    d3                   ; alles klar
         bra      Ende1

Cont2    move.l   #REnde-RBegin,d0     ; Hole Speicher für Modul
         move.l   #MEMF_CHIP|MEMF_PUBLIC,d1  ; Typ
         CALLSYS  AllocMem
         tst.l    d0                   ; Erfolg?
         bne.s    Cont3                ; Ja --> weiter machen

         move.l   a3,a6                ; Meldung 2 ausgeben
         move.l   a4,d1
         move.l   #Mesg2,d2
         moveq    #19,d3
         CALLSYS  Write

         moveq    #20,d3               ; Fehlercode
         bra      Ende1                ; Abbruch

Cont3    move.l   d0,a2                ; Adresse nach A2

         lea.l    RBegin,a0            ; Modul verschieben
         move.l   a2,a1
         move.w   #(REnde-RBegin-1)/4,d0
CLoop    move.l   (a0)+,(a1)+
         dbra     d0,CLoop

         move.l   a2,d0                ; Modul relozieren
         move.l   d0,RB1-RBegin(a2)    ; RBegin
         move.l   d0,RKTag-RBegin(a2)
         move.l   d0,RB3-RBegin(a2)
         lea.l    REnde-RBegin(a2),a0  ; REnde
         move.l   a0,RE1-RBegin(a2)
         lea.l    RName-RBegin(a2),a0  ; RName
         move.l   a0,RN1-RBegin(a2)
         move.l   a0,RN2-RBegin(a2)
         lea.l    RID-RBegin(a2),a0    ; RID
         move.l   a0,RI1-RBegin(a2)
         lea.l    RCode-RBegin(a2),a0  ; RCode
         move.l   a0,RC1-RBegin(a2)

                                       ; Modul resident machen
         DISABLE                       ; Interrupts aus

         lea      RMem-RBegin(a2),a0   ; Adresse MemList Struktur
         move.l   KickMemPtr(a6),(a0)  ; in die Liste einhängen
         move.l   a0,KickMemPtr(a6)

         lea      RKTag-RBegin(a2),a0  ; Adresse KickTag-Eintrag
         move.l   KickTagPtr(a6),4(a0) ; in die Liste einhängen
         beq.s    Last                 ; =0? Ja --> Letzter Eintrag

         bset.b   #7,4(a0)             ; Nein --> Flag setzen

Last     move.l   a0,KickTagPtr(a6)    ; Adresse eintragen
         CALLSYS  SumKick              ; Checksumme berechnen
         move.l   d0,KickCheckSum(a6)  ; und speichern

         ENABLE                        ; Interrupts ein

         jsr      RCode-RBegin(a2)     ; Modul aufrufen

         move.l   a3,a6                ; Meldung 3 ausgeben
         move.l   a4,d1
         move.l   #Mesg3,d2
         moveq    #23,d3
         CALLSYS  Write

         clr.l    d3                   ; alles klar

Ende1    move.l   a3,a1                ; Schliesse dos.library
         move.l   _AbsExecBase,a6
         CALLSYS  CloseLibrary

Ende     move.l   d3,d0                ; Returncode in D0
         movem.l  (a7)+,d2-d3/a2-a4/a6 ; Register holen
         rts

*
* Texte
*

DosName  DC.B     "dos.library",0
         even
Mesg1    DC.B     "NoGuru already installed!",10
         even
Mesg2    DC.B     "Not enough memory!",10
         even
Mesg3    DC.B     "NoGuru V1.01 installed",10

*
* Beginn des residenten Moduls
*

         CNOP     0,4

RBegin   DC.W     RTC_MATCHWORD
RB1      DC.L     RBegin
RE1      DC.L     REnde
         DC.B     RTF_COLDSTART
         DC.B     1                    ; Version
         DC.B     NT_UNKNOWN           ; Typ
         DC.B     105                  ; Priorität (direkt nach expansion.lib.)
RN1      DC.L     RName
RI1      DC.L     RID
RC1      DC.L     RCode
RName    DC.B     "NoGuru",0
         even
RID      DC.B     "NoGuru-Modul V1.01 (c) 3.5.1990 by Stefan Becker",13,10,0
         even

RKTag    DC.L     RBegin               ; Eintrag für KickTag-Feld
         DC.L     0

RMem     DC.L     0                    ; MemList Struktur
         DC.L     0
         DC.B     NT_MEMORY            ; Typ
         DC.B     0                    ; Priorität
RN2      DC.L     RName
         DC.W     1                    ; 1 Eintrag
RB3      DC.L     RBegin               ; Adresse
         DC.L     REnde-RBegin         ; Länge in Bytes

RCode:
         movem.l  d2-d3/a2/a6,-(a7)    ; Register retten

; Setze GURU zurück
         move.l   _AbsExecBase,a6
         moveq    #-1,d0               ; Setze LastAlert=-1
         move.l   d0,LastAlert(a6)
         clr.l    d0
         move.l   d0,0                 ; Lösche Adresse 0

; FastMemFirst
         CALLSYS  Forbid               ; Monotasking...

         move.l   LH_HEAD+MemList(a6),a0  ; Hole Anfang der Memory List
         moveq    #0,d2                ; Lösche Flags
         moveq    #0,d3

TestEOL:
         tst.l    (a0)                 ; Listenende erreicht?
         beq.s    EndOfList            ; Ja --> fertig

         tst.l    d2                   ; Schon SlowRAM gefunden?
         bne.s    TestCRAM             ; Ja   --> Teste auf ChipRAM
         cmp.l    #$C00000,a0          ; Adresse => $C00000?
         bcs.s    TestCRAM             ; Nein --> Teste auf ChipRAM
         cmp.l    #$D00000,a0          ; Adresse <  $D00000?
         bcc.s    TestCRAM             ; Nein --> Teste auf ChipRAM
                                       ; Ist der Speicher FastMem und Public?
         cmp.w    #MEMF_FAST|MEMF_PUBLIC,MH_ATTRIBUTES(a0)
         bne.s    TestCRAM             ; Nein --> Teste auf ChipRAM
         move.l   a0,d2                ; Rette Addresse

TestCRAM:
         tst.l    d3                   ; Schon ChipRAM gefunden?
         bne.s    NextInList           ; Ja   --> Nächste Node testen
                                       ; Ist der Speicher ChipMem und Public?
         cmp.w    #MEMF_CHIP|MEMF_PUBLIC,MH_ATTRIBUTES(a0)
         bne.s    NextInList           ; Nein --> Nächste Node testen
         move.l   LN_PRED(a0),d3       ; Adresse der vorhergehend Node nach D3

NextInList:
         SUCC     a0,a0                ; Hole nachfolgende Memory Node
         bra.s    TestEOL              ; Schleifenende

EndOfList:
         tst.l    d2                   ; Haben wir SlowRAM gefunden?
         beq.s    FMFDone              ; Nein --> Fertig
         cmp.l    d2,d3                ; Ist diese Node die vorhergehende Node
                                       ; zum ChipRAM?
         beq.s    FMFDone              ; Ja   --> Fertig

         move.l   d2,a1                ; SlowRAM Node aus der Memory List ent-
         CALLSYS  Remove               ; fernen

         lea      MemList(a6),a0       ; SlowRAM Node vor der ChipRAM Node in
         move.l   d2,a1                ; die Memory List einfügen
         move.l   d3,a2
         CALLSYS  Insert

FMFDone
         CALLSYS  Permit               ; ...und nun wieder Multitasking

; Sperre defekte Speicherzelle
         move.l   #$c40308,a1          ; defekte Addresse bei $c40308
         moveq    #8,d0                ; 8 Bytes
         CALLSYS  AllocAbs             ; absolut allozieren

         movem.l  (a7)+,d2-d3/a2/a6    ; Register holen
         rts

         CNOP     0,4
REnde:

*
* ENDE DER ASSEMBLERDATEI
*

         END
